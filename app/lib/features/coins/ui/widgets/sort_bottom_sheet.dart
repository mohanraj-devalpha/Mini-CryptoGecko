import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class SortOptionItem {
  final String key;
  final String label;

  const SortOptionItem(this.key, this.label);
}

class SortBottomSheet extends StatefulWidget {
  final String currentSort;
  final String currentOrder;
  final String currentTimeframe;
  final Function onApply;

  const SortBottomSheet({
    super.key,
    required this.currentSort,
    required this.currentOrder,
    this.currentTimeframe = '24h',
    required this.onApply,
  });

  static const options = [
    SortOptionItem('market_cap', 'Market Cap'),
    SortOptionItem('change_24h', '% Change'),
    SortOptionItem('price', 'Price'),
    SortOptionItem('volume_24h', '24h Volume'),
    SortOptionItem('name', 'Name'),
  ];

  static Future<void> show({
    required BuildContext context,
    required String currentSort,
    required String currentOrder,
    String currentTimeframe = '24h',
    required Function onApply,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SortBottomSheet(
        currentSort: currentSort,
        currentOrder: currentOrder,
        currentTimeframe: currentTimeframe,
        onApply: onApply,
      ),
    );
  }

  @override
  State<SortBottomSheet> createState() => _SortBottomSheetState();
}

class _SortBottomSheetState extends State<SortBottomSheet> {
  late String _selectedSort;
  late String _selectedOrder;
  late String _selectedTimeframe;

  @override
  void initState() {
    super.initState();
    _selectedSort = widget.currentSort;
    _selectedOrder = widget.currentOrder;
    _selectedTimeframe = widget.currentTimeframe;
  }

  void _apply(String sort, String order, {String? timeframe}) {
    try {
      (widget.onApply as dynamic)(sort, order, timeframe: timeframe ?? _selectedTimeframe);
    } catch (_) {
      (widget.onApply as dynamic)(sort, order);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.darkBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF334155),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title "Sort By"
              const Text(
                'Sort By',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkTextPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 16),

              // Horizontal chips for Sort Metrics (Market Cap, % Change, Price, 24h Volume, Name)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: SortBottomSheet.options.map((opt) {
                    final isSelected = opt.key == _selectedSort;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            if (_selectedSort == opt.key) {
                              // Toggle order if clicking already selected
                              _selectedOrder = _selectedOrder == 'desc' ? 'asc' : 'desc';
                            } else {
                              _selectedSort = opt.key;
                              _selectedOrder = 'desc';
                            }
                          });
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF1E2634)
                                : const Color(0xFF151C26),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? AppColors.primary : AppColors.darkBorder,
                              width: isSelected ? 1.4 : 1.0,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                opt.label,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                  color: isSelected ? AppColors.primary : AppColors.darkTextSecondary,
                                ),
                              ),
                              if (isSelected) ...[
                                const SizedBox(width: 6),
                                Icon(
                                  _selectedOrder == 'desc'
                                      ? Icons.arrow_downward_rounded
                                      : Icons.arrow_upward_rounded,
                                  size: 15,
                                  color: AppColors.primary,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 16),

              // Sub-options if % Change is selected (1H, 24H, 7D)
              if (_selectedSort == 'change_24h' || _selectedSort == 'change') ...[
                const Text(
                  'Change Timeframe',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkTextMuted,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: ['1h', '24h', '7d'].map((tf) {
                    final isSelected = _selectedTimeframe == tf;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(tf.toUpperCase()),
                        selected: isSelected,
                        selectedColor: AppColors.primary.withValues(alpha: 0.2),
                        backgroundColor: AppColors.darkSurface,
                        labelStyle: TextStyle(
                          color: isSelected ? AppColors.primary : AppColors.darkTextSecondary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        ),
                        side: BorderSide(
                          color: isSelected ? AppColors.primary : AppColors.darkBorder,
                        ),
                        onSelected: (val) {
                          if (val) setState(() => _selectedTimeframe = tf);
                        },
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
              ],

              // Order Direction Selector
              const Text(
                'Direction',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkTextMuted,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildDirectionButton(
                      label: 'High to Low (Desc)',
                      icon: Icons.trending_down_rounded,
                      isSelected: _selectedOrder == 'desc',
                      onTap: () => setState(() => _selectedOrder = 'desc'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildDirectionButton(
                      label: 'Low to High (Asc)',
                      icon: Icons.trending_up_rounded,
                      isSelected: _selectedOrder == 'asc',
                      onTap: () => setState(() => _selectedOrder = 'asc'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFF151C26),
                        side: const BorderSide(color: AppColors.darkBorder),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        setState(() {
                          _selectedSort = 'market_cap';
                          _selectedOrder = 'desc';
                          _selectedTimeframe = '24h';
                        });
                      },
                      child: const Text(
                        'Default',
                        style: TextStyle(
                          color: AppColors.darkTextPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: const Color(0xFF0F172A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                      ),
                      onPressed: () => _apply(_selectedSort, _selectedOrder, timeframe: _selectedTimeframe),
                      child: const Text(
                        'Apply Sort',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDirectionButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1B382A) : const Color(0xFF151C26),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.darkBorder,
            width: isSelected ? 1.4 : 1.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? AppColors.primary : AppColors.darkTextMuted,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? AppColors.primary : AppColors.darkTextSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
