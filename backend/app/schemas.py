"""Pydantic schemas for CoinScope API responses and requests."""

from __future__ import annotations

from datetime import datetime
from typing import Any, Generic, TypeVar

from pydantic import BaseModel, ConfigDict, Field

T = TypeVar("T")


class Meta(BaseModel):
    page: int
    per_page: int
    total: int
    pages: int


class DataEnvelope(BaseModel, Generic[T]):
    data: T
    updated_at: datetime = Field(default_factory=lambda: datetime.now().astimezone())


class PageEnvelope(BaseModel, Generic[T]):
    data: list[T]
    meta: Meta
    updated_at: datetime = Field(default_factory=lambda: datetime.now().astimezone())


class ErrorDetail(BaseModel):
    code: str
    message: str
    details: Any = None


class ErrorResponse(BaseModel):
    error: ErrorDetail


# ---------------------------------------------------------------------- Coins

class CoinListItem(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    symbol: str
    name: str
    image_url: str | None = None
    category: str
    rank: int
    price: float
    volume_24h: float
    market_cap: float
    change_24h_pct: float
    high_24h: float
    low_24h: float


class CoinMarketData(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    price: float
    volume_24h: float
    market_cap: float
    change_24h_pct: float
    high_24h: float
    low_24h: float
    ath: float
    ath_date: datetime
    updated_at: datetime


class CoinDetail(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    symbol: str
    name: str
    image_url: str | None = None
    description: str
    category: str
    circulating_supply: float
    total_supply: float
    max_supply: float | None = None
    rank: int
    market: CoinMarketData


# ---------------------------------------------------------------------- Chart

class ChartPoint(BaseModel):
    t: datetime
    price: float


# ---------------------------------------------------------------------- Market

class GlobalMarket(BaseModel):
    total_market_cap: float
    total_volume_24h: float
    btc_dominance: float
    eth_dominance: float
    market_cap_change_24h_pct: float
    coin_count: int


class MarketMovers(BaseModel):
    gainers: list[CoinListItem]
    losers: list[CoinListItem]


class CategoryItem(BaseModel):
    name: str
    count: int


# ---------------------------------------------------------------------- Watchlist

class WatchlistAddRequest(BaseModel):
    coin_id: str


class WatchlistItemResponse(BaseModel):
    id: int
    device_id: str
    coin_id: str
    created_at: datetime
    coin: CoinListItem
