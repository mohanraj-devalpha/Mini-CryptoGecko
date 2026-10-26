import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/network_providers.dart';
import '../../../core/network/ws_client.dart';
import '../data/coins_repository.dart';
import '../data/models/coin.dart';

final coinsRepositoryProvider = Provider<CoinsRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CoinsRepository(apiClient: apiClient);
});

// Live price updates map
final livePricesMapProvider = StateProvider<Map<String, PriceUpdate>>((ref) {
  final stream = ref.watch(priceStreamProvider);
  return stream.maybeWhen(
    data: (updates) {
      final map = <String, PriceUpdate>{};
      for (final u in updates) {
        map[u.coinId] = u;
      }
      return map;
    },
    orElse: () => <String, PriceUpdate>{},
  );
});

// Single coin live update family
final singleCoinLiveUpdateProvider = Provider.family<PriceUpdate?, String>((ref, coinId) {
  final map = ref.watch(livePricesMapProvider);
  return map[coinId];
});

class CoinsFilterState {
  final String query;
  final String category;
  final bool isGainers;
  final bool isLosers;
  final String sort;
  final String order;
  final String? quickFilter;
  final String chain;
  final String exchange;
  final String marketCapRange;
  final String volumeRange;
  final String sortTimeframe;

  const CoinsFilterState({
    this.query = '',
    this.category = 'All',
    this.isGainers = false,
    this.isLosers = false,
    this.sort = 'market_cap',
    this.order = 'desc',
    this.quickFilter,
    this.chain = 'All Chains',
    this.exchange = 'All Exchanges',
    this.marketCapRange = 'all',
    this.volumeRange = 'all',
    this.sortTimeframe = '24h',
  });

  bool get hasActiveFilters =>
      query.isNotEmpty ||
      (category != 'All' && category != 'All Categories') ||
      isGainers ||
      isLosers ||
      quickFilter != null ||
      chain != 'All Chains' ||
      exchange != 'All Exchanges' ||
      marketCapRange != 'all' ||
      volumeRange != 'all';

  bool get hasActiveSort =>
      sort != 'market_cap' || order != 'desc' || sortTimeframe != '24h';

  CoinsFilterState copyWith({
    String? query,
    String? category,
    bool? isGainers,
    bool? isLosers,
    String? sort,
    String? order,
    String? quickFilter,
    bool clearQuickFilter = false,
    String? chain,
    String? exchange,
    String? marketCapRange,
    String? volumeRange,
    String? sortTimeframe,
  }) {
    return CoinsFilterState(
      query: query ?? this.query,
      category: category ?? this.category,
      isGainers: isGainers ?? this.isGainers,
      isLosers: isLosers ?? this.isLosers,
      sort: sort ?? this.sort,
      order: order ?? this.order,
      quickFilter: clearQuickFilter ? null : (quickFilter ?? this.quickFilter),
      chain: chain ?? this.chain,
      exchange: exchange ?? this.exchange,
      marketCapRange: marketCapRange ?? this.marketCapRange,
      volumeRange: volumeRange ?? this.volumeRange,
      sortTimeframe: sortTimeframe ?? this.sortTimeframe,
    );
  }
}

final coinsFilterProvider = StateNotifierProvider<CoinsFilterNotifier, CoinsFilterState>((ref) {
  return CoinsFilterNotifier();
});

class CoinsFilterNotifier extends StateNotifier<CoinsFilterState> {
  CoinsFilterNotifier() : super(const CoinsFilterState());

  void setQuery(String q) {
    state = state.copyWith(query: q);
  }

  void setCategory(String category) {
    if (category == 'Gainers') {
      state = state.copyWith(
        category: 'All',
        isGainers: true,
        isLosers: false,
        sort: 'change_24h',
        order: 'desc',
      );
    } else if (category == 'Losers') {
      state = state.copyWith(
        category: 'All',
        isGainers: false,
        isLosers: true,
        sort: 'change_24h',
        order: 'asc',
      );
    } else {
      state = state.copyWith(
        category: category,
        isGainers: false,
        isLosers: false,
      );
    }
  }

  void setSort(String sort, String order, {String? timeframe}) {
    state = state.copyWith(
      sort: sort,
      order: order,
      sortTimeframe: timeframe ?? state.sortTimeframe,
      isGainers: false,
      isLosers: false,
    );
  }

  void setQuickFilter(String? quickFilter) {
    if (state.quickFilter == quickFilter) {
      state = state.copyWith(clearQuickFilter: true);
    } else {
      state = state.copyWith(quickFilter: quickFilter);
    }
  }

  void applyComprehensiveFilter({
    String? quickFilter,
    required String chain,
    required String category,
    required String exchange,
    required String marketCapRange,
    required String volumeRange,
  }) {
    state = state.copyWith(
      quickFilter: quickFilter,
      clearQuickFilter: quickFilter == null,
      chain: chain,
      category: category,
      exchange: exchange,
      marketCapRange: marketCapRange,
      volumeRange: volumeRange,
      isGainers: false,
      isLosers: false,
    );
  }

  void reset() {
    state = const CoinsFilterState();
  }
}

class TableCustomizationState {
  final String changeTimeframe; // '1h', '24h', '7d'
  final String secondaryMetric; // 'market_cap', 'volume'
  final bool showInBtc; // false: $, true: ₿
  final bool isCompact; // false: normal, true: compact

  const TableCustomizationState({
    this.changeTimeframe = '24h',
    this.secondaryMetric = 'market_cap',
    this.showInBtc = false,
    this.isCompact = false,
  });

  bool get isCustomized =>
      changeTimeframe != '24h' ||
      secondaryMetric != 'market_cap' ||
      showInBtc ||
      isCompact;

  TableCustomizationState copyWith({
    String? changeTimeframe,
    String? secondaryMetric,
    bool? showInBtc,
    bool? isCompact,
  }) {
    return TableCustomizationState(
      changeTimeframe: changeTimeframe ?? this.changeTimeframe,
      secondaryMetric: secondaryMetric ?? this.secondaryMetric,
      showInBtc: showInBtc ?? this.showInBtc,
      isCompact: isCompact ?? this.isCompact,
    );
  }
}

final tableCustomizationProvider =
    StateNotifierProvider<TableCustomizationNotifier, TableCustomizationState>((ref) {
  return TableCustomizationNotifier();
});

class TableCustomizationNotifier extends StateNotifier<TableCustomizationState> {
  TableCustomizationNotifier() : super(const TableCustomizationState());

  void update({
    String? changeTimeframe,
    String? secondaryMetric,
    bool? showInBtc,
    bool? isCompact,
  }) {
    state = state.copyWith(
      changeTimeframe: changeTimeframe,
      secondaryMetric: secondaryMetric,
      showInBtc: showInBtc,
      isCompact: isCompact,
    );
  }

  void reset() {
    state = const TableCustomizationState();
  }
}

class PaginatedCoinsState {
  final List<Coin> coins;
  final int page;
  final bool hasMore;
  final bool isLoadingMore;

  const PaginatedCoinsState({
    required this.coins,
    required this.page,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  PaginatedCoinsState copyWith({
    List<Coin>? coins,
    int? page,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return PaginatedCoinsState(
      coins: coins ?? this.coins,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

final paginatedCoinsProvider =
    AsyncNotifierProvider<PaginatedCoinsNotifier, PaginatedCoinsState>(() {
  return PaginatedCoinsNotifier();
});

class PaginatedCoinsNotifier extends AsyncNotifier<PaginatedCoinsState> {
  @override
  Future<PaginatedCoinsState> build() async {
    final filter = ref.watch(coinsFilterProvider);
    return _fetchInitial(filter);
  }

  List<Coin> _filterAndSort(List<Coin> rawCoins, CoinsFilterState filter) {
    var list = List<Coin>.from(rawCoins);

    // Filter by Quick Filter
    if (filter.quickFilter != null && filter.quickFilter!.isNotEmpty) {
      switch (filter.quickFilter) {
        case 'on_the_move':
          list = list.where((c) => c.change24hPct.abs() >= 3.0 || c.volume24h > 100000000).toList();
          break;
        case 'blue_chips':
          list = list.where((c) => c.rank <= 25 || c.marketCap >= 10000000000).toList();
          break;
        case 'growing':
          list = list.where((c) => c.change24hPct > 1.0 && c.marketCap >= 50000000).toList();
          break;
        case 'small_caps':
          list = list.where((c) => c.marketCap < 200000000 && c.volume24h > 500000).toList();
          break;
        case 'breakouts':
          list = list.where((c) => c.change24hPct >= 5.0).toList();
          break;
      }
    }

    // Filter by Market Cap Range
    if (filter.marketCapRange != 'all') {
      switch (filter.marketCapRange) {
        case 'large':
          list = list.where((c) => c.marketCap >= 1000000000).toList();
          break;
        case 'mid':
          list = list.where((c) => c.marketCap >= 100000000 && c.marketCap < 1000000000).toList();
          break;
        case 'small':
          list = list.where((c) => c.marketCap >= 10000000 && c.marketCap < 100000000).toList();
          break;
        case 'micro':
          list = list.where((c) => c.marketCap < 10000000 && c.marketCap > 0).toList();
          break;
      }
    }

    // Filter by 24h Volume Range
    if (filter.volumeRange != 'all') {
      switch (filter.volumeRange) {
        case 'gt_50m':
          list = list.where((c) => c.volume24h >= 50000000).toList();
          break;
        case 'gt_10m':
          list = list.where((c) => c.volume24h >= 10000000).toList();
          break;
        case 'gt_1m':
          list = list.where((c) => c.volume24h >= 1000000).toList();
          break;
      }
    }

    // Filter by Gainers / Losers
    if (filter.isGainers) {
      list = list.where((c) => c.change24hPct >= 0).toList();
    } else if (filter.isLosers) {
      list = list.where((c) => c.change24hPct < 0).toList();
    }

    // Filter by Chain if selected
    if (filter.chain != 'All Chains') {
      final chainLower = filter.chain.toLowerCase();
      list = list.where((c) =>
        c.category.toLowerCase().contains(chainLower) ||
        c.name.toLowerCase().contains(chainLower) ||
        c.symbol.toLowerCase().contains(chainLower)
      ).toList();
    }

    // Apply Sorting
    final isAsc = filter.order == 'asc';
    switch (filter.sort) {
      case 'price':
        list.sort((a, b) => isAsc ? a.price.compareTo(b.price) : b.price.compareTo(a.price));
        break;
      case 'change_24h':
      case 'change':
        list.sort((a, b) => isAsc ? a.change24hPct.compareTo(b.change24hPct) : b.change24hPct.compareTo(a.change24hPct));
        break;
      case 'volume_24h':
      case 'volume':
        list.sort((a, b) => isAsc ? a.volume24h.compareTo(b.volume24h) : b.volume24h.compareTo(a.volume24h));
        break;
      case 'name':
        list.sort((a, b) => isAsc ? a.name.toLowerCase().compareTo(b.name.toLowerCase()) : b.name.toLowerCase().compareTo(a.name.toLowerCase()));
        break;
      case 'market_cap':
      default:
        list.sort((a, b) => isAsc ? a.marketCap.compareTo(b.marketCap) : b.marketCap.compareTo(a.marketCap));
        break;
    }

    return list;
  }

  Future<PaginatedCoinsState> _fetchInitial(CoinsFilterState filter) async {
    final repo = ref.read(coinsRepositoryProvider);
    final response = await repo.getCoins(
      page: 1,
      perPage: 50,
      sort: filter.sort,
      order: filter.order,
      category: (filter.category == 'All' || filter.category == 'All Categories') ? null : filter.category,
      query: filter.query,
    );

    final list = _filterAndSort(response.coins, filter);

    // Subscribe websocket to the active visible coins for live updates
    ref.read(wsClientProvider).subscribe(list.map((c) => c.id).toList());

    return PaginatedCoinsState(
      coins: list,
      page: 1,
      hasMore: response.page < response.pages,
    );
  }

  Future<void> loadNextPage() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));

    try {
      final filter = ref.read(coinsFilterProvider);
      final repo = ref.read(coinsRepositoryProvider);
      final nextPage = current.page + 1;

      final response = await repo.getCoins(
        page: nextPage,
        perPage: 50,
        sort: filter.sort,
        order: filter.order,
        category: (filter.category == 'All' || filter.category == 'All Categories') ? null : filter.category,
        query: filter.query,
      );

      final newItems = _filterAndSort(response.coins, filter);
      final allCoins = [...current.coins, ...newItems];
      ref.read(wsClientProvider).subscribe(allCoins.map((c) => c.id).toList());

      state = AsyncData(
        PaginatedCoinsState(
          coins: allCoins,
          page: nextPage,
          hasMore: response.page < response.pages,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      state = AsyncData(current.copyWith(isLoadingMore: false));
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    ref.invalidateSelf();
  }
}

