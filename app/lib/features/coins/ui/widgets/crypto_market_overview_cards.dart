import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/sparkline_mini_chart.dart';
import '../../../market/providers/market_providers.dart';

class CryptoMarketOverviewCards extends ConsumerWidget {
  const CryptoMarketOverviewCards({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final globalAsync = ref.watch(globalMarketProvider);

    return globalAsync.when(
      loading: () => const SizedBox(height: 90),
      error: (_, __) => const SizedBox.shrink(),
      data: (global) {
        final isGain = global.marketCapChange24hPct >= 0;
        final trendColor = isGain ? AppColors.green : AppColors.red;

        // Mock sparkline data for realistic trend curve
        final mcapSparkline = isGain
            ? [31.2, 31.8, 31.5, 32.4, 32.9, 33.1, 33.42]
            : [35.6, 35.1, 34.8, 34.2, 33.9, 33.5, 33.42];

        final volSparkline = [710.0, 695.0, 720.0, 680.0, 690.0, 675.09];

        return Container(
          height: 104,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              // Global Market Cap Card
              _buildMetricCard(
                title: 'Global Market Cap',
                value: CurrencyFormatter.formatCompact(global.totalMarketCap, symbol: '\$'),
                changeText: CurrencyFormatter.formatPercent(global.marketCapChange24hPct),
                changeColor: trendColor,
                sparklineData: mcapSparkline,
                sparklineColor: trendColor,
              ),

              const SizedBox(width: 10),

              // 24H Volume Card
              _buildMetricCard(
                title: '24H Volume',
                value: CurrencyFormatter.formatCompact(global.totalVolume24h, symbol: '\$'),
                changeText: null,
                sparklineData: volSparkline,
                sparklineColor: AppColors.red,
              ),

              const SizedBox(width: 10),

              // AI Summary / Insight Card
              Container(
                width: 220,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.darkSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.darkBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.auto_awesome, size: 14, color: Color(0xFFFACC15)),
                        SizedBox(width: 4),
                        Text(
                          'Summary',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.darkTextPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Bitcoin remained rangebound near \$68k following derivative liquidations.',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.darkTextSecondary,
                        height: 1.3,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    String? changeText,
    Color? changeColor,
    required List<double> sparklineData,
    required Color sparklineColor,
  }) {
    return Container(
      width: 170,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.darkTextMuted,
            ),
          ),
          Row(
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkTextPrimary,
                ),
              ),
              if (changeText != null) ...[
                const SizedBox(width: 6),
                Text(
                  changeText,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: changeColor ?? AppColors.red,
                  ),
                ),
              ],
            ],
          ),
          SparklineMiniChart(
            data: sparklineData,
            color: sparklineColor,
            height: 28,
            width: 140,
          ),
        ],
      ),
    );
  }
}
