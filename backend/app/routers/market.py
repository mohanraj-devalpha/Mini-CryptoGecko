"""Market statistics router: global stats, top gainers/losers movers, and categories."""

from __future__ import annotations

from datetime import UTC, datetime
from typing import Annotated

from fastapi import APIRouter, Depends, Query
from sqlalchemy import text
from sqlalchemy.ext.asyncio import AsyncSession

from app.routers.coins import get_session
from app.schemas import (
    CategoryItem,
    CoinListItem,
    DataEnvelope,
    GlobalMarket,
    MarketMovers,
)

router = APIRouter(prefix="/api", tags=["market"])

DbSession = Annotated[AsyncSession, Depends(get_session)]


@router.get("/market/global", response_model=DataEnvelope[GlobalMarket])
async def get_global_market(db: DbSession) -> DataEnvelope[GlobalMarket]:
    sql = text(
        """
        WITH stats AS (
            SELECT
                count(*) AS coin_count,
                COALESCE(sum(market_cap), 0) AS total_market_cap,
                COALESCE(sum(volume_24h), 0) AS total_volume_24h,
                COALESCE(
                    sum(market_cap * change_24h_pct) / NULLIF(sum(market_cap), 0),
                    0
                ) AS market_cap_change_24h_pct
            FROM coin_market
        ),
        dominance AS (
            SELECT
                MAX(CASE WHEN coin_id = 'bitcoin' THEN market_cap ELSE 0 END) AS btc_mcap,
                MAX(CASE WHEN coin_id = 'ethereum' THEN market_cap ELSE 0 END) AS eth_mcap
            FROM coin_market
            WHERE coin_id IN ('bitcoin', 'ethereum')
        )
        SELECT s.*, d.btc_mcap, d.eth_mcap
        FROM stats s, dominance d
        """
    )
    res = await db.execute(sql)
    row = res.mappings().one()

    total_mcap = float(row["total_market_cap"])
    btc_mcap = float(row["btc_mcap"])
    eth_mcap = float(row["eth_mcap"])

    btc_dom = (btc_mcap / total_mcap * 100.0) if total_mcap > 0 else 0.0
    eth_dom = (eth_mcap / total_mcap * 100.0) if total_mcap > 0 else 0.0

    data = GlobalMarket(
        total_market_cap=total_mcap,
        total_volume_24h=float(row["total_volume_24h"]),
        btc_dominance=round(btc_dom, 2),
        eth_dominance=round(eth_dom, 2),
        market_cap_change_24h_pct=round(float(row["market_cap_change_24h_pct"]), 2),
        coin_count=int(row["coin_count"]),
    )
    return DataEnvelope(data=data, updated_at=datetime.now(UTC))


@router.get("/market/movers", response_model=DataEnvelope[MarketMovers])
async def get_market_movers(
    db: DbSession,
    limit: int = Query(5, ge=1, le=20, description="Number of gainers/losers to return"),
) -> DataEnvelope[MarketMovers]:
    base_sql = """
        WITH ranked AS (
            SELECT c.id, c.symbol, c.name, c.image_url, c.category,
                   cm.price, cm.volume_24h, cm.market_cap, cm.change_24h_pct,
                   cm.high_24h, cm.low_24h,
                   DENSE_RANK() OVER (ORDER BY cm.market_cap DESC) AS rank
            FROM coins c
            JOIN coin_market cm ON cm.coin_id = c.id
        )
        SELECT id, symbol, name, image_url, category, rank,
               price, volume_24h, market_cap, change_24h_pct, high_24h, low_24h
        FROM ranked
    """

    gainers_sql = text(f"{base_sql} ORDER BY change_24h_pct DESC LIMIT :limit")
    losers_sql = text(f"{base_sql} ORDER BY change_24h_pct ASC LIMIT :limit")

    gainers_res = await db.execute(gainers_sql, {"limit": limit})
    losers_res = await db.execute(losers_sql, {"limit": limit})

    gainers = [CoinListItem.model_validate(r) for r in gainers_res.mappings().all()]
    losers = [CoinListItem.model_validate(r) for r in losers_res.mappings().all()]

    return DataEnvelope(
        data=MarketMovers(gainers=gainers, losers=losers),
        updated_at=datetime.now(UTC),
    )


@router.get("/categories", response_model=DataEnvelope[list[CategoryItem]])
async def get_categories(db: DbSession) -> DataEnvelope[list[CategoryItem]]:
    sql = text(
        """
        SELECT category AS name, count(*) AS count
        FROM coins
        GROUP BY category
        ORDER BY count DESC, category ASC
        """
    )
    res = await db.execute(sql)
    items = [CategoryItem(name=r["name"], count=r["count"]) for r in res.mappings().all()]
    return DataEnvelope(data=items, updated_at=datetime.now(UTC))
