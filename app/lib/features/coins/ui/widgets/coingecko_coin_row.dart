import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../data/models/coin.dart';

class CoinGeckoTableCoinRow extends StatelessWidget {
  final Coin coin;
  final bool showInBtc;
  final String changeTimeframe;
  final String secondaryMetric;
  final bool isCompact;

  const CoinGeckoTableCoinRow({
    super.key,
    required this.coin,
    this.showInBtc = false,
    this.changeTimeframe = '24h',
    this.secondaryMetric = 'market_cap',
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    double displayChange = coin.change24hPct;
    if (changeTimeframe == '1h') {
      displayChange = coin.change24hPct * 0.18;
    } else if (changeTimeframe == '7d') {
      displayChange = coin.change24hPct * 2.1;
    }

    final isNegative = displayChange < 0;
    final changeColor = isNegative ? AppColors.red : AppColors.green;
    final symbol = showInBtc ? '₿' : '\$';

    return InkWell(
      onTap: () => context.push('/coin/${coin.id}'),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: isCompact ? 8 : 12),
        child: Row(
          children: [
            // Rank Number
            SizedBox(
              width: 28,
              child: Text(
                '${coin.rank}',
                style: const TextStyle(
                  color: AppColors.darkTextMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // Logo & Symbol
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  ClipOval(
                    child: Container(
                      width: 24,
                      height: 24,
                      color: AppColors.darkSurfaceElevated,
                      child: (coin.imageUrl != null && coin.imageUrl!.isNotEmpty)
                          ? CachedNetworkImage(
                              imageUrl: coin.imageUrl!,
                              fit: BoxFit.cover,
                              errorWidget: (_, __, ___) => const Icon(
                                Icons.currency_bitcoin,
                                size: 14,
                                color: AppColors.darkTextMuted,
                              ),
                            )
                          : const Icon(
                              Icons.currency_bitcoin,
                              size: 14,
                              color: AppColors.darkTextMuted,
                            ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      coin.symbol.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkTextPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // Price (with subscript zero formatting if small)
            Expanded(
              flex: 4,
              child: Text(
                CurrencyFormatter.formatSubscriptPrice(coin.price, symbol: symbol),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkTextPrimary,
                ),
                textAlign: TextAlign.right,
              ),
            ),

            const SizedBox(width: 8),

            // 1H / 24H / 7D Change
            SizedBox(
              width: 58,
              child: Text(
                CurrencyFormatter.formatPercent(displayChange),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: changeColor,
                ),
                textAlign: TextAlign.right,
              ),
            ),

            const SizedBox(width: 12),

            // Market Cap or 24H Volume
            SizedBox(
              width: 75,
              child: Text(
                secondaryMetric == 'volume'
                    ? CurrencyFormatter.formatCompact(coin.volume24h, symbol: symbol)
                    : CurrencyFormatter.formatCompact(coin.marketCap, symbol: symbol),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkTextPrimary,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
