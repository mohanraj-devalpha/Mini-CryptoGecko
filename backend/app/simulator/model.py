"""Pure price-model math (no I/O) so it can be unit tested in isolation.

Model
-----
* Volatile coins follow geometric Brownian motion with zero log-drift::

      ln S(t+dt) = ln S(t) + sigma * sqrt(dt) * Z_i

  where ``Z_i = rho_i * Z_btc + sqrt(1 - rho_i^2) * eps_i``. ``Z_btc`` is one shared
  market shock per step, so coins with a high ``btc_correlation`` move with Bitcoin.
* Stablecoins follow an exact Ornstein-Uhlenbeck process around 1.00 and are clamped to
  +/-0.5%, so they always stay ~1.00 regardless of step size.
"""

from __future__ import annotations

import math
from dataclasses import dataclass
from datetime import UTC, datetime, timedelta

import numpy as np

SECONDS_PER_YEAR = 365.0 * 24 * 3600
FIVE_MIN = timedelta(minutes=5)
ONE_DAY = timedelta(days=1)
STABLE_CATEGORY = "Stablecoin"

# Stablecoin OU parameters: mean reversion speed (per year) and stationary std dev.
STABLE_THETA = 20_000.0
STABLE_STD = 0.0006
STABLE_BAND = 0.005
MIN_PRICE = 1e-12


@dataclass(frozen=True, slots=True)
class CoinParams:
    id: str
    volatility: float
    btc_correlation: float
    is_stable: bool


def floor_5min(ts: datetime) -> datetime:
    ts = ts.astimezone(UTC)
    return ts.replace(minute=ts.minute - ts.minute % 5, second=0, microsecond=0)


def floor_day(ts: datetime) -> datetime:
    return ts.astimezone(UTC).replace(hour=0, minute=0, second=0, microsecond=0)


def build_timeline(start_exclusive: datetime, end: datetime, now: datetime) -> list[datetime]:
    """Timestamps after ``start_exclusive`` up to ``end``.

    Points older than the 7-day cutoff are daily (00:00 UTC); recent points are every 5 minutes.
    This matches the storage layout produced by seeding and by the daily downsample job.
    """
    cutoff = floor_day(now - timedelta(days=7))
    out: list[datetime] = []
    # Daily section
    t = floor_day(start_exclusive) + ONE_DAY
    while t < cutoff and t <= end:
        out.append(t)
        t += ONE_DAY
    # 5-minute section
    t = max(floor_5min(start_exclusive) + FIVE_MIN, cutoff)
    while t <= end:
        out.append(t)
        t += FIVE_MIN
    return out


class PriceModel:
    """Vectorised correlated GBM / OU stepper for a fixed list of coins."""

    def __init__(self, coins: list[CoinParams], rng: np.random.Generator) -> None:
        self.coins = coins
        self.rng = rng
        self.sigma = np.array([c.volatility for c in coins], dtype=float)
        rho = np.clip(np.array([c.btc_correlation for c in coins], dtype=float), -1.0, 1.0)
        self.rho = rho
        self.idio = np.sqrt(1.0 - rho**2)
        self.stable = np.array([c.is_stable for c in coins], dtype=bool)

    def shocks(self, n_steps: int) -> np.ndarray:
        """Correlated standard-normal shocks, shape (n_steps, n_coins)."""
        market = self.rng.standard_normal((n_steps, 1))
        eps = self.rng.standard_normal((n_steps, len(self.coins)))
        return self.rho * market + self.idio * eps

    def log_returns(self, dts_seconds: np.ndarray) -> np.ndarray:
        """GBM log-returns for consecutive steps of the given lengths (stable columns are 0)."""
        dt_years = (np.asarray(dts_seconds, dtype=float) / SECONDS_PER_YEAR)[:, None]
        r = self.sigma * np.sqrt(dt_years) * self.shocks(len(dts_seconds))
        r[:, self.stable] = 0.0
        return r

    def _stable_step(self, prev: np.ndarray, dt_seconds: float) -> np.ndarray:
        a = math.exp(-STABLE_THETA * dt_seconds / SECONDS_PER_YEAR)
        noise = self.rng.standard_normal(prev.shape)
        dev = (prev - 1.0) * a + STABLE_STD * math.sqrt(1.0 - a * a) * noise
        return 1.0 + np.clip(dev, -STABLE_BAND, STABLE_BAND)

    def simulate_forward(self, start: np.ndarray, dts_seconds: np.ndarray) -> np.ndarray:
        """Paths starting *after* ``start``; returns shape (len(dts), n_coins)."""
        n = len(dts_seconds)
        out = np.empty((n, len(self.coins)))
        if n == 0:
            return out
        cum = np.cumsum(self.log_returns(dts_seconds), axis=0)
        out[:] = np.maximum(start * np.exp(cum), MIN_PRICE)
        if self.stable.any():
            prev = np.where(self.stable, start, 1.0)[self.stable]
            for i, dt in enumerate(dts_seconds):
                prev = self._stable_step(prev, float(dt))
                out[i, self.stable] = prev
        return out

    def simulate_backward(self, end: np.ndarray, dts_seconds: np.ndarray) -> np.ndarray:
        """Paths of len(dts)+1 points whose LAST row equals ``end``.

        Used for seeding so that today's price equals the realistic seed price.
        """
        n = len(dts_seconds)
        r = self.log_returns(dts_seconds)
        # log p[k] = log p[n] - sum_{j>k} r[j]
        tail = np.vstack([np.cumsum(r[::-1], axis=0)[::-1], np.zeros((1, len(self.coins)))])
        out = np.maximum(end * np.exp(-tail), MIN_PRICE)
        if self.stable.any():
            prev = np.ones(int(self.stable.sum()))
            for i in range(n + 1):
                if i > 0:
                    prev = self._stable_step(prev, float(dts_seconds[i - 1]))
                out[i, self.stable] = prev
        return out

    def step(self, prices: np.ndarray, dt_seconds: float) -> np.ndarray:
        """Single live tick."""
        return self.simulate_forward(prices, np.array([dt_seconds]))[0]

    def volume_noise(self, shape: tuple[int, ...], sigma: float = 0.25) -> np.ndarray:
        """Log-normal multiplicative noise with mean 1."""
        return np.exp(self.rng.normal(-0.5 * sigma * sigma, sigma, shape))


def make_rng(seed: int | None) -> np.random.Generator:
    return np.random.default_rng(seed)
