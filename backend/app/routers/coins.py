"""Coins REST API router: list, search, filter, sort, detail, and chart endpoints."""

from __future__ import annotations

import math
from datetime import UTC, datetime
from typing import Annotated

from collections.abc import AsyncIterator
from fastapi import APIRouter, Depends, HTTPException, Query, Request, status
from sqlalchemy import desc, func, select, text
from sqlalchemy.ext.asyncio import AsyncSession

from app.db import Database
from app.models import Coin, CoinMarket
from app.schemas import (
    ChartPoint,
    CoinDetail,
    CoinListItem,
    CoinMarketData,
    DataEnvelope,
    Meta,
    PageEnvelope,
)
from app.services.chart import get_chart_points

router = APIRouter(prefix="/api/coins", tags=["coins"])


async def get_session(request: Request) -> AsyncIterator[AsyncSession]:
    db: Database = request.app.state.db
    async for s in db.session():
        yield s


DbSession = Annotated[AsyncSession, Depends(get_session)]


@router.get("", response_model=PageEnvelope[CoinListItem])
async def list_coins(
    db: DbSession,
    page: int = Query(1, ge=1, description="Page number"),
    per_page: int = Query(50, ge=1, le=100, description="Items per page"),
    sort: str = Query("market_cap", pattern="^(market_cap|price|change_24h|volume|name)$"),
    order: str = Query("desc", pattern="^(asc|desc)$"),
    category: str | None = Query(None, description="Filter by category"),
    q: str | None = Query(None, description="Search query by coin name or symbol"),
) -> PageEnvelope[CoinListItem]:
    # Compute global rank over all coins first using window function
    sort_column_map = {
        "market_cap": "market_cap",
        "price": "price",
        "change_24h": "change_24h_pct",
        "volume": "volume_24h",
        "name": "name",
    }
    col_name = sort_column_map[sort]
    direction = "ASC" if order.lower() == "asc" else "DESC"

    where_clauses: list[str] = []
    params: dict[str, object] = {}

    if category and category.strip():
        where_clauses.append("category ILIKE :category")
        params["category"] = category.strip()

    if q and q.strip():
        where_clauses.append("(name ILIKE :q OR symbol ILIKE :q)")
        params["q"] = f"%{q.strip()}%"

    where_sql = f"WHERE {' AND '.join(where_clauses)}" if where_clauses else ""

    # Count total matching query
    count_sql = text(
        f"""
        WITH ranked AS (
            SELECT c.id, c.symbol, c.name, c.category, cm.market_cap
            FROM coins c
            JOIN coin_market cm ON cm.coin_id = c.id
        )
        SELECT count(*) FROM ranked {where_sql}
        """
    )
    total = (await db.scalar(count_sql, params)) or 0

    offset = (page - 1) * per_page
    params["limit"] = per_page
    params["offset"] = offset

    data_sql = text(
        f"""
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
        {where_sql}
        ORDER BY {col_name} {direction}, rank ASC
        LIMIT :limit OFFSET :offset
        """
    )
    result = await db.execute(data_sql, params)
    rows = result.mappings().all()

    items = [CoinListItem.model_validate(row) for row in rows]
    pages = math.ceil(total / per_page) if per_page else 0

    return PageEnvelope(
        data=items,
        meta=Meta(page=page, per_page=per_page, total=total, pages=pages),
        updated_at=datetime.now(UTC),
    )


@router.get("/{coin_id}", response_model=DataEnvelope[CoinDetail])
async def get_coin_detail(coin_id: str, db: DbSession) -> DataEnvelope[CoinDetail]:
    sql = text(
        """
        WITH ranked AS (
            SELECT c.id,
                   DENSE_RANK() OVER (ORDER BY cm.market_cap DESC) AS rank
            FROM coins c
            JOIN coin_market cm ON cm.coin_id = c.id
        )
        SELECT c.id, c.symbol, c.name, c.image_url, c.description, c.category,
               c.circulating_supply, c.total_supply, c.max_supply,
               r.rank,
               cm.price, cm.volume_24h, cm.market_cap, cm.change_24h_pct,
               cm.high_24h, cm.low_24h, cm.ath, cm.ath_date, cm.updated_at
        FROM coins c
        JOIN coin_market cm ON cm.coin_id = c.id
        JOIN ranked r ON r.id = c.id
        WHERE c.id = :coin_id
        """
    )
    result = await db.execute(sql, {"coin_id": coin_id})
    row = result.mappings().first()
    if not row:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Coin '{coin_id}' not found",
        )

    market_data = CoinMarketData(
        price=row["price"],
        volume_24h=row["volume_24h"],
        market_cap=row["market_cap"],
        change_24h_pct=row["change_24h_pct"],
        high_24h=row["high_24h"],
        low_24h=row["low_24h"],
        ath=row["ath"],
        ath_date=row["ath_date"],
        updated_at=row["updated_at"],
    )

    detail = CoinDetail(
        id=row["id"],
        symbol=row["symbol"],
        name=row["name"],
        image_url=row["image_url"],
        description=row["description"],
        category=row["category"],
        circulating_supply=row["circulating_supply"],
        total_supply=row["total_supply"],
        max_supply=row["max_supply"],
        rank=row["rank"],
        market=market_data,
    )
    return DataEnvelope(data=detail, updated_at=row["updated_at"])


@router.get("/{coin_id}/chart", response_model=DataEnvelope[list[ChartPoint]])
async def get_coin_chart(
    coin_id: str,
    db: DbSession,
    range: str = Query("7d", pattern="^(1d|7d|30d|1y)$", description="Chart timeframe"),
) -> DataEnvelope[list[ChartPoint]]:
    # Verify coin exists
    exists = await db.scalar(select(func.count()).select_from(Coin).where(Coin.id == coin_id))
    if not exists:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Coin '{coin_id}' not found",
        )

    points = await get_chart_points(db, coin_id, range)
    return DataEnvelope(data=points, updated_at=datetime.now(UTC))
