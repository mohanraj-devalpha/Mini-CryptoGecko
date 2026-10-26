import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../providers/coins_providers.dart';

class FilterBottomSheet extends StatefulWidget {
  final CoinsFilterState initialFilter;
  final Function(CoinsFilterState updatedFilter) onApply;

  const FilterBottomSheet({
    super.key,
    required this.initialFilter,
    required this.onApply,
  });

  static Future<void> show({
    required BuildContext context,
    required CoinsFilterState initialFilter,
    required Function(CoinsFilterState updatedFilter) onApply,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FilterBottomSheet(
        initialFilter: initialFilter,
        onApply: onApply,
      ),
    );
  }

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String? _selectedQuickFilter;
  late String _selectedChain;
  late String _selectedCategory;
  late String _selectedExchange;
  late String _selectedMarketCap;
  late String _selectedVolume;

  static const List<Map<String, String>> _quickFilterOptions = [
    {'id': 'on_the_move', 'label': '🔥 On the Move'},
    {'id': 'blue_chips', 'label': '💎 Blue Chips'},
    {'id': 'growing', 'label': '📈 Growing Projects'},
    {'id': 'small_caps', 'label': '🌱 Active Small Caps'},
    {'id': 'breakouts', 'label': '🚀 Recent Breakouts'},
  ];

  static const List<String> _chains = [
    'All Chains',
    'Ethereum',
    'Solana',
    'BNB Chain',
    'Polygon',
    'Arbitrum',
    'Avalanche',
    'Base',
    'Optimism',
    'TON',
    'Tron',
    'Cardano',
    'Sui',
    'Aptos',
  ];

  static const List<String> _categories = [
    'All Categories',
    'Decentralized Finance (DeFi)',
    'Layer 1 (L1)',
    'Layer 2 (L2)',
    'Meme Coins',
    'Artificial Intelligence (AI)',
    'Gaming (GameFi)',
    'Real World Assets (RWA)',
    'Non-Fungible Tokens (NFT)',
    'Liquid Staking',
    'DePIN',
  ];

  static const List<String> _exchanges = [
    'All Exchanges',
    'Binance',
    'Coinbase Exchange',
    'Kraken',
    'Bybit',
    'OKX',
    'KuCoin',
    'Gate.io',
    'MEXC',
  ];

  static const List<Map<String, String>> _marketCapOptions = [
    {'id': 'all', 'label': 'All'},
    {'id': 'large', 'label': 'Large: >\$1B'},
    {'id': 'mid', 'label': 'Mid: \$100M to \$1B'},
    {'id': 'small', 'label': 'Small: \$10M to \$100M'},
    {'id': 'micro', 'label': 'Micro: <\$10M'},
    {'id': 'custom', 'label': 'Custom'},
  ];

  static const List<Map<String, String>> _volumeOptions = [
    {'id': 'all', 'label': 'All'},
    {'id': 'gt_50m', 'label': '>\$50M'},
    {'id': 'gt_10m', 'label': '>\$10M'},
    {'id': 'gt_1m', 'label': '>\$1M'},
    {'id': 'custom', 'label': 'Custom'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedQuickFilter = widget.initialFilter.quickFilter;
    _selectedChain = widget.initialFilter.chain;
    _selectedCategory = widget.initialFilter.category.isEmpty || widget.initialFilter.category == 'All'
        ? 'All Categories'
        : widget.initialFilter.category;
    _selectedExchange = widget.initialFilter.exchange;
    _selectedMarketCap = widget.initialFilter.marketCapRange;
    _selectedVolume = widget.initialFilter.volumeRange;
  }

  void _reset() {
    setState(() {
      _selectedQuickFilter = null;
      _selectedChain = 'All Chains';
      _selectedCategory = 'All Categories';
      _selectedExchange = 'All Exchanges';
      _selectedMarketCap = 'all';
      _selectedVolume = 'all';
    });
  }

  void _apply() {
    final updated = widget.initialFilter.copyWith(
      quickFilter: _selectedQuickFilter,
      clearQuickFilter: _selectedQuickFilter == null,
      chain: _selectedChain,
      category: _selectedCategory,
      exchange: _selectedExchange,
      marketCapRange: _selectedMarketCap,
      volumeRange: _selectedVolume,
    );
    widget.onApply(updated);
    Navigator.of(context).pop();
  }

  Future<void> _showOptionPicker({
    required String title,
    required List<String> options,
    required String selected,
    required ValueChanged<String> onSelected,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.darkSurfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (pickerCtx) {
        String searchQuery = '';
        return StatefulBuilder(
          builder: (context, setPickerState) {
            final filtered = options.where((o) => o.toLowerCase().contains(searchQuery.toLowerCase())).toList();

            return SafeArea(
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.7,
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.darkBorder,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        onChanged: (val) {
                          setPickerState(() => searchQuery = val);
                        },
                        decoration: InputDecoration(
                          hintText: 'Search $title...',
                          prefixIcon: const Icon(Icons.search_rounded, size: 20),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          filled: true,
                          fillColor: AppColors.darkSurface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: AppColors.darkBorder),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.separated(
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.darkBorder),
                        itemBuilder: (ctx, index) {
                          final item = filtered[index];
                          final isItemSel = item == selected;
                          return ListTile(
                            title: Text(
                              item,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isItemSel ? FontWeight.w700 : FontWeight.w500,
                                color: isItemSel ? AppColors.primary : AppColors.darkTextPrimary,
                              ),
                            ),
                            trailing: isItemSel
                                ? const Icon(Icons.check_rounded, color: AppColors.primary, size: 20)
                                : null,
                            onTap: () {
                              onSelected(item);
                              Navigator.of(pickerCtx).pop();
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      decoration: const BoxDecoration(
        color: AppColors.darkBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Drag handle & title
            const SizedBox(height: 12),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF334155),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Filters',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkTextPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 12),

            // Scrollable filter content
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                children: [
                  // 1. Quick Filters
                  _buildSectionLabel('Quick Filters'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 10,
                    children: _quickFilterOptions.map((opt) {
                      final isSelected = _selectedQuickFilter == opt['id'];
                      return _buildChip(
                        label: opt['label']!,
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            _selectedQuickFilter = isSelected ? null : opt['id'];
                          });
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // 2. Chain Dropdown
                  _buildSectionLabel('Chain'),
                  const SizedBox(height: 10),
                  _buildDropdownField(
                    value: _selectedChain,
                    onTap: () {
                      _showOptionPicker(
                        title: 'Select Chain',
                        options: _chains,
                        selected: _selectedChain,
                        onSelected: (val) => setState(() => _selectedChain = val),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // 3. Categories Dropdown
                  _buildSectionLabel('Categories'),
                  const SizedBox(height: 10),
                  _buildDropdownField(
                    value: _selectedCategory,
                    onTap: () {
                      _showOptionPicker(
                        title: 'Select Category',
                        options: _categories,
                        selected: _selectedCategory,
                        onSelected: (val) => setState(() => _selectedCategory = val),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // 4. Exchanges Dropdown
                  _buildSectionLabel('Exchanges'),
                  const SizedBox(height: 10),
                  _buildDropdownField(
                    value: _selectedExchange,
                    onTap: () {
                      _showOptionPicker(
                        title: 'Select Exchange',
                        options: _exchanges,
                        selected: _selectedExchange,
                        onSelected: (val) => setState(() => _selectedExchange = val),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // 5. Market Cap
                  _buildSectionLabel('Market Cap'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 10,
                    children: _marketCapOptions.map((opt) {
                      final isSelected = _selectedMarketCap == opt['id'];
                      return _buildMarketPill(
                        label: opt['label']!,
                        isSelected: isSelected,
                        onTap: () => setState(() => _selectedMarketCap = opt['id']!),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // 6. 24h Volume
                  _buildSectionLabel('24h Volume'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 10,
                    children: _volumeOptions.map((opt) {
                      final isSelected = _selectedVolume == opt['id'];
                      return _buildMarketPill(
                        label: opt['label']!,
                        isSelected: isSelected,
                        onTap: () => setState(() => _selectedVolume = opt['id']!),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),

            // Fixed Bottom Action Bar (Reset & Apply Filter)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: AppColors.darkBg,
                border: Border(
                  top: BorderSide(color: AppColors.darkBorder, width: 1.0),
                ),
              ),
              child: Row(
                children: [
                  // Reset Button
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
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Apply Filter Button
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: const Color(0xFF0F172A),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: _apply,
                      child: const Text(
                        'Apply Filter',
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.darkTextPrimary,
        letterSpacing: -0.2,
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1B382A) : const Color(0xFF151C26),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFF222C3D),
            width: isSelected ? 1.4 : 1.0,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? AppColors.primary : AppColors.darkTextSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildMarketPill({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1D5A27) : const Color(0xFF151C26),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? const Color(0xFF388E3C) : const Color(0xFF222C3D),
            width: 1.0,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.darkTextSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF151C26),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF222C3D)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkTextPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.darkTextMuted,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
