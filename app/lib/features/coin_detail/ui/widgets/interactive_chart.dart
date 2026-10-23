import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/error_view.dart';
import '../../data/models/chart_point.dart';
import '../../providers/coin_detail_providers.dart';

class InteractiveChart extends ConsumerWidget {
  final String coinId;

  const InteractiveChart({super.key, required this.coinId});

  static const ranges = ['1d', '7d', '30d', '1y'];
  static const rangeLabels = {'1d': '1D', '7d': '7D', '30d': '1M', '1y': '1Y'};

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentRange = ref.watch(selectedChartRangeProvider(coinId));
    final chartAsync = ref.watch(
      coinChartProvider((coinId: coinId, range: currentRange)),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Range tabs: 1D | 7D | 1M | 1Y
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkSurfaceElevated
                : AppColors.lightSurfaceElevated,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: ranges.map((r) {
              final isSelected = r == currentRange;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    ref.read(selectedChartRangeProvider(coinId).notifier).state = r;
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        rangeLabels[r] ?? r.toUpperCase(),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : (Theme.of(context).brightness == Brightness.dark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 16),

        // Chart display
        SizedBox(
          height: 240,
          child: chartAsync.when(
            loading: () => const Center(
              child: SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              ),
            ),
            error: (err, _) => ErrorView(
              message: 'Failed to load chart data',
              onRetry: () => ref.refresh(
                coinChartProvider((coinId: coinId, range: currentRange)),
              ),
            ),
            data: (points) {
              if (points.isEmpty) {
                return const Center(child: Text('Chart data not available'));
              }
              return _buildLineChart(context, points);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLineChart(BuildContext context, List<ChartPoint> points) {
    final firstPrice = points.first.price;
    final lastPrice = points.last.price;
    final isBullish = lastPrice >= firstPrice;
    final trendColor = isBullish ? AppColors.green : AppColors.red;

    final spots = <FlSpot>[];
    double minY = points.first.price;
    double maxY = points.first.price;

    for (int i = 0; i < points.length; i++) {
      final p = points[i].price;
      if (p < minY) minY = p;
      if (p > maxY) maxY = p;
      spots.add(FlSpot(i.toDouble(), p));
    }

    final padding = (maxY - minY) * 0.08;
    minY = (minY - padding).clamp(0, double.infinity);
    maxY = maxY + padding;

    return Padding(
      padding: const EdgeInsets.only(right: 16, left: 16, top: 8),
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (points.length - 1).toDouble(),
          minY: minY,
          maxY: maxY,
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineTouchData: LineTouchData(
            handleBuiltInTouches: true,
            touchTooltipData: LineTouchTooltipData(
              fitInsideHorizontally: true,
              fitInsideVertically: true,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  final index = spot.x.toInt().clamp(0, points.length - 1);
                  final pt = points[index];
                  final formattedPrice = Formatters.formatPrice(pt.price);
                  final formattedDate = Formatters.formatChartTooltip(pt.t);

                  return LineTooltipItem(
                    '$formattedPrice\n',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    children: [
                      TextSpan(
                        text: formattedDate,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  );
                }).toList();
              },
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.18,
              preventCurveOverShooting: true,
              color: trendColor,
              barWidth: 2.2,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    trendColor.withValues(alpha: 0.28),
                    trendColor.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      ),
    );
  }
}
