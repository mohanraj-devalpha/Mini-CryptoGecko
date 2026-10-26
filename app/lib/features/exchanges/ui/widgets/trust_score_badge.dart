import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class TrustScoreBadge extends StatelessWidget {
  final int score;

  const TrustScoreBadge({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    final color = score >= 8
        ? AppColors.trustGreen
        : score >= 6
            ? const Color(0xFFEAB308)
            : AppColors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '$score/10',
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
        ),
      ),
    );
  }
}
