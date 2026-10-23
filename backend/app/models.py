"""ORM models. All timestamps are timezone-aware UTC (timestamptz)."""

from datetime import datetime

from sqlalchemy import (
    BigInteger,
    DateTime,
    Float,
    ForeignKey,
    Index,
    String,
    Text,
    UniqueConstraint,
    func,
)
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db import Base


class Coin(Base):
    __tablename__ = "coins"

    id: Mapped[str] = mapped_column(String(64), primary_key=True)  # slug, e.g. "bitcoin"
    symbol: Mapped[str] = mapped_column(String(16), nullable=False, index=True)
    name: Mapped[str] = mapped_column(String(128), nullable=False)
    image_url: Mapped[str | None] = mapped_column(String(512))
    description: Mapped[str] = mapped_column(Text, nullable=False, default="")
    category: Mapped[str] = mapped_column(String(32), nullable=False, index=True)
    circulating_supply: Mapped[float] = mapped_column(Float, nullable=False)
    total_supply: Mapped[float] = mapped_column(Float, nullable=False)
    max_supply: Mapped[float | None] = mapped_column(Float)
    volatility: Mapped[float] = mapped_column(Float, nullable=False)  # annualised sigma
    btc_correlation: Mapped[float] = mapped_column(Float, nullable=False)

    market: Mapped["CoinMarket"] = relationship(back_populates="coin", uselist=False, lazy="raise")


class CoinMarket(Base):
    __tablename__ = "coin_market"

    coin_id: Mapped[str] = mapped_column(
        ForeignKey("coins.id", ondelete="CASCADE"), primary_key=True
    )
    price: Mapped[float] = mapped_column(Float, nullable=False)
    volume_24h: Mapped[float] = mapped_column(Float, nullable=False)
    market_cap: Mapped[float] = mapped_column(Float, nullable=False, index=True)
    change_24h_pct: Mapped[float] = mapped_column(Float, nullable=False, default=0.0)
    high_24h: Mapped[float] = mapped_column(Float, nullable=False)
    low_24h: Mapped[float] = mapped_column(Float, nullable=False)
    ath: Mapped[float] = mapped_column(Float, nullable=False)
    ath_date: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False)
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, server_default=func.now()
    )

    coin: Mapped[Coin] = relationship(back_populates="market", lazy="raise")


class PriceHistory(Base):
    __tablename__ = "price_history"
    __table_args__ = (Index("ix_price_history_coin_ts_desc", "coin_id", "ts", postgresql_ops={"ts": "DESC"}),)

    coin_id: Mapped[str] = mapped_column(
        ForeignKey("coins.id", ondelete="CASCADE"), primary_key=True
    )
    ts: Mapped[datetime] = mapped_column(DateTime(timezone=True), primary_key=True)
    price: Mapped[float] = mapped_column(Float, nullable=False)
    volume: Mapped[float] = mapped_column(Float, nullable=False)


class WatchlistItem(Base):
    __tablename__ = "watchlist"
    __table_args__ = (UniqueConstraint("device_id", "coin_id", name="uq_watchlist_device_coin"),)

    id: Mapped[int] = mapped_column(BigInteger, primary_key=True, autoincrement=True)
    device_id: Mapped[str] = mapped_column(String(64), nullable=False, index=True)
    coin_id: Mapped[str] = mapped_column(
        ForeignKey("coins.id", ondelete="CASCADE"), nullable=False
    )
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, server_default=func.now()
    )
