import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_shimmer.dart';
import '../../coins/ui/widgets/coin_row.dart';
import '../providers/watchlist_providers.dart';

class WatchlistScreen extends ConsumerWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final watchlistAsync = ref.watch(watchlistProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist'),
        actions: [
          watchlistAsync.maybeWhen(
            data: (items) => items.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceElevated,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                          ),
                        ),
                        child: Text(
                          '${items.length} ${items.length == 1 ? "coin" : "coins"}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(watchlistProvider.notifier).refresh();
        },
        child: watchlistAsync.when(
          loading: () => const LoadingShimmer(itemCount: 6),
          error: (err, _) => ErrorView(
            message: err.toString(),
            onRetry: () => ref.read(watchlistProvider.notifier).refresh(),
          ),
          data: (items) {
            if (items.isEmpty) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: EmptyView(
                        icon: Icons.star_outline_rounded,
                        title: 'Your Watchlist is Empty',
                        description:
                            'Track your favorite cryptocurrencies in real-time by tapping the star icon on any coin details screen.',
                        actionLabel: 'Explore Coins',
                        onAction: () => context.go('/coins'),
                      ),
                    ),
                  );
                },
              );
            }

            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: items.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                indent: 16,
                endIndent: 16,
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
              itemBuilder: (context, index) {
                final item = items[index];
                final coin = item.coin;

                return Dismissible(
                  key: ValueKey('watchlist_${item.coinId}'),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: AppColors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.delete_outline_rounded, color: Colors.white, size: 22),
                        SizedBox(width: 8),
                        Text(
                          'Remove',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onDismissed: (_) {
                    final removedItem = item;
                    ref
                        .read(watchlistProvider.notifier)
                        .toggleWatchlist(item.coinId, item.coin);

                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${coin.name} removed from watchlist'),
                        action: SnackBarAction(
                          label: 'Undo',
                          textColor: AppColors.primary,
                          onPressed: () {
                            ref
                                .read(watchlistProvider.notifier)
                                .toggleWatchlist(removedItem.coinId, removedItem.coin);
                          },
                        ),
                        duration: const Duration(seconds: 4),
                      ),
                    );
                  },
                  child: CoinRow(coin: coin),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
