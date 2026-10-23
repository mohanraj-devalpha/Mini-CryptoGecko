import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/core/widgets/empty_view.dart';
import 'package:app/core/widgets/error_view.dart';
import 'package:app/core/widgets/loading_shimmer.dart';
import 'package:app/features/coins/data/models/coin.dart';
import 'package:app/features/coins/providers/coins_providers.dart';
import 'package:app/features/coins/ui/coins_screen.dart';

void main() {
  const sampleCoin = Coin(
    id: 'bitcoin',
    symbol: 'BTC',
    name: 'Bitcoin',
    imageUrl: null,
    category: 'Layer 1',
    rank: 1,
    price: 67250.0,
    volume24h: 30000000000.0,
    marketCap: 1300000000000.0,
    change24hPct: 2.34,
    high24h: 68000.0,
    low24h: 66000.0,
  );

  testWidgets('CoinsScreen renders LoadingShimmer when loading', (tester) async {
    final completer = Completer<PaginatedCoinsState>();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          paginatedCoinsProvider.overrideWith(() => MockNotifier(completer.future)),
        ],
        child: const MaterialApp(home: CoinsScreen()),
      ),
    );

    // Initial pump -> shows loading shimmer
    await tester.pump();
    expect(find.byType(LoadingShimmer), findsOneWidget);
  });

  testWidgets('CoinsScreen renders ErrorView when error occurs', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          paginatedCoinsProvider.overrideWith(
            () => MockNotifier(Future.error(Exception('Failed to fetch coins'))),
          ),
        ],
        child: const MaterialApp(home: CoinsScreen()),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(ErrorView), findsOneWidget);
    expect(find.text('Try Again'), findsOneWidget);
  });

  testWidgets('CoinsScreen renders EmptyView when coins list is empty', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          paginatedCoinsProvider.overrideWith(
            () => MockNotifier(
              Future.value(
                const PaginatedCoinsState(
                  coins: [],
                  page: 1,
                  hasMore: false,
                ),
              ),
            ),
          ),
        ],
        child: const MaterialApp(home: CoinsScreen()),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(EmptyView), findsOneWidget);
    expect(find.text('No coins found'), findsOneWidget);
  });

  testWidgets('CoinsScreen renders CoinRow items when data arrives', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          paginatedCoinsProvider.overrideWith(
            () => MockNotifier(
              Future.value(
                const PaginatedCoinsState(
                  coins: [sampleCoin],
                  page: 1,
                  hasMore: false,
                ),
              ),
            ),
          ),
        ],
        child: const MaterialApp(home: CoinsScreen()),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Bitcoin'), findsOneWidget);
    expect(find.text('BTC'), findsOneWidget);
    expect(find.text('+2.34%'), findsOneWidget);
  });
}

class MockNotifier extends PaginatedCoinsNotifier {
  final Future<PaginatedCoinsState> _mockFuture;

  MockNotifier(this._mockFuture);

  @override
  Future<PaginatedCoinsState> build() => _mockFuture;
}
