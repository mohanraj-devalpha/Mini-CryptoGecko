import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class CategoryChips extends StatelessWidget {
  final String selectedCategory;
  final bool isGainers;
  final bool isLosers;
  final ValueChanged<String> onSelected;

  static const categories = [
    'All',
    'Layer 1',
    'Layer 2',
    'DeFi',
    'Meme',
    'Stablecoin',
    'Exchange',
    'Gainers',
    'Losers',
  ];

  const CategoryChips({
    super.key,
    required this.selectedCategory,
    required this.isGainers,
    required this.isLosers,
    required this.onSelected,
  });

  String get _currentChip {
    if (isGainers) return 'Gainers';
    if (isLosers) return 'Losers';
    return selectedCategory;
  }

  @override
  Widget build(BuildContext context) {
    final active = _currentChip;

    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = cat == active;

          Color? chipTextColor;
          if (cat == 'Gainers') {
            chipTextColor = AppColors.green;
          } else if (cat == 'Losers') {
            chipTextColor = AppColors.red;
          }

          return FilterChip(
            label: Text(
              cat,
              style: TextStyle(
                color: isSelected
                    ? AppColors.primary
                    : (chipTextColor ?? Theme.of(context).textTheme.bodyMedium?.color),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 13,
              ),
            ),
            selected: isSelected,
            showCheckmark: false,
            onSelected: (_) => onSelected(cat),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          );
        },
      ),
    );
  }
}
