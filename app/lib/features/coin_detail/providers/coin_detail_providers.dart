import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/network_providers.dart';
import '../data/coin_detail_repository.dart';
import '../data/models/chart_point.dart';
import '../data/models/coin_detail.dart';

final coinDetailRepositoryProvider = Provider<CoinDetailRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CoinDetailRepository(apiClient: apiClient);
});

final coinDetailProvider =
    FutureProvider.family<CoinDetail, String>((ref, coinId) async {
  final repo = ref.watch(coinDetailRepositoryProvider);
  final detail = await repo.getCoinDetail(coinId);

  // Subscribe websocket to this coin for live updates while on detail page
  ref.read(wsClientProvider).subscribe([coinId]);

  return detail;
});

final selectedChartRangeProvider =
    StateProvider.family<String, String>((ref, coinId) {
  return '7d';
});

final coinChartProvider = FutureProvider.family<List<ChartPoint>,
    ({String coinId, String range})>((ref, params) async {
  final repo = ref.watch(coinDetailRepositoryProvider);
  return repo.getCoinChart(params.coinId, params.range);
});
