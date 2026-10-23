"""Database operations for price history: seeding, gap backfill and downsampling."""

from __future__ import annotations

import json
import logging
from dataclasses import dataclass
from datetime import UTC, date, datetime, timedelta
from pathlib import Path

import numpy as np
from sqlalchemy import bindparam, func, select, text
from sqlalchemy.ext.asyncio import AsyncConnection, AsyncSession

from app.models import Coin, CoinMarket, PriceHistory
from app.simulator.model import (
    FIVE_MIN,
    STABLE_CATEGORY,
    CoinParams,
    PriceModel,
    build_timeline,
    floor_5min,
    floor_day,
)

log = logging.getLogger(__name__)

SEED_FILE = Path(__file__).resolve().parents[2] / "seed" / "coins.json"
SEED_LOCK_KEY = 815_204_001  # arbitrary constant for pg_advisory_xact_lock
HISTORY_DAYS = 365
ICON_URL = "https://cdn.jsdelivr.net/gh/spothq/cryptocurrency-icons@master/128/color/{sym}.png"


@dataclass(slots=True)
class SeedCoin:
    id: str
    symbol: str
    name: str
    category: str
    price: float
    circulating_supply: float
    total_supply: float
    max_supply: float | None
    volatility: float
    btc_correlation: float
    volume_ratio: float
    ath: float
    ath_date: str
    description: str

    @property
    def params(self) -> CoinParams:
        return CoinParams(
            self.id, self.volatility, self.btc_correlation, self.category == STABLE_CATEGORY
        )


def load_seed_coins(path: Path = SEED_FILE) -> list[SeedCoin]:
    return [SeedCoin(**row) for row in json.loads(path.read_text())]


async def _copy_history(conn: AsyncConnection, rows: list[tuple]) -> None:
    """Fast bulk insert via asyncpg COPY (seeding writes ~120k rows)."""
    raw = await conn.get_raw_connection()
    await raw.driver_connection.copy_records_to_table(
        "price_history", records=rows, columns=["coin_id", "ts", "price", "volume"]
    )


async def seed_if_empty(session: AsyncSession, model_rng: np.random.Generator, now: datetime) -> bool:
    """Insert coins, market rows and a year of history if the DB has no coins.

    Idempotent and safe under concurrent startups: an advisory transaction lock serialises
    seeders, and the emptiness check happens after acquiring it.
    """
    await session.execute(text("SELECT pg_advisory_xact_lock(:k)"), {"k": SEED_LOCK_KEY})
    if (await session.scalar(select(func.count()).select_from(Coin))) or 0:
        await session.rollback()
        return False

    seeds = load_seed_coins()
    model = PriceModel([s.params for s in seeds], model_rng)
    end = floor_5min(now)
    start = floor_day(end - timedelta(days=HISTORY_DAYS))
    timeline = [start, *build_timeline(start, end, now)]
    dts = np.array([(b - a).total_seconds() for a, b in zip(timeline, timeline[1:])])
    end_prices = np.array([s.price for s in seeds])
    paths = model.simulate_backward(end_prices, dts)  # (len(timeline), n_coins)

    base_vol_24h = np.array([s.volume_ratio * s.price * s.circulating_supply for s in seeds])
    noise = model.volume_noise(paths.shape)
    # Volume per point scales with the period length (daily vs 5-min) and with price level.
    period = np.concatenate([[86_400.0], dts])[:, None] / 86_400.0
    volumes = base_vol_24h * (paths / end_prices) * period * noise

    session.add_all(
        Coin(
            id=s.id,
            symbol=s.symbol,
            name=s.name,
            image_url=ICON_URL.format(sym=s.symbol.lower()),
            description=s.description,
            category=s.category,
            circulating_supply=s.circulating_supply,
            total_supply=s.total_supply,
            max_supply=s.max_supply,
            volatility=s.volatility,
            btc_correlation=s.btc_correlation,
        )
        for s in seeds
    )
    await session.flush()

    conn = await session.connection()
    rows = [
        (s.id, ts, float(paths[i, j]), float(volumes[i, j]))
        for j, s in enumerate(seeds)
        for i, ts in enumerate(timeline)
    ]
    await _copy_history(conn, rows)

    for j, s in enumerate(seeds):
        price = float(paths[-1, j])
        hist_max_idx = int(np.argmax(paths[:, j]))
        seed_ath_dt = datetime.combine(date.fromisoformat(s.ath_date), datetime.min.time(), UTC)
        if paths[hist_max_idx, j] > s.ath:
            ath, ath_date = float(paths[hist_max_idx, j]), timeline[hist_max_idx]
        else:
            ath, ath_date = s.ath, seed_ath_dt
        session.add(
            CoinMarket(
                coin_id=s.id,
                price=price,
                volume_24h=float(base_vol_24h[j]),
                market_cap=price * s.circulating_supply,
                change_24h_pct=0.0,
                high_24h=price,
                low_24h=price,
                ath=ath,
                ath_date=ath_date,
                updated_at=now,
            )
        )
    await session.commit()
    log.info("seeded database", extra={"coins": len(seeds), "history_rows": len(rows)})
    return True


async def backfill_gaps(session: AsyncSession, model: PriceModel, now: datetime) -> int:
    """Fill every missing history point between each coin's last stored ts and ``now``.

    Render's free tier sleeps when idle; without this the charts would show flat gaps.
    The path starts from the last known live price (coin_market) so it is continuous.
    Returns the number of inserted rows.
    """
    ids = [c.id for c in model.coins]
    last_rows = await session.execute(
        select(PriceHistory.coin_id, func.max(PriceHistory.ts)).group_by(PriceHistory.coin_id)
    )
    last_ts = {cid: ts for cid, ts in last_rows.all()}
    prices = dict((await session.execute(select(CoinMarket.coin_id, CoinMarket.price))).all())
    if not last_ts or not prices:
        return 0

    end = floor_5min(now)
    earliest = min(last_ts.get(cid, end) for cid in ids)
    timeline = build_timeline(earliest, end, now)
    if not timeline:
        return 0

    dts = np.array([(b - a).total_seconds() for a, b in zip([earliest, *timeline], timeline)])
    start = np.array([prices[cid] for cid in ids])
    paths = model.simulate_forward(start, dts)
    vol_24h = dict(
        (await session.execute(select(CoinMarket.coin_id, CoinMarket.volume_24h))).all()
    )
    noise = model.volume_noise(paths.shape)

    rows: list[tuple] = []
    for j, cid in enumerate(ids):
        coin_last = last_ts.get(cid, earliest)
        for i, ts in enumerate(timeline):
            if ts > coin_last:
                vol = vol_24h[cid] * (dts[i] / 86_400.0) * float(noise[i, j])
                rows.append((cid, ts, float(paths[i, j]), vol))

    if rows:
        conn = await session.connection()
        await _copy_history(conn, rows)
        # Carry the live price forward so the next tick continues from the backfilled path.
        table = CoinMarket.__table__
        await session.execute(
            table.update()
            .where(table.c.coin_id == bindparam("cid"))
            .values(price=bindparam("p"), updated_at=now),
            [{"cid": cid, "p": float(paths[-1, j])} for j, cid in enumerate(ids)],
        )
    await session.commit()
    log.info(
        "backfilled history",
        extra={"rows": len(rows), "from": earliest.isoformat(), "to": end.isoformat()},
    )
    return len(rows)


DOWNSAMPLE_SQL = text(
    """
    WITH old AS (
        DELETE FROM price_history
        WHERE ts < date_trunc('day', CAST(:now AS timestamptz) - interval '7 days')
          AND ts <> date_trunc('day', ts)
        RETURNING coin_id, ts, price, volume
    ), agg AS (
        SELECT coin_id,
               date_trunc('day', ts) AS day,
               (array_agg(price ORDER BY ts DESC))[1] AS close,
               sum(volume) AS volume
        FROM old
        GROUP BY coin_id, date_trunc('day', ts)
    )
    INSERT INTO price_history (coin_id, ts, price, volume)
    SELECT coin_id, day, close, volume FROM agg
    ON CONFLICT (coin_id, ts) DO UPDATE
        SET price = EXCLUDED.price,
            volume = price_history.volume + EXCLUDED.volume
    """
)


async def downsample_old_points(session: AsyncSession, now: datetime) -> int:
    """Collapse 5-minute points older than 7 days into one daily (00:00 UTC) close point."""
    result = await session.execute(DOWNSAMPLE_SQL, {"now": now})
    await session.commit()
    log.info("downsampled history", extra={"daily_rows": result.rowcount})
    return result.rowcount or 0


def next_history_slot(last_written: datetime | None, now: datetime) -> datetime | None:
    """The 5-minute slot to write at ``now`` if one is due, else None."""
    slot = floor_5min(now)
    if last_written is None or slot >= last_written + FIVE_MIN:
        return slot
    return None
