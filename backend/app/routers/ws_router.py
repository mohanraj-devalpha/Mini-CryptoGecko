"""WebSocket price streaming router."""

from __future__ import annotations

import json
import logging
from typing import Any

from fastapi import APIRouter, WebSocket, WebSocketDisconnect

from app.ws import ws_manager

log = logging.getLogger(__name__)

router = APIRouter(tags=["websocket"])


@router.websocket("/ws/prices")
async def websocket_prices(websocket: WebSocket) -> None:
    await ws_manager.connect(websocket)

    # Send initial price snapshot immediately upon connection
    simulator = getattr(websocket.app.state, "simulator", None)
    if simulator is not None:
        initial_snapshot = simulator.snapshot()
        if initial_snapshot:
            try:
                await websocket.send_json(initial_snapshot)
            except Exception:
                await ws_manager.disconnect(websocket)
                return

    try:
        while True:
            data = await websocket.receive_text()
            try:
                payload = json.loads(data)
                if isinstance(payload, dict) and "subscribe" in payload:
                    subs = payload["subscribe"]
                    if isinstance(subs, list):
                        await ws_manager.set_subscription(websocket, [str(s) for s in subs])
            except Exception:
                log.warning("invalid websocket message received", extra={"raw": data[:100]})
    except WebSocketDisconnect:
        await ws_manager.disconnect(websocket)
    except Exception:
        await ws_manager.disconnect(websocket)
