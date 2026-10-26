import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_shimmer.dart';
import '../providers/coins_providers.dart';
import 'widgets/coingecko_coin_row.dart';
import 'widgets/crypto_market_overview_cards.dart';
import 'widgets/customize_bottom_sheet.dart';
import 'widgets/filter_bottom_sheet.dart';
import 'widgets/sort_bottom_sheet.dart';

class CryptocurrencyTab extends ConsumerStatefulWidget {
  const CryptocurrencyTab({super.key});

  @override
  ConsumerState<CryptocurrencyTab> createState() => _CryptocurrencyTabState();
}

class _CryptocurrencyTabState extends ConsumerState<CryptocurrencyTab> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  Timer? _debounceTimer;
  bool _showSearch = false;
  String _activeChip = 'All';

  final List<String> _quickChips = [
    'All',
    '🎲 Onchain',
    '🚀 Top Gainers',
    '✨ New Coins',
    '💎 Layer 1',
    '🤖 AI',
    '🎮 Gaming',
    '🏦 DeFi',
    '📉 Top Losers',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(paginatedCoinsProvider.notifier).loadNextPage();
    }
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      ref.read(coinsFilterProvider.notifier).setQuery(query);
    });
  }

  void _onChipSelected(String chip) {
    setState(() {
      _activeChip = chip;
    });

    final notifier = ref.read(coinsFilterProvider.notifier);

    switch (chip) {
      case '🚀 Top Gainers':
        notifier.setCategory('Gainers');
        break;
      case '📉 Top Losers':
        notifier.setCategory('Losers');
        break;
      case '✨ New Coins':
        notifier.setSort('market_cap', 'asc');
        break;
      case '🎲 Onchain':
        notifier.setCategory('onchain');
        break;
      case '💎 Layer 1':
        notifier.setCategory('layer-1');
        break;
      case '🤖 AI':
        notifier.setCategory('artificial-intelligence');
        break;
      case '🎮 Gaming':
        notifier.setCategory('gaming');
        break;
      case '🏦 DeFi':
        notifier.setCategory('decentralized-finance-defi');
        break;
      case 'All':
      default:
        notifier.reset();
        break;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(coinsFilterProvider);
    final customization = ref.watch(tableCustomizationProvider);
    final coinsAsync = ref.watch(paginatedCoinsProvider);

    return Column(
      children: [
        // Top Global Market & 24H Volume Cards (hidden during search to maximize vertical space)
        if (!_showSearch) ...[
          const SizedBox(height: 8),
          const CryptoMarketOverviewCards(),
          const SizedBox(height: 12),
        ],

        // Full-width Scrollable Category Chips (no cramped truncation)
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _quickChips.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final chip = _quickChips[index];
              return _buildFilterChip(
                chip,
                isSelected: _activeChip == chip,
                onTap: () => _onChipSelected(chip),
              );
            },
          ),
        ),

        const SizedBox(height: 10),

        // Dedicated Actions Row: Quick Search Pill (left) + Table Controls (right)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // Search bar / pill
              Expanded(
                child: _showSearch
                    ? SizedBox(
                        height: 36,
                        child: TextField(
                          controller: _searchController,
                          onChanged: _onSearchChanged,
                          autofocus: true,
                          style: const TextStyle(fontSize: 13),
                          decoration: InputDecoration(
                            hintText: 'Search cryptocurrency...',
                            hintStyle: const TextStyle(fontSize: 12, color: AppColors.darkTextMuted),
                            prefixIcon: const Icon(Icons.search_rounded, size: 18),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.close_rounded, size: 16),
                              onPressed: () {
                                setState(() => _showSearch = false);
                                _searchController.clear();
                                ref.read(coinsFilterProvider.notifier).setQuery('');
                              },
                            ),
                          ),
                        ),
                      )
                    : InkWell(
                        onTap: () => setState(() => _showSearch = true),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          height: 36,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: AppColors.darkSurface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.darkBorder),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.search_rounded, size: 17, color: AppColors.darkTextMuted),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  filter.query.isNotEmpty ? filter.query : 'Search coins...',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: filter.query.isNotEmpty
                                        ? AppColors.darkTextPrimary
                                        : AppColors.darkTextMuted,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (filter.query.isNotEmpty)
                                GestureDetector(
                                  onTap: () {
                                    _searchController.clear();
                                    ref.read(coinsFilterProvider.notifier).setQuery('');
                                  },
                                  child: const Icon(Icons.close_rounded, size: 16, color: AppColors.darkTextMuted),
                                ),
                            ],
                          ),
                        ),
                      ),
              ),

              const SizedBox(width: 10),

              // Segmented Action Control: [ Filter | Sort | Customize ]
              _buildSegmentedControls(context, filter, customization),
            ],
          ),
        ),

        // Optional Active Filter Indicators Bar
        if (filter.hasActiveFilters)
          _buildActiveFiltersBar(context, filter),

        const SizedBox(height: 6),

        // Dynamic Table Header based on table customization
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              const SizedBox(
                width: 28,
                child: Text('#', style: TextStyle(color: AppColors.darkTextMuted, fontSize: 12)),
              ),
              const Expanded(
                flex: 3,
                child: Text('Coin', style: TextStyle(color: AppColors.darkTextMuted, fontSize: 12)),
              ),
              const Expanded(
                flex: 4,
                child: Text('Price', textAlign: TextAlign.right, style: TextStyle(color: AppColors.darkTextMuted, fontSize: 12)),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 58,
                child: Text(
                  customization.changeTimeframe.toUpperCase(),
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: AppColors.darkTextMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 75,
                child: Text(
                  customization.secondaryMetric == 'volume' ? '24H Vol' : 'Market Cap',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: AppColors.darkTextMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        const Divider(height: 1),

        // Coins Table List
        Expanded(
          child: coinsAsync.when(
            loading: () => const LoadingShimmer(itemCount: 12),
            error: (err, _) => ErrorView(
              message: err.toString(),
              onRetry: () => ref.read(paginatedCoinsProvider.notifier).refresh(),
            ),
            data: (state) {
              if (state.coins.isEmpty) {
                return EmptyView(
                  title: 'No coins found',
                  description: filter.query.isNotEmpty
                      ? 'No cryptocurrency matches "${filter.query}"'
                      : 'No coins match the active filters or criteria.',
                  actionLabel: 'Reset filters',
                  onAction: () {
                    _searchController.clear();
                    setState(() {
                      _activeChip = 'All';
                      _showSearch = false;
                    });
                    ref.read(coinsFilterProvider.notifier).reset();
                  },
                );
              }

              return RefreshIndicator(
                onRefresh: () => ref.read(paginatedCoinsProvider.notifier).refresh(),
                child: ListView.separated(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: state.coins.length + (state.isLoadingMore ? 1 : 0),
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    if (index == state.coins.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      );
                    }
                    return CoinGeckoTableCoinRow(
                      coin: state.coins[index],
                      showInBtc: customization.showInBtc,
                      changeTimeframe: customization.changeTimeframe,
                      secondaryMetric: customization.secondaryMetric,
                      isCompact: customization.isCompact,
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Segmented pill containing: [ Filter | Sort | Customize ]
  Widget _buildSegmentedControls(
    BuildContext context,
    CoinsFilterState filter,
    TableCustomizationState customization,
  ) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. FILTER ICON BUTTON
          _buildSegmentButton(
            icon: Icons.filter_alt_outlined,
            isActive: filter.hasActiveFilters,
            showBadge: filter.hasActiveFilters,
            tooltip: 'Filter coins',
            onTap: () {
              FilterBottomSheet.show(
                context: context,
                initialFilter: filter,
                onApply: (CoinsFilterState updated) {
                  ref.read(coinsFilterProvider.notifier).applyComprehensiveFilter(
                    quickFilter: updated.quickFilter,
                    chain: updated.chain,
                    category: updated.category,
                    exchange: updated.exchange,
                    marketCapRange: updated.marketCapRange,
                    volumeRange: updated.volumeRange,
                  );
                },
              );
            },
          ),

          // Divider
          Container(width: 1, height: 18, color: AppColors.darkBorder),

          // 2. SORT ICON BUTTON
          _buildSegmentButton(
            icon: Icons.swap_vert_rounded,
            isActive: filter.hasActiveSort,
            tooltip: 'Sort coins',
            onTap: () {
              SortBottomSheet.show(
                context: context,
                currentSort: filter.sort,
                currentOrder: filter.order,
                currentTimeframe: filter.sortTimeframe,
                onApply: (sort, order, {timeframe}) {
                  ref.read(coinsFilterProvider.notifier).setSort(
                    sort,
                    order,
                    timeframe: timeframe,
                  );
                },
              );
            },
          ),

          // Divider
          Container(width: 1, height: 18, color: AppColors.darkBorder),

          // 3. CUSTOMIZE ICON BUTTON
          _buildSegmentButton(
            icon: Icons.tune_rounded,
            isActive: customization.isCustomized,
            tooltip: 'Customize table',
            onTap: () {
              CustomizeBottomSheet.show(
                context: context,
                currentState: customization,
                onApply: (TableCustomizationState newState) {
                  ref.read(tableCustomizationProvider.notifier).update(
                    changeTimeframe: newState.changeTimeframe,
                    secondaryMetric: newState.secondaryMetric,
                    showInBtc: newState.showInBtc,
                    isCompact: newState.isCompact,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentButton({
    required IconData icon,
    required bool isActive,
    bool showBadge = false,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(7),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                icon,
                size: 18,
                color: isActive ? AppColors.primary : AppColors.darkTextSecondary,
              ),
              if (showBadge)
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(
    String label, {
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Center(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withValues(alpha: 0.18) : AppColors.darkSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.darkBorder,
              width: 1.0,
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
      ),
    );
  }

  Widget _buildActiveFiltersBar(BuildContext context, CoinsFilterState filter) {
    final activeChips = <Widget>[];

    if (filter.quickFilter != null) {
      activeChips.add(_buildActiveTag('Filter: ${filter.quickFilter}', () {
        ref.read(coinsFilterProvider.notifier).setQuickFilter(filter.quickFilter);
      }));
    }
    if (filter.chain != 'All Chains') {
      activeChips.add(_buildActiveTag('Chain: ${filter.chain}', () {
        ref.read(coinsFilterProvider.notifier).applyComprehensiveFilter(
          quickFilter: filter.quickFilter,
          chain: 'All Chains',
          category: filter.category,
          exchange: filter.exchange,
          marketCapRange: filter.marketCapRange,
          volumeRange: filter.volumeRange,
        );
      }));
    }
    if (filter.category != 'All' && filter.category != 'All Categories') {
      activeChips.add(_buildActiveTag('Cat: ${filter.category}', () {
        ref.read(coinsFilterProvider.notifier).setCategory('All');
      }));
    }
    if (filter.marketCapRange != 'all') {
      activeChips.add(_buildActiveTag('MCap: ${filter.marketCapRange.toUpperCase()}', () {
        ref.read(coinsFilterProvider.notifier).applyComprehensiveFilter(
          quickFilter: filter.quickFilter,
          chain: filter.chain,
          category: filter.category,
          exchange: filter.exchange,
          marketCapRange: 'all',
          volumeRange: filter.volumeRange,
        );
      }));
    }
    if (filter.volumeRange != 'all') {
      activeChips.add(_buildActiveTag('Vol: ${filter.volumeRange}', () {
        ref.read(coinsFilterProvider.notifier).applyComprehensiveFilter(
          quickFilter: filter.quickFilter,
          chain: filter.chain,
          category: filter.category,
          exchange: filter.exchange,
          marketCapRange: filter.marketCapRange,
          volumeRange: 'all',
        );
      }));
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(children: activeChips),
            ),
          ),
          InkWell(
            onTap: () => ref.read(coinsFilterProvider.notifier).reset(),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              child: Text(
                'Clear All',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveTag(String label, VoidCallback onRemove) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 4),
          InkWell(
            onTap: onRemove,
            child: const Icon(
              Icons.close_rounded,
              size: 13,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
