import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/network_providers.dart';
import '../data/market_repository.dart';
import '../data/models/market_stats.dart';

final marketRepositoryProvider = Provider<MarketRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return MarketRepository(apiClient: apiClient);
});

final globalMarketProvider = FutureProvider<GlobalMarket>((ref) async {
  final repo = ref.watch(marketRepositoryProvider);
  return repo.getGlobalMarket();
});

final marketMoversProvider = FutureProvider<MarketMovers>((ref) async {
  final repo = ref.watch(marketRepositoryProvider);
  return repo.getMarketMovers(limit: 5);
});

final marketCategoriesProvider = FutureProvider<List<CategoryItem>>((ref) async {
  final repo = ref.watch(marketRepositoryProvider);
  return repo.getCategories();
});
