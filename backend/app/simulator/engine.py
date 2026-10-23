"""Live market simulator: owns in-memory market state and ticks it into the database."""

from __future__ import annotations

import asyncio
import contextlib
import logging
from collections.abc import Awaitable, Callable
from datetime import UTC, datetime, timedelta

import numpy as np
from sqlalchemy import bindparam, func, select, text
from sqlalchemy.dialects.postgresql import insert as pg_insert
from sqlalchemy.ext.asyncio import AsyncSession, async_sessionmaker

from app.models import Coin, CoinMarket, PriceHistory
from app.simulator.history import (
    backfill_gaps,
    downsample_old_points,
    next_history_slot,
    seed_if_empty,
)
from app.simulator.model import FIVE_MIN, STABLE_CATEGORY, CoinParams, PriceModel, make_rng

log = logging.getLogger(__name__)

Tick = dict[str, float | str]
Publisher = Callable[[list[Tick]], Awaitable[None]]

_STATS_SQL = text(
    """
    SELECT w.coin_id, w.hi, w.lo, COALESCE(r.price, w.first_price) AS ref
    FROM (
        SELECT coin_id, max(price) AS hi, min(price) AS lo,
               (array_agg(price ORDER BY ts ASC))[1] AS first_price
        FROM price_history
        WHERE ts >= :since
        GROUP BY coin_id
    ) w
    LEFT JOIN LATERAL (
        SELECT price FROM price_history p
        WHERE p.coin_id = w.coin_id AND p.ts <= :since
        ORDER BY p.ts DESC LIMIT 1
    ) r ON TRUE
    """
)


def utcnow() -> datetime:
    return datetime.now(UTC)


class MarketSimulator:
    def __init__(
        self,
        sessionmaker: async_sessionmaker[AsyncSession],
        *,
        tick_seconds: float = 10.0,
        seed: int | None = None,
        publisher: Publisher | None = None,
    ) -> None:
        self.sessionmaker = sessionmaker
        self.tick_seconds = tick_seconds
        self.rng = make_rng(seed)
        self.publisher = publisher
        self._task: asyncio.Task[None] | None = None
        self.model: PriceModel | None = None
        self.ids: list[str] = []
        self.last_tick_at: datetime | None = None
        self.last_history_ts: datetime | None = None
        self.last_downsample_day: datetime | None = None

    # ------------------------------------------------------------------ setup
    async def prepare(self, now: datetime | None = None) -> None:
        """Seed (if empty), backfill gaps, downsample, and load state. Safe to call on every boot."""
        now = now or utcnow()
        async with self.sessionmaker() as s:
            await seed_if_empty(s, self.rng, now)
        async with self.sessionmaker() as s:
            coins = (await s.execute(select(Coin).order_by(Coin.id))).scalars().all()
            params = [
                CoinParams(c.id, c.volatility, c.btc_correlation, c.category == STABLE_CATEGORY)
                for c in coins
            ]
            self.model = PriceModel(params, self.rng)
            self.ids = [c.id for c in coins]
            self.supply = np.array([c.circulating_supply for c in coins])
            await backfill_gaps(s, self.model, now)
        async with self.sessionmaker() as s:
            await downsample_old_points(s, now)
            self.last_downsample_day = now.date()
        await self._load_state(now)

    async def _load_state(self, now: datetime) -> None:
        async with self.sessionmaker() as s:
            rows = {m.coin_id: m for m in (await s.execute(select(CoinMarket))).scalars()}
            self.last_history_ts = await s.scalar(select(func.max(PriceHistory.ts)))
        markets = [rows[i] for i in self.ids]
        self.prices = np.array([m.price for m in markets])
        self.volumes = np.array([m.volume_24h for m in markets])
        self.ath = np.array([m.ath for m in markets])
        self.ath_date: list[datetime] = [m.ath_date for m in markets]
        mcap = np.maximum(self.prices * self.supply, 1e-9)
        # Anchor volume as a share of market cap so volume tracks price moves over time.
        self.volume_ratio = self.volumes / mcap
        self.last_tick_at = now
        await self._refresh_24h_stats(now)

    async def _refresh_24h_stats(self, now: datetime) -> None:
        async with self.sessionmaker() as s:
            res = await s.execute(_STATS_SQL, {"since": now - timedelta(hours=24)})
            stats = {r.coin_id: (r.hi, r.lo, r.ref) for r in res}
        self.hist_high = np.array([stats.get(i, (p, p, p))[0] for i, p in zip(self.ids, self.prices)])
        self.hist_low = np.array([stats.get(i, (p, p, p))[1] for i, p in zip(self.ids, self.prices)])
        self.ref_24h = np.array([stats.get(i, (p, p, p))[2] for i, p in zip(self.ids, self.prices)])

    # ------------------------------------------------------------------- tick
    async def tick(self, now: datetime | None = None) -> list[Tick]:
        assert self.model is not None, "prepare() must be called first"
        now = now or utcnow()
        dt = (now - self.last_tick_at).total_seconds() if self.last_tick_at else self.tick_seconds
        dt = float(min(max(dt, 1.0), 300.0))
        self.last_tick_at = now

        self.prices = self.model.step(self.prices, dt)
        mcap = self.prices * self.supply
        target_vol = self.volume_ratio * mcap * self.model.volume_noise(self.prices.shape, 0.3)
        self.volumes = 0.95 * self.volumes + 0.05 * target_vol

        new_ath = self.prices > self.ath
        self.ath = np.where(new_ath, self.prices, self.ath)
        for j in np.flatnonzero(new_ath):
            self.ath_date[j] = now

        slot = next_history_slot(self.last_history_ts, now)
        async with self.sessionmaker() as s:
            if slot is not None:
                noise = self.model.volume_noise(self.prices.shape)
                period = FIVE_MIN.total_seconds() / 86_400.0
                await s.execute(
                    pg_insert(PriceHistory)
                    .values(
                        [
                            {
                                "coin_id": cid,
                                "ts": slot,
                                "price": float(self.prices[j]),
                                "volume": float(self.volumes[j] * period * noise[j]),
                            }
                            for j, cid in enumerate(self.ids)
                        ]
                    )
                    .on_conflict_do_nothing()
                )
                self.last_history_ts = slot
            high = np.maximum(self.hist_high, self.prices)
            low = np.minimum(self.hist_low, self.prices)
            change = (self.prices / self.ref_24h - 1.0) * 100.0
            table = CoinMarket.__table__
            await s.execute(
                table.update()
                .where(table.c.coin_id == bindparam("cid"))
                .values(
                    price=bindparam("p"),
                    market_cap=bindparam("mc"),
                    volume_24h=bindparam("v"),
                    change_24h_pct=bindparam("ch"),
                    high_24h=bindparam("hi"),
                    low_24h=bindparam("lo"),
                    ath=bindparam("ath_v"),
                    ath_date=bindparam("ath_d"),
                    updated_at=now,
                ),
                [
                    {
                        "cid": cid,
                        "p": float(self.prices[j]),
                        "mc": float(mcap[j]),
                        "v": float(self.volumes[j]),
                        "ch": float(change[j]),
                        "hi": float(high[j]),
                        "lo": float(low[j]),
                        "ath_v": float(self.ath[j]),
                        "ath_d": self.ath_date[j],
                    }
                    for j, cid in enumerate(self.ids)
                ],
            )
            await s.commit()
        if slot is not None:
            await self._refresh_24h_stats(now)

        ticks: list[Tick] = [
            {"id": cid, "price": float(self.prices[j]), "change_24h": float(change[j])}
            for j, cid in enumerate(self.ids)
        ]
        if self.publisher is not None:
            await self.publisher(ticks)
        return ticks

    # ------------------------------------------------------------------- loop
    async def _run(self) -> None:
        log.info("simulator started", extra={"tick_seconds": self.tick_seconds, "coins": len(self.ids)})
        while True:
            await asyncio.sleep(self.tick_seconds)
            try:
                now = utcnow()
                await self.tick(now)
                if self.last_downsample_day != now.date():
                    async with self.sessionmaker() as s:
                        await downsample_old_points(s, now)
                    self.last_downsample_day = now.date()
            except asyncio.CancelledError:
                raise
            except Exception:  # keep ticking even if one tick fails (e.g. transient DB error)
                log.exception("simulator tick failed")

    def start(self) -> None:
        if self._task is None:
            self._task = asyncio.create_task(self._run(), name="market-simulator")

    async def stop(self) -> None:
        if self._task is not None:
            self._task.cancel()
            with contextlib.suppress(asyncio.CancelledError):
                await self._task
            self._task = None

    def snapshot(self) -> list[Tick]:
        """Latest prices for newly connected WebSocket clients."""
        if self.model is None:
            return []
        change = (self.prices / self.ref_24h - 1.0) * 100.0
        return [
            {"id": cid, "price": float(self.prices[j]), "change_24h": float(change[j])}
            for j, cid in enumerate(self.ids)
        ]
