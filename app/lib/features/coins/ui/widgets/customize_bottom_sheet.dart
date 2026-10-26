import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../providers/coins_providers.dart';

class CustomizeBottomSheet extends StatefulWidget {
  final TableCustomizationState currentState;
  final Function(TableCustomizationState newState) onApply;

  const CustomizeBottomSheet({
    super.key,
    required this.currentState,
    required this.onApply,
  });

  static Future<void> show({
    required BuildContext context,
    required TableCustomizationState currentState,
    required Function(TableCustomizationState newState) onApply,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CustomizeBottomSheet(
        currentState: currentState,
        onApply: onApply,
      ),
    );
  }

  @override
  State<CustomizeBottomSheet> createState() => _CustomizeBottomSheetState();
}

class _CustomizeBottomSheetState extends State<CustomizeBottomSheet> {
  late String _timeframe;
  late String _secondaryMetric;
  late bool _showInBtc;
  late bool _isCompact;

  @override
  void initState() {
    super.initState();
    _timeframe = widget.currentState.changeTimeframe;
    _secondaryMetric = widget.currentState.secondaryMetric;
    _showInBtc = widget.currentState.showInBtc;
    _isCompact = widget.currentState.isCompact;
  }

  void _reset() {
    setState(() {
      _timeframe = '24h';
      _secondaryMetric = 'market_cap';
      _showInBtc = false;
      _isCompact = false;
    });
  }

  void _apply() {
    final updated = widget.currentState.copyWith(
      changeTimeframe: _timeframe,
      secondaryMetric: _secondaryMetric,
      showInBtc: _showInBtc,
      isCompact: _isCompact,
    );
    widget.onApply(updated);
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

              // Title
              const Text(
                'Customize Table',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkTextPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Select columns, timeframes, and display density.',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.darkTextMuted,
                ),
              ),
              const SizedBox(height: 20),

              // 1. Percentage Change Timeframe
              _buildSectionHeader('Price Change Column'),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildOptionChip(
                    label: '1 Hour (1H)',
                    isSelected: _timeframe == '1h',
                    onTap: () => setState(() => _timeframe = '1h'),
                  ),
                  const SizedBox(width: 8),
                  _buildOptionChip(
                    label: '24 Hours (24H)',
                    isSelected: _timeframe == '24h',
                    onTap: () => setState(() => _timeframe = '24h'),
                  ),
                  const SizedBox(width: 8),
                  _buildOptionChip(
                    label: '7 Days (7D)',
                    isSelected: _timeframe == '7d',
                    onTap: () => setState(() => _timeframe = '7d'),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 2. Secondary Column
              _buildSectionHeader('Secondary Metric Column'),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildOptionChip(
                    label: 'Market Cap',
                    isSelected: _secondaryMetric == 'market_cap',
                    onTap: () => setState(() => _secondaryMetric = 'market_cap'),
                  ),
                  const SizedBox(width: 8),
                  _buildOptionChip(
                    label: '24H Volume',
                    isSelected: _secondaryMetric == 'volume',
                    onTap: () => setState(() => _secondaryMetric = 'volume'),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 3. Price Currency Display
              _buildSectionHeader('Currency Unit'),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildOptionChip(
                    label: 'USD (\$)',
                    isSelected: !_showInBtc,
                    onTap: () => setState(() => _showInBtc = false),
                  ),
                  const SizedBox(width: 8),
                  _buildOptionChip(
                    label: 'Bitcoin (₿)',
                    isSelected: _showInBtc,
                    onTap: () => setState(() => _showInBtc = true),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 4. Row Density
              _buildSectionHeader('Row Density'),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildOptionChip(
                    label: 'Default',
                    isSelected: !_isCompact,
                    onTap: () => setState(() => _isCompact = false),
                  ),
                  const SizedBox(width: 8),
                  _buildOptionChip(
                    label: 'Compact',
                    isSelected: _isCompact,
                    onTap: () => setState(() => _isCompact = true),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Action buttons
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
                      onPressed: _reset,
                      child: const Text(
                        'Reset',
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
                      onPressed: _apply,
                      child: const Text(
                        'Apply Preferences',
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

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.darkTextMuted,
        letterSpacing: -0.2,
      ),
    );
  }

  Widget _buildOptionChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1B382A) : const Color(0xFF151C26),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.darkBorder,
            width: isSelected ? 1.4 : 1.0,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? AppColors.primary : AppColors.darkTextSecondary,
          ),
        ),
      ),
    );
  }
}
