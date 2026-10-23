import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/core/widgets/error_view.dart';
import 'package:app/features/coin_detail/data/models/chart_point.dart';
import 'package:app/features/coin_detail/data/models/coin_detail.dart';
import 'package:app/features/coin_detail/providers/coin_detail_providers.dart';
import 'package:app/features/coin_detail/ui/coin_detail_screen.dart';
import 'package:app/features/watchlist/data/models/watchlist_item.dart';
import 'package:app/features/watchlist/providers/watchlist_providers.dart';

void main() {
  final sampleDetail = CoinDetail(
    id: 'bitcoin',
    symbol: 'BTC',
    name: 'Bitcoin',
    imageUrl: null,
    description: 'Bitcoin is digital gold and peer-to-peer cash.',
    category: 'Layer 1',
    circulatingSupply: 19760000.0,
    totalSupply: 19760000.0,
    maxSupply: 21000000.0,
    rank: 1,
    market: CoinMarketData(
      price: 67250.0,
      volume24h: 30000000000.0,
      marketCap: 1300000000000.0,
      change24hPct: 2.34,
      high24h: 68000.0,
      low24h: 66000.0,
      ath: 73750.0,
      athDate: DateTime.parse('2024-03-14T00:00:00Z'),
      updatedAt: DateTime.parse('2026-10-23T06:00:00Z'),
    ),
  );

  testWidgets('CoinDetailScreen renders ErrorView on error', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          coinDetailProvider('bitcoin').overrideWith(
            (ref) => Future.error(Exception('Failed to load detail')),
          ),
        ],
        child: const MaterialApp(
          home: CoinDetailScreen(coinId: 'bitcoin'),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(ErrorView), findsOneWidget);
    expect(find.text('Try Again'), findsOneWidget);
  });

  testWidgets('CoinDetailScreen renders header, chart, stats and description on data', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          coinDetailProvider('bitcoin').overrideWith(
            (ref) => Future.value(sampleDetail),
          ),
          coinChartProvider((coinId: 'bitcoin', range: '7d')).overrideWith(
            (ref) => Future.value([
              ChartPoint(t: DateTime.parse('2026-10-16T00:00:00Z'), price: 65000.0),
              ChartPoint(t: DateTime.parse('2026-10-23T00:00:00Z'), price: 67250.0),
            ]),
          ),
          watchlistProvider.overrideWith(() => MockWatchlistNotifier()),
        ],
        child: const MaterialApp(
          home: CoinDetailScreen(coinId: 'bitcoin'),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Bitcoin'), findsWidgets);
    expect(find.text('#1'), findsWidgets);
    expect(find.text('+2.34%'), findsOneWidget);
    expect(find.text('Key Statistics'), findsOneWidget);
    expect(find.text('Market Cap Rank'), findsOneWidget);
    expect(find.text('All-Time High'), findsOneWidget);
    expect(find.text('About Bitcoin'), findsOneWidget);
    expect(find.byIcon(Icons.star_outline_rounded), findsOneWidget);
  });
}

class MockWatchlistNotifier extends WatchlistNotifier {
  @override
  Future<List<WatchlistItem>> build() async => [];
}
