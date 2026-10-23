import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/core/widgets/empty_view.dart';
import 'package:app/core/widgets/error_view.dart';
import 'package:app/core/widgets/loading_shimmer.dart';
import 'package:app/features/coins/data/models/coin.dart';
import 'package:app/features/watchlist/data/models/watchlist_item.dart';
import 'package:app/features/watchlist/providers/watchlist_providers.dart';
import 'package:app/features/watchlist/ui/watchlist_screen.dart';

void main() {
  const sampleCoin = Coin(
    id: 'bitcoin',
    symbol: 'BTC',
    name: 'Bitcoin',
    imageUrl: null,
    category: 'Layer 1',
    rank: 1,
    price: 67000.0,
    volume24h: 30000000000.0,
    marketCap: 1300000000000.0,
    change24hPct: 2.5,
    high24h: 68000.0,
    low24h: 66000.0,
  );

  final sampleItem = WatchlistItem(
    id: 1,
    deviceId: 'dev-1',
    coinId: 'bitcoin',
    createdAt: DateTime.parse('2026-10-23T00:00:00Z'),
    coin: sampleCoin,
  );

  testWidgets('WatchlistScreen renders LoadingShimmer when loading', (tester) async {
    final completer = Completer<List<WatchlistItem>>();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          watchlistProvider.overrideWith(() => MockWatchlistNotifier(completer.future)),
        ],
        child: const MaterialApp(home: WatchlistScreen()),
      ),
    );

    await tester.pump();
    expect(find.byType(LoadingShimmer), findsOneWidget);
  });

  testWidgets('WatchlistScreen renders ErrorView on error', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          watchlistProvider.overrideWith(
            () => MockWatchlistNotifier(Future.error(Exception('Failed to load watchlist'))),
          ),
        ],
        child: const MaterialApp(home: WatchlistScreen()),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(ErrorView), findsOneWidget);
    expect(find.text('Try Again'), findsOneWidget);
  });

  testWidgets('WatchlistScreen renders EmptyView when watchlist is empty', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          watchlistProvider.overrideWith(
            () => MockWatchlistNotifier(Future.value([])),
          ),
        ],
        child: const MaterialApp(home: WatchlistScreen()),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(EmptyView), findsOneWidget);
    expect(find.text('Your Watchlist is Empty'), findsOneWidget);
    expect(find.text('Explore Coins'), findsOneWidget);
  });

  testWidgets('WatchlistScreen renders items and allows dismissal', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          watchlistProvider.overrideWith(
            () => MockWatchlistNotifier(Future.value([sampleItem])),
          ),
        ],
        child: const MaterialApp(home: WatchlistScreen()),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Bitcoin'), findsOneWidget);
    expect(find.text('BTC'), findsOneWidget);
    expect(find.text('1 coin'), findsOneWidget);

    // Swipe to dismiss
    await tester.drag(find.byType(Dismissible), const Offset(-500, 0));
    await tester.pumpAndSettle();

    expect(find.text('Bitcoin removed from watchlist'), findsOneWidget);
    expect(find.text('Undo'), findsOneWidget);
  });
}

class MockWatchlistNotifier extends WatchlistNotifier {
  final Future<List<WatchlistItem>> _mockFuture;

  MockWatchlistNotifier(this._mockFuture);

  @override
  Future<List<WatchlistItem>> build() => _mockFuture;

  @override
  Future<bool> toggleWatchlist(String coinId, Coin? fallbackCoin) async {
    state = const AsyncData([]);
    return false;
  }
}
