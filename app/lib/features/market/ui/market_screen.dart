import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_shimmer.dart';
import '../providers/market_providers.dart';
import 'widgets/dominance_bar.dart';
import 'widgets/global_cards.dart';
import 'widgets/movers_section.dart';

class MarketScreen extends ConsumerWidget {
  const MarketScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final globalAsync = ref.watch(globalMarketProvider);
    final moversAsync = ref.watch(marketMoversProvider);
    final categoriesAsync = ref.watch(marketCategoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Market Overview'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(globalMarketProvider);
          ref.invalidate(marketMoversProvider);
          ref.invalidate(marketCategoriesProvider);
        },
        child: globalAsync.when(
          loading: () => const LoadingShimmer(itemCount: 8),
          error: (err, _) => ErrorView(
            message: err.toString(),
            onRetry: () {
              ref.invalidate(globalMarketProvider);
              ref.invalidate(marketMoversProvider);
              ref.invalidate(marketCategoriesProvider);
            },
          ),
          data: (global) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(top: 8, bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Global Overview Cards
                  GlobalMarketCards(market: global),

                  const SizedBox(height: 16),

                  // Dominance Bar
                  DominanceBar(
                    btcDominance: global.btcDominance,
                    ethDominance: global.ethDominance,
                  ),

                  const SizedBox(height: 16),

                  // Movers Section (Gainers & Losers)
                  moversAsync.when(
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    error: (err, _) => Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text('Movers unavailable: $err'),
                    ),
                    data: (movers) {
                      return Column(
                        children: [
                          MoversSection(
                            title: 'Top Gainers (24h)',
                            coins: movers.gainers,
                            isGainers: true,
                          ),
                          const SizedBox(height: 16),
                          MoversSection(
                            title: 'Top Losers (24h)',
                            coins: movers.losers,
                            isGainers: false,
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  // Categories Overview
                  categoriesAsync.when(
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (cats) {
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Sectors & Categories',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: cats.map((cat) {
                                  return Chip(
                                    label: Text('${cat.name} (${cat.count})'),
                                    padding: const EdgeInsets.symmetric(horizontal: 4),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
