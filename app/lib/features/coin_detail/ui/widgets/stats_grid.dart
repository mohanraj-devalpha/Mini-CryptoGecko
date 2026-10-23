import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../data/models/coin_detail.dart';

class StatsGrid extends StatelessWidget {
  final CoinDetail detail;

  const StatsGrid({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    final m = detail.market;

    final stats = [
      _StatItem('Market Cap Rank', '#${detail.rank}'),
      _StatItem('Market Cap', Formatters.formatCompactCurrency(m.marketCap)),
      _StatItem('24h Trading Vol', Formatters.formatCompactCurrency(m.volume24h)),
      _StatItem('24h High', Formatters.formatPrice(m.high24h)),
      _StatItem('24h Low', Formatters.formatPrice(m.low24h)),
      _StatItem('All-Time High', Formatters.formatPrice(m.ath)),
      _StatItem('ATH Date', Formatters.formatDate(m.athDate)),
      _StatItem('Circulating Supply', '${Formatters.formatCompactNumber(detail.circulatingSupply)} ${detail.symbol}'),
      _StatItem('Total Supply', '${Formatters.formatCompactNumber(detail.totalSupply)} ${detail.symbol}'),
      _StatItem(
        'Max Supply',
        detail.maxSupply != null
            ? '${Formatters.formatCompactNumber(detail.maxSupply!)} ${detail.symbol}'
            : '∞ Infinite',
      ),
    ];

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Key Statistics',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: stats.length,
              separatorBuilder: (_, __) => Divider(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                height: 16,
              ),
              itemBuilder: (context, index) {
                final item = stats[index];
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                    Text(
                      item.value,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem {
  final String label;
  final String value;
  const _StatItem(this.label, this.value);
}
