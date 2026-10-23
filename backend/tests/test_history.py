"""Database-backed tests for seeding, backfill, downsampling and live ticks."""

from datetime import UTC, datetime, timedelta

import numpy as np
from sqlalchemy import func, select, text

from app.models import Coin, CoinMarket, PriceHistory
from app.simulator.engine import MarketSimulator
from app.simulator.history import (
    backfill_gaps,
    downsample_old_points,
    load_seed_coins,
    seed_if_empty,
)
from app.simulator.model import FIVE_MIN, STABLE_CATEGORY, CoinParams, PriceModel, floor_5min, floor_day, make_rng

NOW = datetime(2026, 10, 23, 6, 7, 30, tzinfo=UTC)


def _model(seed: int = 7) -> PriceModel:
    return PriceModel(
        [
            CoinParams(s.id, s.volatility, s.btc_correlation, s.category == STABLE_CATEGORY)
            for s in sorted(load_seed_coins(), key=lambda c: c.id)
        ],
        make_rng(seed),
    )


async def _timestamps(s, coin_id: str) -> list[datetime]:
    rows = await s.scalars(
        select(PriceHistory.ts).where(PriceHistory.coin_id == coin_id).order_by(PriceHistory.ts)
    )
    return list(rows)


async def test_seed_is_idempotent_and_ends_at_seed_price(sessionmaker) -> None:
    async with sessionmaker() as s:
        assert await seed_if_empty(s, make_rng(1), NOW) is True
    async with sessionmaker() as s:
        assert await seed_if_empty(s, make_rng(1), NOW) is False

    seeds = {c.id: c for c in load_seed_coins()}
    async with sessionmaker() as s:
        assert await s.scalar(select(func.count()).select_from(Coin)) == len(seeds)
        markets = (await s.scalars(select(CoinMarket))).all()
        assert len(markets) == len(seeds)
        for m in markets:
            seed = seeds[m.coin_id]
            if seed.category != STABLE_CATEGORY:
                assert m.price == np.float64(seed.price) or abs(m.price / seed.price - 1) < 1e-9
            assert m.market_cap == m.price * seed.circulating_supply
            assert m.ath >= m.price

        ts = await _timestamps(s, "bitcoin")
        # Spans a year; daily section then a contiguous 5-minute section up to "now".
        assert ts[0] <= NOW - timedelta(days=365)
        assert ts[-1] == floor_5min(NOW)
        cutoff = floor_day(NOW - timedelta(days=7))
        recent = [t for t in ts if t >= cutoff]
        assert all(b - a == FIVE_MIN for a, b in zip(recent, recent[1:]))
        assert all(b - a <= timedelta(days=1) for a, b in zip(ts, ts[1:]))

        low = await s.scalar(select(func.min(PriceHistory.price)))
        assert low > 0
        stable = await s.execute(
            text(
                "SELECT min(price), max(price) FROM price_history h JOIN coins c ON c.id = h.coin_id "
                "WHERE c.category = 'Stablecoin'"
            )
        )
        lo, hi = stable.one()
        assert 0.99 < lo and hi < 1.01


async def test_backfill_fills_short_gap_without_holes(sessionmaker) -> None:
    seeded_at = NOW - timedelta(hours=9, minutes=40)  # e.g. server slept for ~10h
    async with sessionmaker() as s:
        await seed_if_empty(s, make_rng(1), seeded_at)
    async with sessionmaker() as s:
        inserted = await backfill_gaps(s, _model(), NOW)

    n_coins = len(load_seed_coins())
    expected_slots = int((floor_5min(NOW) - floor_5min(seeded_at)) / FIVE_MIN)
    assert inserted == expected_slots * n_coins

    async with sessionmaker() as s:
        for coin_id in ("bitcoin", "tether", "pepe"):
            ts = await _timestamps(s, coin_id)
            recent = [t for t in ts if t >= floor_day(NOW - timedelta(days=7))]
            assert recent[-1] == floor_5min(NOW)
            assert all(b - a == FIVE_MIN for a, b in zip(recent, recent[1:]))
        # Live price continues from the backfilled path.
        last = await s.scalar(
            select(PriceHistory.price)
            .where(PriceHistory.coin_id == "bitcoin")
            .order_by(PriceHistory.ts.desc())
            .limit(1)
        )
        live = await s.scalar(select(CoinMarket.price).where(CoinMarket.coin_id == "bitcoin"))
        assert live == last
    # Running it again is a no-op.
    async with sessionmaker() as s:
        assert await backfill_gaps(s, _model(), NOW) == 0


async def test_backfill_long_gap_uses_daily_then_5min(sessionmaker) -> None:
    seeded_at = NOW - timedelta(days=12)
    async with sessionmaker() as s:
        await seed_if_empty(s, make_rng(1), seeded_at)
    async with sessionmaker() as s:
        assert await backfill_gaps(s, _model(), NOW) > 0
    async with sessionmaker() as s:
        await downsample_old_points(s, NOW)
        ts = await _timestamps(s, "ethereum")
    cutoff = floor_day(NOW - timedelta(days=7))
    old = [t for t in ts if t < cutoff]
    recent = [t for t in ts if t >= cutoff]
    assert all(t == floor_day(t) for t in old)
    assert all(b - a == timedelta(days=1) for a, b in zip(old, old[1:]))
    assert recent[0] == cutoff and recent[-1] == floor_5min(NOW)
    assert all(b - a == FIVE_MIN for a, b in zip(recent, recent[1:]))
    assert (cutoff - old[-1]) == timedelta(days=1)


async def test_downsample_keeps_daily_close(sessionmaker) -> None:
    seeded_at = NOW - timedelta(days=3)
    async with sessionmaker() as s:
        await seed_if_empty(s, make_rng(1), seeded_at)
        day = floor_day(NOW - timedelta(days=9))
        expected_close = await s.scalar(
            select(PriceHistory.price)
            .where(PriceHistory.coin_id == "solana", PriceHistory.ts < day + timedelta(days=1))
            .order_by(PriceHistory.ts.desc())
            .limit(1)
        )
        before = await s.scalar(select(func.count()).select_from(PriceHistory))
    async with sessionmaker() as s:
        await downsample_old_points(s, NOW)
    async with sessionmaker() as s:
        after = await s.scalar(select(func.count()).select_from(PriceHistory))
        close = await s.scalar(
            select(PriceHistory.price).where(PriceHistory.coin_id == "solana", PriceHistory.ts == day)
        )
        stray = await s.scalar(
            text(
                "SELECT count(*) FROM price_history WHERE ts < :cutoff AND ts <> date_trunc('day', ts)"
            ),
            {"cutoff": floor_day(NOW - timedelta(days=7))},
        )
    assert after < before
    assert stray == 0
    assert close == expected_close


async def test_engine_tick_updates_market_and_writes_history(sessionmaker) -> None:
    published: list[list[dict]] = []

    async def publish(ticks):
        published.append(ticks)

    sim = MarketSimulator(sessionmaker, tick_seconds=10, seed=123, publisher=publish)
    start = NOW - timedelta(minutes=1)
    await sim.prepare(now=start)
    ticks = []
    for k in range(1, 8):  # crosses a 5-minute boundary (06:05 -> 06:10)
        ticks = await sim.tick(now=start + timedelta(seconds=60 * k))

    assert len(published) == 7
    by_id = {t["id"]: t for t in ticks}
    assert all(t["price"] > 0 for t in ticks)
    assert abs(by_id["tether"]["price"] - 1.0) < 0.01

    async with sessionmaker() as s:
        markets = {m.coin_id: m for m in (await s.scalars(select(CoinMarket))).all()}
        coins = {c.id: c for c in (await s.scalars(select(Coin))).all()}
        for cid, m in markets.items():
            assert m.price == by_id[cid]["price"]
            assert abs(m.market_cap - m.price * coins[cid].circulating_supply) < 1e-6 * m.market_cap
            assert m.low_24h <= m.price <= m.high_24h
            assert m.ath >= m.price
            assert m.volume_24h > 0
        last = await s.scalar(select(func.max(PriceHistory.ts)))
    assert last == floor_5min(start + timedelta(minutes=7))
