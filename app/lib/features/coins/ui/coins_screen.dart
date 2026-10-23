import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_shimmer.dart';
import '../providers/coins_providers.dart';
import 'widgets/category_chips.dart';
import 'widgets/coin_row.dart';
import 'widgets/sort_bottom_sheet.dart';

class CoinsScreen extends ConsumerStatefulWidget {
  const CoinsScreen({super.key});

  @override
  ConsumerState<CoinsScreen> createState() => _CoinsScreenState();
}

class _CoinsScreenState extends ConsumerState<CoinsScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _debounceTimer;

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

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(coinsFilterProvider);
    final coinsAsync = ref.watch(paginatedCoinsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('CoinScope'),
        actions: [
          IconButton(
            tooltip: 'Sort coins',
            icon: const Icon(Icons.sort_rounded),
            onPressed: () {
              SortBottomSheet.show(
                context: context,
                currentSort: filter.sort,
                currentOrder: filter.order,
                onApply: (sort, order) {
                  ref.read(coinsFilterProvider.notifier).setSort(sort, order);
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search input
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search coins (e.g. Bitcoin, ETH)...',
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(coinsFilterProvider.notifier).setQuery('');
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Horizontal category & gainers/losers chips
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: CategoryChips(
              selectedCategory: filter.category,
              isGainers: filter.isGainers,
              isLosers: filter.isLosers,
              onSelected: (cat) {
                ref.read(coinsFilterProvider.notifier).setCategory(cat);
              },
            ),
          ),

          const SizedBox(height: 4),
          const Divider(height: 1),

          // Content body based on state
          Expanded(
            child: coinsAsync.when(
              loading: () => const LoadingShimmer(itemCount: 12),
              error: (err, stack) => ErrorView(
                message: err.toString(),
                onRetry: () => ref.read(paginatedCoinsProvider.notifier).refresh(),
              ),
              data: (state) {
                if (state.coins.isEmpty) {
                  return EmptyView(
                    title: 'No coins found',
                    description: filter.query.isNotEmpty
                        ? 'No cryptocurrency matches "${filter.query}"'
                        : 'No coins available for the selected filters',
                    actionLabel: 'Clear filters',
                    onAction: () {
                      _searchController.clear();
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
                      return CoinRow(coin: state.coins[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
