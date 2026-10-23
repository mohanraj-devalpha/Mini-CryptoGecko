"""Chart downsampling service using PostgreSQL date_bin aggregation."""

from __future__ import annotations

from datetime import UTC, datetime, timedelta

from sqlalchemy import select, text
from sqlalchemy.ext.asyncio import AsyncSession

from app.models import CoinMarket
from app.schemas import ChartPoint

RANGE_CONFIGS: dict[str, tuple[timedelta, timedelta]] = {
    "1d": (timedelta(days=1), timedelta(minutes=10)),    # ~144 points
    "7d": (timedelta(days=7), timedelta(hours=1)),        # ~168 points
    "30d": (timedelta(days=30), timedelta(hours=4)),     # ~180 points
    "1y": (timedelta(days=365), timedelta(days=2)),       # ~183 points
}

CHART_SQL = text(
    """
    SELECT date_bin(:stride, ts, TIMESTAMPTZ '2020-01-01 00:00:00+00') AS bucket,
           (array_agg(price ORDER BY ts DESC))[1] AS close_price
    FROM price_history
    WHERE coin_id = :coin_id AND ts >= :since
    GROUP BY 1
    ORDER BY 1 ASC
    """
)


async def get_chart_points(
    session: AsyncSession,
    coin_id: str,
    range_key: str,
    now: datetime | None = None,
) -> list[ChartPoint]:
    now = now or datetime.now(UTC)
    config = RANGE_CONFIGS.get(range_key.lower())
    if not config:
        raise ValueError(f"Invalid range '{range_key}'. Allowed ranges: 1d, 7d, 30d, 1y")

    duration, stride = config
    since = now - duration

    result = await session.execute(
        CHART_SQL,
        {"coin_id": coin_id, "since": since, "stride": stride},
    )
    rows = result.fetchall()

    points = [ChartPoint(t=row.bucket, price=float(row.close_price)) for row in rows]

    # Append current live price as latest point
    live_market = await session.scalar(
        select(CoinMarket).where(CoinMarket.coin_id == coin_id)
    )
    if live_market:
        live_pt = ChartPoint(t=live_market.updated_at, price=float(live_market.price))
        if not points or live_pt.t > points[-1].t:
            points.append(live_pt)

    return points
