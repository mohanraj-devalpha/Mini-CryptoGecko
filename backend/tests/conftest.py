"""Shared pytest fixtures. Tests run against a real Postgres database (TEST_DATABASE_URL)."""

import os
from collections.abc import AsyncIterator

import pytest
from alembic import command
from alembic.config import Config
from sqlalchemy import text
from sqlalchemy.ext.asyncio import AsyncSession, async_sessionmaker

from app.config import normalize_database_url
from app.db import make_engine, make_sessionmaker


def _load_dotenv_value(key: str) -> str | None:
    path = os.path.join(os.path.dirname(__file__), "..", ".env")
    if not os.path.exists(path):
        return None
    for line in open(path):
        if line.startswith(f"{key}="):
            return line.split("=", 1)[1].strip() or None
    return None


TEST_DATABASE_URL = normalize_database_url(
    os.environ.get("TEST_DATABASE_URL")
    or _load_dotenv_value("TEST_DATABASE_URL")
    or "postgresql+asyncpg://coinscope:coinscope@localhost:5432/coinscope_test"
)


@pytest.fixture(scope="session", autouse=True)
def migrated_db() -> None:
    """Rebuild the test schema from Alembic migrations once per test session."""
    cfg = Config(os.path.join(os.path.dirname(__file__), "..", "alembic.ini"))
    cfg.set_main_option("script_location", os.path.join(os.path.dirname(__file__), "..", "alembic"))
    cfg.cmd_opts = type("Opts", (), {"x": [f"url={TEST_DATABASE_URL}"]})()
    command.downgrade(cfg, "base")
    command.upgrade(cfg, "head")


@pytest.fixture
async def sessionmaker() -> AsyncIterator[async_sessionmaker[AsyncSession]]:
    engine = make_engine(TEST_DATABASE_URL)
    async with engine.begin() as conn:
        await conn.execute(
            text("TRUNCATE watchlist, price_history, coin_market, coins RESTART IDENTITY CASCADE")
        )
    yield make_sessionmaker(engine)
    await engine.dispose()
