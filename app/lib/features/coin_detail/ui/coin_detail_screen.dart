import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/utils/formatters.dart';
import 'package:app/core/widgets/coin_avatar.dart';
import 'package:app/core/widgets/error_view.dart';
import 'package:app/core/widgets/price_flash.dart';
import 'package:app/features/coins/data/models/coin.dart';
import 'package:app/features/coins/providers/coins_providers.dart';
import 'package:app/features/watchlist/providers/watchlist_providers.dart';
import '../providers/coin_detail_providers.dart';
import 'widgets/interactive_chart.dart';
import 'widgets/stats_grid.dart';

class CoinDetailScreen extends ConsumerWidget {
  final String coinId;

  const CoinDetailScreen({super.key, required this.coinId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(coinDetailProvider(coinId));
    final isWatchlisted = ref.watch(isCoinWatchlistedProvider(coinId));
    final liveUpdate = ref.watch(singleCoinLiveUpdateProvider(coinId));

    return detailAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(title: Text(coinId.toUpperCase())),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Scaffold(
        appBar: AppBar(title: const Text('Coin Details')),
        body: ErrorView(
          message: err.toString(),
          onRetry: () => ref.refresh(coinDetailProvider(coinId)),
        ),
      ),
      data: (detail) {
        final currentPrice = liveUpdate?.price ?? detail.market.price;
        final currentChange = liveUpdate?.change24h ?? detail.market.change24hPct;
        final isGain = currentChange >= 0;
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Scaffold(
          appBar: AppBar(
            title: Text(detail.name),
            actions: [
              IconButton(
                icon: Icon(
                  isWatchlisted ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: isWatchlisted ? Colors.amber : null,
                  size: 26,
                ),
                tooltip: isWatchlisted ? 'Remove from Watchlist' : 'Add to Watchlist',
                onPressed: () async {
                  final fallback = Coin(
                    id: detail.id,
                    symbol: detail.symbol,
                    name: detail.name,
                    imageUrl: detail.imageUrl,
                    category: detail.category,
                    rank: detail.rank,
                    price: currentPrice,
                    volume24h: detail.market.volume24h,
                    marketCap: detail.market.marketCap,
                    change24hPct: currentChange,
                    high24h: detail.market.high24h,
                    low24h: detail.market.low24h,
                  );

                  try {
                    final added = await ref
                        .read(watchlistProvider.notifier)
                        .toggleWatchlist(coinId, fallback);

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: const Duration(seconds: 2),
                          content: Text(
                            added
                                ? '${detail.name} added to Watchlist'
                                : '${detail.name} removed from Watchlist',
                          ),
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: AppColors.red,
                          content: Text('Failed to update watchlist: $e'),
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Header: Avatar, Name, Symbol, Rank, Category
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      CoinAvatar(
                        imageUrl: detail.imageUrl,
                        symbol: detail.symbol,
                        size: 46,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  detail.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceElevated,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                                    ),
                                  ),
                                  child: Text(
                                    '#${detail.rank}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${detail.symbol.toUpperCase()} • ${detail.category}',
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Live Price and 24h change
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      PriceFlashText(
                        price: currentPrice,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isGain ? AppColors.greenSurface : AppColors.redSurface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          Formatters.formatPercentage(currentChange),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isGain ? AppColors.green : AppColors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Interactive Chart
                InteractiveChart(coinId: coinId),

                const SizedBox(height: 24),

                // Key Statistics Grid
                StatsGrid(detail: detail),

                const SizedBox(height: 16),

                // About section
                if (detail.description.isNotEmpty)
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About ${detail.name}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            detail.description,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.5,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
