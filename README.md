# Mini-CryptoGecko (CoinCrypto) 🦎

A sleek, lightweight, and modern cryptocurrency market tracking mobile application built with **Flutter**, **Material 3**, and **Riverpod**. The app provides real-time crypto prices, interactive charts, global market metrics, customizable tables, token search, and a personal watchlist.

---

## 📱 App Screens & Features

- **Markets**:
  - Live ranking of top cryptocurrencies with real-time prices, 24h percentage changes, market cap, and volume.
  - Full-width scrollable category filter chips (*All, Onchain, Top Gainers, Layer 1, AI, Gaming, DeFi, Top Losers*).
  - Global market overview cards displaying Total Market Cap and 24h Volume with trend indicators.
  - Table customization options: switch timeframe (*1h, 24h, 7d*), secondary metric (*Market Cap vs. 24h Volume*), and currency unit (*USD \$ or BTC ₿*).
  - Sorting bottom sheet (*Market Cap, Price, Volume, 24h Change*).

- **Coin Detail & Charts**:
  - Live price flash animation on market ticks.
  - Interactive price charts powered by `fl_chart` across multiple timeframes (*24H, 7D, 30D, 90D, 1Y, MAX*).
  - Comprehensive Key Statistics: All-Time High (ATH) & ATH date, 24h High/Low, Circulating Supply, Total Supply, and Max Supply.
  - One-tap Watchlist star toggle with undo feedback.

- **Search**:
  - Instant coin search by name or ticker symbol with 300ms typing debounce.
  - Infinite scroll pagination: seamlessly loads 50 tokens per batch as you scroll.
  - Pull-to-refresh support.

- **Watchlist**:
  - Locally saved favorite tokens persisted across app restarts via `SharedPreferences`.
  - Live market data and prices for bookmarked assets.
  - Swipe-to-delete with undo SnackBar action.

- **Profile**:
  - Account overview and app preferences.

---

## 🌐 How Data Is Called (Architecture)

The application communicates directly with the **CoinGecko v3 REST API**:

```
┌────────────────────────────────────────────────────────┐
│                   Flutter Client                       │
│  (Riverpod Notifiers -> Repositories -> ApiClient)     │
└───────────────────────────┬────────────────────────────┘
                            │ HTTP GET (JSON)
                            ▼
           CoinGecko API (https://api.coingecko.com/api/v3)
```

### API Endpoints Used

| Feature | CoinGecko Endpoint | Description |
| :--- | :--- | :--- |
| **Market List** | `GET /coins/markets` | Fetches coins with price, 24h change %, volume, rank, and market cap. |
| **Global Stats** | `GET /global` | Fetches aggregate global crypto market cap, volume, and 24h market cap change %. |
| **Coin Details** | `GET /coins/{id}` | Fetches project description, supply metrics, ATH, and 24h stats. |
| **Price Charts** | `GET /coins/{id}/market_chart` | Fetches historical price data points for the interactive chart. |
| **Token Search** | `GET /search?query={q}` | Searches CoinGecko's token database and returns matching coin IDs. |
| **Watchlist** | `GET /coins/markets?ids={ids}` | Fetches live market stats for the user's saved coin IDs. |

### Network & Reliability Features

1. **Rate-Limit Handling**: CoinGecko's public tier allows ~30 requests/minute. The app's `ApiClient` intercepts `429 Too Many Requests` responses and presents a clean notification to retry shortly.
2. **Real-Time Prices**: Handled through periodic 30-second polling against `/coins/markets` or optional WebSocket connectivity (`/ws/prices`).
3. **Local Storage**: Watchlist IDs are stored locally on the device using `SharedPreferences`, avoiding unnecessary backend accounts.
4. **Image Caching**: All coin icons and thumbnails are cached in memory and disk via `CachedNetworkImage` to optimize network bandwidth and render smoothly.

---

## 🛠️ Tech Stack & Dependencies

- **Framework**: [Flutter](https://flutter.dev) (Dart 3.x)
- **State Management**: [Riverpod 2.6](https://riverpod.dev) (`AsyncNotifierProvider`, `StateNotifierProvider`)
- **Networking**: [Dio](https://pub.dev/packages/dio) with custom interceptors
- **Routing**: [GoRouter](https://pub.dev/packages/go_router) with `StatefulShellRoute` (persistent bottom navigation)
- **Charts**: [fl_chart](https://pub.dev/packages/fl_chart)
- **Local Persistence**: [shared_preferences](https://pub.dev/packages/shared_preferences)
- **Image Caching**: [cached_network_image](https://pub.dev/packages/cached_network_image)
- **Data Models**: [Freezed](https://pub.dev/packages/freezed) & [json_serializable](https://pub.dev/packages/json_serializable)

---

## 📁 Project Structure

```text
app/lib/
├── core/
│   ├── network/          # ApiClient, DeviceIdStore, WsClient, Dio Interceptors
│   ├── router/           # AppRouter (GoRouter shell navigation)
│   ├── theme/            # AppColors (Dark theme palette)
│   ├── utils/            # Formatters (currency, percentages, numbers)
│   └── widgets/          # CoinAvatar, EmptyView, ErrorView, LoadingShimmer
├── features/
│   ├── coins/            # Market table, quick chips, pagination, sorting & filters
│   ├── coin_detail/      # Coin profile, interactive chart, stats grid
│   ├── home/             # MarketsHomeScreen, SearchScreen, ProfileScreen
│   ├── market/           # Global market stats cards & market movers
│   └── watchlist/        # Saved coins list, local repository, swipe-to-delete
└── main.dart             # App entry point (ProviderScope initialization)
```

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`>= 3.3.0`)
- Android Studio / Xcode (or connected physical device)

### Installation & Run

1. **Clone the repository:**
   ```bash
   git clone git@github.com:mohanraj-devalpha/Mini-CryptoGecko.git
   cd Mini-CryptoGecko/app
   ```

2. **Install Flutter packages:**
   ```bash
   flutter pub get
   ```

3. **Run code generation (if modifying Freezed models):**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Launch the application:**
   ```bash
   flutter run
   ```

   *(Optional) Pass a custom CoinGecko Demo API key if available:*
   ```bash
   flutter run --dart-define=COINGECKO_API_KEY=your_api_key_here
   ```

5. **Run tests:**
   ```bash
   flutter test
   ```
