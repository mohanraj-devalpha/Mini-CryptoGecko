"""Unit tests for the pure price model (no database)."""

from datetime import UTC, datetime, timedelta

import numpy as np

from app.simulator.history import load_seed_coins
from app.simulator.model import (
    FIVE_MIN,
    STABLE_BAND,
    CoinParams,
    PriceModel,
    build_timeline,
    floor_day,
    make_rng,
)

COINS = [
    CoinParams("bitcoin", 0.55, 1.0, False),
    CoinParams("ethereum", 0.70, 0.9, False),
    CoinParams("meme", 1.8, 0.1, False),
    CoinParams("tether", 0.0, 0.0, True),
]


def test_prices_stay_positive_under_extreme_volatility() -> None:
    model = PriceModel([CoinParams("wild", 5.0, 0.0, False)], make_rng(1))
    paths = model.simulate_forward(np.array([0.00001]), np.full(20_000, 300.0))
    assert (paths > 0).all()
    assert np.isfinite(paths).all()


def test_stablecoins_stay_pegged() -> None:
    model = PriceModel(COINS, make_rng(2))
    paths = model.simulate_forward(np.array([60_000, 3_000, 0.1, 1.0]), np.full(5_000, 300.0))
    stable = paths[:, 3]
    assert np.all(np.abs(stable - 1.0) <= STABLE_BAND + 1e-12)
    assert abs(stable.mean() - 1.0) < 0.001
    # Daily steps too (backfill of long gaps)
    daily = model.simulate_forward(np.array([60_000, 3_000, 0.1, 1.0]), np.full(365, 86_400.0))
    assert np.all(np.abs(daily[:, 3] - 1.0) <= STABLE_BAND + 1e-12)


def test_same_seed_is_reproducible_and_different_seed_differs() -> None:
    start = np.array([60_000, 3_000, 0.1, 1.0])
    dts = np.full(100, 300.0)
    a = PriceModel(COINS, make_rng(42)).simulate_forward(start, dts)
    b = PriceModel(COINS, make_rng(42)).simulate_forward(start, dts)
    c = PriceModel(COINS, make_rng(43)).simulate_forward(start, dts)
    np.testing.assert_array_equal(a, b)
    assert not np.allclose(a, c)


def test_btc_correlation_is_respected() -> None:
    model = PriceModel(COINS, make_rng(3))
    r = model.log_returns(np.full(20_000, 300.0))
    corr = np.corrcoef(r[:, :3].T)
    assert corr[0, 1] > 0.85  # ethereum rho=0.9
    assert abs(corr[0, 2]) < 0.2  # meme rho=0.1


def test_volatility_scale_matches_parameter() -> None:
    model = PriceModel([CoinParams("x", 0.8, 0.0, False)], make_rng(4))
    r = model.log_returns(np.full(50_000, 300.0))[:, 0]
    annualised = r.std() * np.sqrt(365 * 24 * 12)
    assert abs(annualised - 0.8) < 0.03


def test_backward_simulation_ends_at_target_price() -> None:
    model = PriceModel(COINS, make_rng(5))
    end = np.array([67_000, 3_500, 0.00002, 1.0])
    paths = model.simulate_backward(end, np.full(500, 300.0))
    assert paths.shape == (501, 4)
    np.testing.assert_allclose(paths[-1, :3], end[:3])
    assert (paths > 0).all()


def test_timeline_daily_then_five_minute() -> None:
    now = datetime(2026, 10, 23, 6, 7, tzinfo=UTC)
    start = now - timedelta(days=30)
    tl = build_timeline(start, now, now)
    cutoff = floor_day(now - timedelta(days=7))
    daily = [t for t in tl if t < cutoff]
    recent = [t for t in tl if t >= cutoff]
    assert all(t.hour == 0 and t.minute == 0 for t in daily)
    assert all(b - a == timedelta(days=1) for a, b in zip(daily, daily[1:]))
    assert all(b - a == FIVE_MIN for a, b in zip(recent, recent[1:]))
    assert recent[0] == cutoff and recent[-1] == datetime(2026, 10, 23, 6, 5, tzinfo=UTC)
    assert tl == sorted(set(tl))


def test_seed_file_is_valid() -> None:
    coins = load_seed_coins()
    assert 45 <= len(coins) <= 60
    assert len({c.id for c in coins}) == len(coins)
    cats = {c.category for c in coins}
    assert cats == {"Layer 1", "Layer 2", "DeFi", "Meme", "Stablecoin", "Exchange"}
    for c in coins:
        assert c.price > 0 and c.circulating_supply > 0
        assert c.total_supply >= c.circulating_supply
        assert c.max_supply is None or c.max_supply >= c.total_supply
        assert 0.0 <= c.btc_correlation <= 1.0
