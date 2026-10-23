import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/coin_avatar.dart';
import '../../../../core/widgets/price_flash.dart';
import '../../data/models/coin.dart';
import '../../providers/coins_providers.dart';

class CoinRow extends ConsumerWidget {
  final Coin coin;

  const CoinRow({super.key, required this.coin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Only rebuild this specific row when this coin's live price updates
    final liveUpdate = ref.watch(singleCoinLiveUpdateProvider(coin.id));

    final currentPrice = liveUpdate?.price ?? coin.price;
    final currentChange = liveUpdate?.change24h ?? coin.change24hPct;
    final isGain = currentChange >= 0;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () => context.push('/coin/${coin.id}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Global rank
            SizedBox(
              width: 24,
              child: Text(
                '${coin.rank}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Coin Avatar
            CoinAvatar(
              imageUrl: coin.imageUrl,
              symbol: coin.symbol,
              size: 38,
            ),
            const SizedBox(width: 12),

            // Name & Symbol
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    coin.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        coin.symbol.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        Formatters.formatCompactCurrency(coin.marketCap),
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Price & 24h change badge
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                PriceFlashText(
                  price: currentPrice,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isGain ? AppColors.greenSurface : AppColors.redSurface,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    Formatters.formatPercentage(currentChange),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isGain ? AppColors.green : AppColors.red,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
