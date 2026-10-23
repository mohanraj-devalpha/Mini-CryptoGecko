"""WebSocket connection manager and broadcaster for real-time prices."""

from __future__ import annotations

import asyncio
import json
import logging
from typing import Any

from fastapi import WebSocket

log = logging.getLogger(__name__)


class ConnectionManager:
    def __init__(self) -> None:
        self.active_connections: dict[WebSocket, set[str]] = {}
        self._lock = asyncio.Lock()

    async def connect(self, websocket: WebSocket) -> None:
        await websocket.accept()
        async with self._lock:
            # Empty set means subscribed to all coins
            self.active_connections[websocket] = set()
        log.info("websocket client connected", extra={"total_clients": len(self.active_connections)})

    async def disconnect(self, websocket: WebSocket) -> None:
        async with self._lock:
            self.active_connections.pop(websocket, None)
        log.info("websocket client disconnected", extra={"total_clients": len(self.active_connections)})

    async def set_subscription(self, websocket: WebSocket, coin_ids: list[str]) -> None:
        async with self._lock:
            if websocket in self.active_connections:
                self.active_connections[websocket] = set(coin_ids)
                log.info(
                    "updated client subscription",
                    extra={"subscribed_coins": len(coin_ids)},
                )

    async def broadcast(self, ticks: list[dict[str, Any]]) -> None:
        """Broadcast ticks to connected clients, respecting each client's subscription filter."""
        if not self.active_connections:
            return

        async with self._lock:
            items = list(self.active_connections.items())

        dead_connections: list[WebSocket] = []

        for ws, sub in items:
            if not sub:
                filtered = ticks
            else:
                filtered = [t for t in ticks if t.get("id") in sub]

            if not filtered:
                continue

            try:
                await ws.send_json(filtered)
            except Exception:
                dead_connections.append(ws)

        if dead_connections:
            async with self._lock:
                for ws in dead_connections:
                    self.active_connections.pop(ws, None)


ws_manager = ConnectionManager()
