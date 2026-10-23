"""Shared pytest fixtures with ASGI HTTP client and WebSocket support."""

from __future__ import annotations

import os
from collections.abc import AsyncIterator
from datetime import UTC, datetime

import httpx
import pytest
from alembic import command
from alembic.config import Config
from sqlalchemy import text
from sqlalchemy.ext.asyncio import AsyncSession, async_sessionmaker

from app.config import get_settings, normalize_database_url
from app.db import Database, make_engine, make_sessionmaker
from app.main import create_app
from app.simulator.engine import MarketSimulator
from app.simulator.history import seed_if_empty
from app.simulator.model import make_rng

TEST_DATABASE_URL = normalize_database_url(
    os.environ.get("TEST_DATABASE_URL")
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
    sm = make_sessionmaker(engine)
    yield sm
    await engine.dispose()


@pytest.fixture
async def test_app(sessionmaker: async_sessionmaker[AsyncSession]):
    """App configured with test database and seeded state, with simulator background loop disabled."""
    # Seed test database
    now = datetime(2026, 10, 23, 6, 0, tzinfo=UTC)
    async with sessionmaker() as session:
        await seed_if_empty(session, make_rng(42), now)

    app = create_app()
    db = Database(TEST_DATABASE_URL)
    app.state.db = db

    simulator = MarketSimulator(
        db.sessionmaker,
        tick_seconds=10.0,
        seed=42,
    )
    await simulator.prepare(now)
    app.state.simulator = simulator

    yield app

    await simulator.stop()
    await db.dispose()


@pytest.fixture
async def client(test_app) -> AsyncIterator[httpx.AsyncClient]:
    transport = httpx.ASGITransport(app=test_app)
    async with httpx.AsyncClient(transport=transport, base_url="http://test") as c:
        yield c
