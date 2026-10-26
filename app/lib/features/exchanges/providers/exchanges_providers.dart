import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/network_providers.dart';
import '../data/exchanges_repository.dart';
import '../data/models/exchange.dart';

final exchangesRepositoryProvider = Provider<ExchangesRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ExchangesRepository(apiClient: apiClient);
});

final selectedExchangeTypeProvider = StateProvider<ExchangeType>((ref) {
  return ExchangeType.cex;
});

final exchangesListProvider = FutureProvider.autoDispose<List<Exchange>>((ref) async {
  final repo = ref.watch(exchangesRepositoryProvider);
  final type = ref.watch(selectedExchangeTypeProvider);
  return repo.getExchanges(type: type);
});
