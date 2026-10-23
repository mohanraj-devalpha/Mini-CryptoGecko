import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import 'models/market_stats.dart';

class MarketRepository {
  final ApiClient apiClient;

  MarketRepository({required this.apiClient});

  Future<GlobalMarket> getGlobalMarket() async {
    try {
      final response = await apiClient.dio.get('/api/market/global');
      final data = response.data['data'] as Map<String, dynamic>;
      return GlobalMarket.fromJson(data);
    } on DioException catch (e) {
      if (e.error is AppException) {
        throw e.error!;
      }
      throw AppException(e.message ?? 'Failed to load global market stats');
    }
  }

  Future<MarketMovers> getMarketMovers({int limit = 5}) async {
    try {
      final response = await apiClient.dio.get(
        '/api/market/movers',
        queryParameters: {'limit': limit},
      );
      final data = response.data['data'] as Map<String, dynamic>;
      return MarketMovers.fromJson(data);
    } on DioException catch (e) {
      if (e.error is AppException) {
        throw e.error!;
      }
      throw AppException(e.message ?? 'Failed to load top market movers');
    }
  }

  Future<List<CategoryItem>> getCategories() async {
    try {
      final response = await apiClient.dio.get('/api/categories');
      final list = response.data['data'] as List<dynamic>;
      return list
          .map((item) => CategoryItem.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (e.error is AppException) {
        throw e.error!;
      }
      throw AppException(e.message ?? 'Failed to load categories');
    }
  }
}
