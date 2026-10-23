import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/core/widgets/error_view.dart';
import 'package:app/core/widgets/loading_shimmer.dart';
import 'package:app/features/coins/data/models/coin.dart';
import 'package:app/features/market/data/models/market_stats.dart';
import 'package:app/features/market/providers/market_providers.dart';
import 'package:app/features/market/ui/market_screen.dart';
import 'package:app/features/market/ui/widgets/dominance_bar.dart';
import 'package:app/features/market/ui/widgets/global_cards.dart';

void main() {
  final sampleGlobal = GlobalMarket(
    totalMarketCap: 2500000000000.0,
    totalVolume24h: 85000000000.0,
    btcDominance: 54.2,
    ethDominance: 16.8,
    coinCount: 53,
    marketCapChange24hPct: 3.12,
  );

  const sampleCoin = Coin(
    id: 'solana',
    symbol: 'SOL',
    name: 'Solana',
    imageUrl: null,
    category: 'Layer 1',
    rank: 5,
    price: 180.0,
    volume24h: 4000000000.0,
    marketCap: 85000000000.0,
    change24hPct: 12.5,
    high24h: 185.0,
    low24h: 160.0,
  );

  final sampleMovers = MarketMovers(
    gainers: [sampleCoin],
    losers: [
      sampleCoin.copyWith(
        id: 'cardano',
        symbol: 'ADA',
        name: 'Cardano',
        change24hPct: -4.5,
        price: 0.35,
      ),
    ],
  );

  final sampleCategories = [
    const CategoryItem(name: 'Layer 1', count: 14),
    const CategoryItem(name: 'DeFi', count: 12),
  ];

  testWidgets('MarketScreen renders LoadingShimmer when loading', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          globalMarketProvider.overrideWith((ref) => Future.any([])),
          marketMoversProvider.overrideWith((ref) => Future.any([])),
          marketCategoriesProvider.overrideWith((ref) => Future.any([])),
        ],
        child: const MaterialApp(home: MarketScreen()),
      ),
    );

    await tester.pump();
    expect(find.byType(LoadingShimmer), findsOneWidget);
  });

  testWidgets('MarketScreen renders ErrorView on error', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          globalMarketProvider.overrideWith((ref) => Future.error(Exception('Network error'))),
          marketMoversProvider.overrideWith((ref) => Future.error(Exception('Network error'))),
          marketCategoriesProvider.overrideWith((ref) => Future.error(Exception('Network error'))),
        ],
        child: const MaterialApp(home: MarketScreen()),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(ErrorView), findsOneWidget);
    expect(find.text('Try Again'), findsOneWidget);
  });

  testWidgets('MarketScreen renders GlobalMarketCards, DominanceBar and movers on data', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          globalMarketProvider.overrideWith((ref) => Future.value(sampleGlobal)),
          marketMoversProvider.overrideWith((ref) => Future.value(sampleMovers)),
          marketCategoriesProvider.overrideWith((ref) => Future.value(sampleCategories)),
        ],
        child: const MaterialApp(home: MarketScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Market Overview'), findsOneWidget);
    expect(find.byType(GlobalMarketCards), findsOneWidget);
    expect(find.byType(DominanceBar), findsOneWidget);

    expect(find.text('Top Gainers (24h)'), findsOneWidget);
    expect(find.text('Top Losers (24h)'), findsOneWidget);
    expect(find.text('Solana'), findsOneWidget);
    expect(find.text('Cardano'), findsOneWidget);
    expect(find.text('Sectors & Categories'), findsOneWidget);
    expect(find.text('Layer 1 (14)'), findsOneWidget);
    expect(find.text('DeFi (12)'), findsOneWidget);
  });
}
