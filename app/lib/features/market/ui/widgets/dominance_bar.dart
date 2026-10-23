import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class DominanceBar extends StatelessWidget {
  final double btcDominance;
  final double ethDominance;

  const DominanceBar({
    super.key,
    required this.btcDominance,
    required this.ethDominance,
  });

  @override
  Widget build(BuildContext context) {
    final others = (100.0 - btcDominance - ethDominance).clamp(0.0, 100.0);
    const btcColor = Color(0xFFF7931A); // Bitcoin Orange
    const ethColor = Color(0xFF627EEA); // Ethereum Blue
    const othersColor = Color(0xFF64748B); // Slate Muted

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Market Dominance',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            // Multi-segment proportional bar
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: SizedBox(
                height: 12,
                child: Row(
                  children: [
                    Flexible(
                      flex: (btcDominance * 10).toInt(),
                      child: Container(color: btcColor),
                    ),
                    const SizedBox(width: 2),
                    Flexible(
                      flex: (ethDominance * 10).toInt(),
                      child: Container(color: ethColor),
                    ),
                    const SizedBox(width: 2),
                    Flexible(
                      flex: (others * 10).toInt(),
                      child: Container(color: othersColor),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLegendItem('BTC', '${btcDominance.toStringAsFixed(1)}%', btcColor),
                _buildLegendItem('ETH', '${ethDominance.toStringAsFixed(1)}%', ethColor),
                _buildLegendItem('Others', '${others.toStringAsFixed(1)}%', othersColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String name, String percentage, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          name,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 4),
        Text(
          percentage,
          style: const TextStyle(fontSize: 12, color: AppColors.darkTextSecondary),
        ),
      ],
    );
  }
}
