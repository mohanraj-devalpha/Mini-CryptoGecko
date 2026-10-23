import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import 'models/coin.dart';

class CoinsResponse {
  final List<Coin> coins;
  final int page;
  final int perPage;
  final int total;
  final int pages;

  const CoinsResponse({
    required this.coins,
    required this.page,
    required this.perPage,
    required this.total,
    required this.pages,
  });
}

class CoinsRepository {
  final ApiClient apiClient;

  CoinsRepository({required this.apiClient});

  Future<CoinsResponse> getCoins({
    int page = 1,
    int perPage = 25,
    String sort = 'market_cap',
    String order = 'desc',
    String? category,
    String? query,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'per_page': perPage,
        'sort': sort,
        'order': order,
      };

      if (category != null && category.isNotEmpty && category != 'All') {
        queryParams['category'] = category;
      }
      if (query != null && query.trim().isNotEmpty) {
        queryParams['q'] = query.trim();
      }

      final response = await apiClient.dio.get(
        '/api/coins',
        queryParameters: queryParams,
      );

      final dataList = response.data['data'] as List<dynamic>;
      final meta = response.data['meta'] as Map<String, dynamic>;

      final coins = dataList
          .map((item) => Coin.fromJson(item as Map<String, dynamic>))
          .toList();

      return CoinsResponse(
        coins: coins,
        page: meta['page'] as int,
        perPage: meta['per_page'] as int,
        total: meta['total'] as int,
        pages: meta['pages'] as int,
      );
    } on DioException catch (e) {
      if (e.error is AppException) {
        throw e.error!;
      }
      throw AppException(e.message ?? 'Failed to load coins');
    }
  }
}
