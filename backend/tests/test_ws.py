"""Tests for WebSocket price streaming and subscription filtering."""

from __future__ import annotations

import pytest
from starlette.testclient import TestClient

from app.ws import ws_manager


def test_websocket_prices_snapshot_and_subscription(test_app) -> None:
    client = TestClient(test_app)
    with client.websocket_connect("/ws/prices") as ws:
        # Initial snapshot received on connect
        data = ws.receive_json()
        assert isinstance(data, list)
        assert len(data) >= 50
        assert any(t["id"] == "bitcoin" for t in data)

        # Update subscription to only bitcoin
        ws.send_json({"subscribe": ["bitcoin"]})

        # Test broadcast filtering
        ticks = [
            {"id": "bitcoin", "price": 68000.0, "change_24h": 3.5},
            {"id": "ethereum", "price": 3500.0, "change_24h": 2.1},
        ]
        import asyncio
        asyncio.run(ws_manager.broadcast(ticks))

        filtered = ws.receive_json()
        assert len(filtered) == 1
        assert filtered[0]["id"] == "bitcoin"
        assert filtered[0]["price"] == 68000.0
