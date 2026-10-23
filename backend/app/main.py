"""FastAPI application entrypoint."""

import logging
from collections.abc import AsyncIterator
from contextlib import asynccontextmanager

from fastapi import FastAPI

from app.config import get_settings
from app.db import Database
from app.logging_config import configure_logging
from app.simulator.engine import MarketSimulator

log = logging.getLogger("app")


@asynccontextmanager
async def lifespan(app: FastAPI) -> AsyncIterator[None]:
    settings = get_settings()
    db = Database(settings.database_url)
    simulator = MarketSimulator(
        db.sessionmaker, tick_seconds=settings.sim_tick_seconds, seed=settings.sim_seed
    )
    app.state.db = db
    app.state.simulator = simulator
    await simulator.prepare()
    if settings.sim_enabled:
        simulator.start()
    log.info("startup complete")
    try:
        yield
    finally:
        await simulator.stop()
        await db.dispose()


def create_app() -> FastAPI:
    settings = get_settings()
    configure_logging(settings.log_level)
    app = FastAPI(title="CoinScope API", version="1.0.0", lifespan=lifespan)

    @app.get("/health", tags=["meta"])
    async def health() -> dict[str, str]:
        return {"status": "ok"}

    return app


app = create_app()
