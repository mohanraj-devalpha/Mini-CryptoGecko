import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../data/models/coin_gecko_category.dart';
import 'overlapping_avatars.dart';

class CategoryRow extends StatelessWidget {
  final CoinGeckoCategory category;

  const CategoryRow({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final isNegative = category.change24hPct < 0;
    final changeColor = isNegative ? AppColors.red : AppColors.green;

    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Overlapping Top 3 Coins
            OverlappingAvatars(imageUrls: category.top3Coins),

            const SizedBox(width: 12),

            // Category Name
            Expanded(
              child: Text(
                category.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkTextPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(width: 8),

            // 24H Change
            SizedBox(
              width: 70,
              child: Text(
                CurrencyFormatter.formatPercent(category.change24hPct),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: changeColor,
                ),
                textAlign: TextAlign.right,
              ),
            ),

            const SizedBox(width: 16),

            // Market Cap
            SizedBox(
              width: 85,
              child: Text(
                CurrencyFormatter.formatCompact(category.marketCap, symbol: '\$'),
                style: const TextStyle(
                  fontSize: 14,
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
