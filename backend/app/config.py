"""Application settings loaded from environment variables (and an optional .env file)."""

from functools import lru_cache

from pydantic import field_validator
from pydantic_settings import BaseSettings, SettingsConfigDict


def normalize_database_url(url: str) -> str:
    """Render/Heroku style URLs use ``postgres://``; SQLAlchemy async needs ``postgresql+asyncpg://``."""
    if url.startswith("postgres://"):
        return "postgresql+asyncpg://" + url[len("postgres://") :]
    if url.startswith("postgresql://"):
        return "postgresql+asyncpg://" + url[len("postgresql://") :]
    return url


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8", extra="ignore")

    database_url: str = "postgresql+asyncpg://coinscope:coinscope@localhost:5432/coinscope"
    sim_seed: int | None = None
    sim_tick_seconds: float = 10.0
    sim_enabled: bool = True
    cors_origins: str = "*"
    log_level: str = "INFO"
    rate_limit: str = "120/minute"

    @field_validator("database_url")
    @classmethod
    def _normalize_url(cls, v: str) -> str:
        return normalize_database_url(v)

    @field_validator("sim_seed", mode="before")
    @classmethod
    def _empty_seed_is_none(cls, v: object) -> object:
        return None if v in ("", None) else v

    @property
    def cors_origin_list(self) -> list[str]:
        return [o.strip() for o in self.cors_origins.split(",") if o.strip()] or ["*"]


@lru_cache
def get_settings() -> Settings:
    return Settings()
