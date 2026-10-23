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

  const CoinsFilterState({
    this.query = '',
    this.category = 'All',
    this.isGainers = false,
    this.isLosers = false,
    this.sort = 'market_cap',
    this.order = 'desc',
  });

  CoinsFilterState copyWith({
    String? query,
    String? category,
    bool? isGainers,
    bool? isLosers,
    String? sort,
    String? order,
  }) {
    return CoinsFilterState(
      query: query ?? this.query,
      category: category ?? this.category,
      isGainers: isGainers ?? this.isGainers,
      isLosers: isLosers ?? this.isLosers,
      sort: sort ?? this.sort,
      order: order ?? this.order,
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

  void setSort(String sort, String order) {
    state = state.copyWith(
      sort: sort,
      order: order,
      isGainers: false,
      isLosers: false,
    );
  }

  void reset() {
    state = const CoinsFilterState();
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

  Future<PaginatedCoinsState> _fetchInitial(CoinsFilterState filter) async {
    final repo = ref.read(coinsRepositoryProvider);
    final response = await repo.getCoins(
      page: 1,
      perPage: 25,
      sort: filter.sort,
      order: filter.order,
      category: filter.category == 'All' ? null : filter.category,
      query: filter.query,
    );

    var list = response.coins;
    if (filter.isGainers) {
      list = list.where((c) => c.change24hPct >= 0).toList();
    } else if (filter.isLosers) {
      list = list.where((c) => c.change24hPct < 0).toList();
    }

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
        perPage: 25,
        sort: filter.sort,
        order: filter.order,
        category: filter.category == 'All' ? null : filter.category,
        query: filter.query,
      );

      var newItems = response.coins;
      if (filter.isGainers) {
        newItems = newItems.where((c) => c.change24hPct >= 0).toList();
      } else if (filter.isLosers) {
        newItems = newItems.where((c) => c.change24hPct < 0).toList();
      }

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
