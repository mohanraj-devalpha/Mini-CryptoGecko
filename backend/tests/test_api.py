"""Integration tests for all REST API endpoints."""

from __future__ import annotations

import pytest
import httpx


async def test_health(client: httpx.AsyncClient) -> None:
    res = await client.get("/health")
    assert res.status_code == 200
    assert res.json() == {"status": "ok"}


async def test_coins_list_pagination(client: httpx.AsyncClient) -> None:
    res = await client.get("/api/coins?page=1&per_page=10")
    assert res.status_code == 200
    body = res.json()
    assert "data" in body and "meta" in body and "updated_at" in body
    assert len(body["data"]) == 10
    assert body["meta"]["page"] == 1
    assert body["meta"]["per_page"] == 10
    assert body["meta"]["total"] >= 50
    assert body["meta"]["pages"] >= 5

    first = body["data"][0]
    assert first["rank"] == 1
    assert first["id"] == "bitcoin"
    assert first["price"] > 0
    assert first["market_cap"] > 0


async def test_coins_sorting(client: httpx.AsyncClient) -> None:
    # Sort by price desc
    res = await client.get("/api/coins?sort=price&order=desc&per_page=5")
    assert res.status_code == 200
    coins = res.json()["data"]
    prices = [c["price"] for c in coins]
    assert prices == sorted(prices, reverse=True)

    # Sort by price asc
    res = await client.get("/api/coins?sort=price&order=asc&per_page=5")
    assert res.status_code == 200
    coins = res.json()["data"]
    prices = [c["price"] for c in coins]
    assert prices == sorted(prices)

    # Sort by name asc
    res = await client.get("/api/coins?sort=name&order=asc&per_page=5")
    assert res.status_code == 200
    names = [c["name"].lower() for c in res.json()["data"]]
    assert names == sorted(names)


async def test_coins_filtering_by_category(client: httpx.AsyncClient) -> None:
    res = await client.get("/api/coins?category=DeFi&per_page=50")
    assert res.status_code == 200
    coins = res.json()["data"]
    assert len(coins) > 0
    assert all(c["category"] == "DeFi" for c in coins)
    # Notice: global rank is preserved even when filtered!
    ranks = [c["rank"] for c in coins]
    assert any(r > 10 for r in ranks)  # ranks are global, not reset to 1,2,3


async def test_coins_search(client: httpx.AsyncClient) -> None:
    res = await client.get("/api/coins?q=bit")
    assert res.status_code == 200
    coins = res.json()["data"]
    assert len(coins) >= 2
    symbols_and_names = [f"{c['symbol']} {c['name']}".lower() for c in coins]
    assert all("bit" in s for s in symbols_and_names)


async def test_coin_detail_success(client: httpx.AsyncClient) -> None:
    res = await client.get("/api/coins/bitcoin")
    assert res.status_code == 200
    coin = res.json()["data"]
    assert coin["id"] == "bitcoin"
    assert coin["symbol"] == "BTC"
    assert coin["name"] == "Bitcoin"
    assert coin["rank"] == 1
    assert coin["circulating_supply"] > 0
    assert coin["market"]["price"] > 0
    assert coin["market"]["high_24h"] >= coin["market"]["price"]
    assert coin["market"]["low_24h"] <= coin["market"]["price"]


async def test_coin_detail_not_found(client: httpx.AsyncClient) -> None:
    res = await client.get("/api/coins/nonexistent-coin")
    assert res.status_code == 404
    error = res.json()["error"]
    assert error["code"] == "NOT_FOUND"
    assert "not found" in error["message"].lower()


async def test_coin_chart_downsampling(client: httpx.AsyncClient) -> None:
    for rng in ("1d", "7d", "30d", "1y"):
        res = await client.get(f"/api/coins/bitcoin/chart?range={rng}")
        assert res.status_code == 200
        pts = res.json()["data"]
        assert len(pts) > 0
        assert len(pts) <= 220
        # Check ascending in time
        assert all(pts[i]["t"] <= pts[i + 1]["t"] for i in range(len(pts) - 1))
        assert all(p["price"] > 0 for p in pts)


async def test_coin_chart_invalid_range(client: httpx.AsyncClient) -> None:
    res = await client.get("/api/coins/bitcoin/chart?range=5y")
    assert res.status_code == 422
    assert res.json()["error"]["code"] == "VALIDATION_ERROR"


async def test_global_market(client: httpx.AsyncClient) -> None:
    res = await client.get("/api/market/global")
    assert res.status_code == 200
    m = res.json()["data"]
    assert m["total_market_cap"] > 1e11
    assert m["total_volume_24h"] > 0
    assert 20.0 < m["btc_dominance"] < 80.0
    assert 5.0 < m["eth_dominance"] < 40.0
    assert m["coin_count"] >= 50


async def test_market_movers(client: httpx.AsyncClient) -> None:
    res = await client.get("/api/market/movers?limit=5")
    assert res.status_code == 200
    movers = res.json()["data"]
    assert len(movers["gainers"]) == 5
    assert len(movers["losers"]) == 5
    gain_pcts = [c["change_24h_pct"] for c in movers["gainers"]]
    lose_pcts = [c["change_24h_pct"] for c in movers["losers"]]
    assert gain_pcts == sorted(gain_pcts, reverse=True)
    assert lose_pcts == sorted(lose_pcts)


async def test_categories(client: httpx.AsyncClient) -> None:
    res = await client.get("/api/categories")
    assert res.status_code == 200
    cats = res.json()["data"]
    assert len(cats) >= 6
    names = {c["name"] for c in cats}
    assert {"Layer 1", "Layer 2", "DeFi", "Meme", "Stablecoin", "Exchange"}.issubset(names)
    assert all(c["count"] > 0 for c in cats)


async def test_watchlist_crud_lifecycle(client: httpx.AsyncClient) -> None:
    device = "device-test-uuid-1234"
    headers = {"X-Device-Id": device}

    # Initially empty
    res = await client.get("/api/watchlist", headers=headers)
    assert res.status_code == 200
    assert res.json()["data"] == []

    # Add bitcoin
    res = await client.post("/api/watchlist", json={"coin_id": "bitcoin"}, headers=headers)
    assert res.status_code == 201
    item = res.json()["data"]
    assert item["coin_id"] == "bitcoin"
    assert item["device_id"] == device
    assert item["coin"]["symbol"] == "BTC"

    # Add ethereum
    res = await client.post("/api/watchlist", json={"coin_id": "ethereum"}, headers=headers)
    assert res.status_code == 201

    # Verify both exist
    res = await client.get("/api/watchlist", headers=headers)
    assert res.status_code == 200
    items = res.json()["data"]
    assert len(items) == 2
    coin_ids = [i["coin_id"] for i in items]
    assert "bitcoin" in coin_ids and "ethereum" in coin_ids

    # Delete bitcoin
    res = await client.delete("/api/watchlist/bitcoin", headers=headers)
    assert res.status_code == 200
    assert res.json()["data"]["deleted"] is True

    # Delete again -> 404
    res = await client.delete("/api/watchlist/bitcoin", headers=headers)
    assert res.status_code == 404


async def test_watchlist_missing_header_rejected(client: httpx.AsyncClient) -> None:
    res = await client.get("/api/watchlist")
    assert res.status_code == 400
    assert res.json()["error"]["code"] == "BAD_REQUEST"


async def test_watchlist_invalid_coin_not_found(client: httpx.AsyncClient) -> None:
    headers = {"X-Device-Id": "test-device"}
    res = await client.post("/api/watchlist", json={"coin_id": "fake-coin"}, headers=headers)
    assert res.status_code == 404
    assert res.json()["error"]["code"] == "NOT_FOUND"
