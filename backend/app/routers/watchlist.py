"""Watchlist router: per-device watchlist management with full coin and market data."""

from __future__ import annotations

from datetime import UTC, datetime
from typing import Annotated

from fastapi import APIRouter, Depends, Header, HTTPException, status
from sqlalchemy import delete, select, text
from sqlalchemy.dialects.postgresql import insert as pg_insert
from sqlalchemy.ext.asyncio import AsyncSession

from app.models import Coin, WatchlistItem
from app.routers.coins import get_session
from app.schemas import (
    CoinListItem,
    DataEnvelope,
    WatchlistAddRequest,
    WatchlistItemResponse,
)

router = APIRouter(prefix="/api/watchlist", tags=["watchlist"])

DbSession = Annotated[AsyncSession, Depends(get_session)]


def require_device_id(
    x_device_id: Annotated[str | None, Header(alias="X-Device-Id")] = None,
) -> str:
    if not x_device_id or not x_device_id.strip():
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Header 'X-Device-Id' is required",
        )
    return x_device_id.strip()


DeviceId = Annotated[str, Depends(require_device_id)]


@router.get("", response_model=DataEnvelope[list[WatchlistItemResponse]])
async def get_watchlist(
    device_id: DeviceId,
    db: DbSession,
) -> DataEnvelope[list[WatchlistItemResponse]]:
    sql = text(
        """
        WITH ranked AS (
            SELECT c.id, c.symbol, c.name, c.image_url, c.category,
                   cm.price, cm.volume_24h, cm.market_cap, cm.change_24h_pct,
                   cm.high_24h, cm.low_24h,
                   DENSE_RANK() OVER (ORDER BY cm.market_cap DESC) AS rank
            FROM coins c
            JOIN coin_market cm ON cm.coin_id = c.id
        )
        SELECT w.id AS item_id, w.device_id, w.coin_id, w.created_at,
               r.id, r.symbol, r.name, r.image_url, r.category, r.rank,
               r.price, r.volume_24h, r.market_cap, r.change_24h_pct,
               r.high_24h, r.low_24h
        FROM watchlist w
        JOIN ranked r ON r.id = w.coin_id
        WHERE w.device_id = :device_id
        ORDER BY w.created_at DESC
        """
    )
    result = await db.execute(sql, {"device_id": device_id})
    rows = result.mappings().all()

    items = [
        WatchlistItemResponse(
            id=r["item_id"],
            device_id=r["device_id"],
            coin_id=r["coin_id"],
            created_at=r["created_at"],
            coin=CoinListItem(
                id=r["id"],
                symbol=r["symbol"],
                name=r["name"],
                image_url=r["image_url"],
                category=r["category"],
                rank=r["rank"],
                price=r["price"],
                volume_24h=r["volume_24h"],
                market_cap=r["market_cap"],
                change_24h_pct=r["change_24h_pct"],
                high_24h=r["high_24h"],
                low_24h=r["low_24h"],
            ),
        )
        for r in rows
    ]
    return DataEnvelope(data=items, updated_at=datetime.now(UTC))


@router.post("", response_model=DataEnvelope[WatchlistItemResponse], status_code=status.HTTP_201_CREATED)
async def add_to_watchlist(
    payload: WatchlistAddRequest,
    device_id: DeviceId,
    db: DbSession,
) -> DataEnvelope[WatchlistItemResponse]:
    coin_id = payload.coin_id.strip().lower()

    # Verify coin exists
    coin_exists = await db.scalar(select(func.count()).select_from(Coin).where(Coin.id == coin_id)) if False else await db.scalar(
        select(Coin.id).where(Coin.id == coin_id)
    )
    if not coin_exists:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Coin '{coin_id}' not found",
        )

    # Insert idempotently
    insert_stmt = (
        pg_insert(WatchlistItem)
        .values(device_id=device_id, coin_id=coin_id)
        .on_conflict_do_update(
            constraint="uq_watchlist_device_coin",
            set_={"coin_id": coin_id},
        )
        .returning(WatchlistItem.id, WatchlistItem.created_at)
    )
    res = await db.execute(insert_stmt)
    await db.commit()
    inserted_row = res.mappings().one()

    # Fetch the full coin item
    sql = text(
        """
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
        WHERE id = :coin_id
        """
    )
    coin_row = (await db.execute(sql, {"coin_id": coin_id})).mappings().one()

    item = WatchlistItemResponse(
        id=inserted_row["id"],
        device_id=device_id,
        coin_id=coin_id,
        created_at=inserted_row["created_at"],
        coin=CoinListItem.model_validate(coin_row),
    )
    return DataEnvelope(data=item, updated_at=datetime.now(UTC))


@router.delete("/{coin_id}", response_model=DataEnvelope[dict[str, object]])
async def remove_from_watchlist(
    coin_id: str,
    device_id: DeviceId,
    db: DbSession,
) -> DataEnvelope[dict[str, object]]:
    coin_id = coin_id.strip().lower()
    res = await db.execute(
        delete(WatchlistItem).where(
            WatchlistItem.device_id == device_id,
            WatchlistItem.coin_id == coin_id,
        )
    )
    await db.commit()

    if res.rowcount == 0:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Coin '{coin_id}' not found in watchlist for device",
        )

    return DataEnvelope(
        data={"deleted": True, "coin_id": coin_id},
        updated_at=datetime.now(UTC),
    )
