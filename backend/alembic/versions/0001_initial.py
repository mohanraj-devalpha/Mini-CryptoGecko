"""initial schema: coins, coin_market, price_history, watchlist

Revision ID: 0001_initial
Revises:
Create Date: 2026-10-23
"""
from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op

revision: str = "0001_initial"
down_revision: str | None = None
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    op.create_table(
        "coins",
        sa.Column("id", sa.String(64), primary_key=True),
        sa.Column("symbol", sa.String(16), nullable=False),
        sa.Column("name", sa.String(128), nullable=False),
        sa.Column("image_url", sa.String(512)),
        sa.Column("description", sa.Text, nullable=False, server_default=""),
        sa.Column("category", sa.String(32), nullable=False),
        sa.Column("circulating_supply", sa.Float, nullable=False),
        sa.Column("total_supply", sa.Float, nullable=False),
        sa.Column("max_supply", sa.Float),
        sa.Column("volatility", sa.Float, nullable=False),
        sa.Column("btc_correlation", sa.Float, nullable=False),
    )
    op.create_index("ix_coins_symbol", "coins", ["symbol"])
    op.create_index("ix_coins_category", "coins", ["category"])

    op.create_table(
        "coin_market",
        sa.Column(
            "coin_id", sa.String(64), sa.ForeignKey("coins.id", ondelete="CASCADE"), primary_key=True
        ),
        sa.Column("price", sa.Float, nullable=False),
        sa.Column("volume_24h", sa.Float, nullable=False),
        sa.Column("market_cap", sa.Float, nullable=False),
        sa.Column("change_24h_pct", sa.Float, nullable=False, server_default="0"),
        sa.Column("high_24h", sa.Float, nullable=False),
        sa.Column("low_24h", sa.Float, nullable=False),
        sa.Column("ath", sa.Float, nullable=False),
        sa.Column("ath_date", sa.DateTime(timezone=True), nullable=False),
        sa.Column(
            "updated_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()
        ),
    )
    op.create_index("ix_coin_market_market_cap", "coin_market", ["market_cap"])

    op.create_table(
        "price_history",
        sa.Column(
            "coin_id", sa.String(64), sa.ForeignKey("coins.id", ondelete="CASCADE"), nullable=False
        ),
        sa.Column("ts", sa.DateTime(timezone=True), nullable=False),
        sa.Column("price", sa.Float, nullable=False),
        sa.Column("volume", sa.Float, nullable=False),
        sa.PrimaryKeyConstraint("coin_id", "ts", name="pk_price_history"),
    )
    op.create_index(
        "ix_price_history_coin_ts_desc",
        "price_history",
        ["coin_id", sa.text("ts DESC")],
    )

    op.create_table(
        "watchlist",
        sa.Column("id", sa.BigInteger, primary_key=True, autoincrement=True),
        sa.Column("device_id", sa.String(64), nullable=False),
        sa.Column(
            "coin_id", sa.String(64), sa.ForeignKey("coins.id", ondelete="CASCADE"), nullable=False
        ),
        sa.Column(
            "created_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()
        ),
        sa.UniqueConstraint("device_id", "coin_id", name="uq_watchlist_device_coin"),
    )
    op.create_index("ix_watchlist_device_id", "watchlist", ["device_id"])


def downgrade() -> None:
    op.drop_table("watchlist")
    op.drop_index("ix_price_history_coin_ts_desc", table_name="price_history")
    op.drop_table("price_history")
    op.drop_table("coin_market")
    op.drop_table("coins")
