import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/network_providers.dart';
import '../data/categories_repository.dart';
import '../data/models/coin_gecko_category.dart';

final categoriesRepositoryProvider = Provider<CategoriesRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CategoriesRepository(apiClient: apiClient);
});

final selectedCategoryFilterProvider = StateProvider<String>((ref) => 'All');

final coinGeckoCategoriesProvider = FutureProvider.autoDispose<List<CoinGeckoCategory>>((ref) async {
  final repo = ref.watch(categoriesRepositoryProvider);
  return repo.getCategories();
});
