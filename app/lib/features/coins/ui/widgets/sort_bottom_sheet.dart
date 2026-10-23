import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class SortOption {
  final String key;
  final String label;

  const SortOption(this.key, this.label);
}

class SortBottomSheet extends StatelessWidget {
  final String currentSort;
  final String currentOrder;
  final Function(String sort, String order) onApply;

  static const options = [
    SortOption('market_cap', 'Market Capitalization'),
    SortOption('price', 'Price'),
    SortOption('change_24h', '24h % Change'),
    SortOption('volume', '24h Volume'),
    SortOption('name', 'Name'),
  ];

  const SortBottomSheet({
    super.key,
    required this.currentSort,
    required this.currentOrder,
    required this.onApply,
  });

  static Future<void> show({
    required BuildContext context,
    required String currentSort,
    required String currentOrder,
    required Function(String sort, String order) onApply,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SortBottomSheet(
        currentSort: currentSort,
        currentOrder: currentOrder,
        onApply: onApply,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Sort Coins By',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...options.map((opt) {
              final isSelected = opt.key == currentSort;
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                  color: isSelected ? AppColors.primary : Colors.grey,
                ),
                title: Text(
                  opt.label,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? AppColors.primary : null,
                  ),
                ),
                trailing: isSelected
                    ? SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(value: 'desc', label: Text('High → Low')),
                          ButtonSegment(value: 'asc', label: Text('Low → High')),
                        ],
                        selected: {currentOrder},
                        onSelectionChanged: (set) {
                          onApply(opt.key, set.first);
                          Navigator.of(context).pop();
                        },
                      )
                    : null,
                onTap: () {
                  onApply(opt.key, currentOrder);
                  Navigator.of(context).pop();
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
