import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import 'models/chart_point.dart';
import 'models/coin_detail.dart';

class CoinDetailRepository {
  final ApiClient apiClient;

  CoinDetailRepository({required this.apiClient});

  Future<CoinDetail> getCoinDetail(String coinId) async {
    try {
      final response = await apiClient.dio.get('/api/coins/$coinId');
      final data = response.data['data'] as Map<String, dynamic>;
      return CoinDetail.fromJson(data);
    } on DioException catch (e) {
      if (e.error is AppException) {
        throw e.error!;
      }
      throw AppException(e.message ?? 'Failed to load coin details');
    }
  }

  Future<List<ChartPoint>> getCoinChart(String coinId, String range) async {
    try {
      final response = await apiClient.dio.get(
        '/api/coins/$coinId/chart',
        queryParameters: {'range': range},
      );
      final list = response.data['data'] as List<dynamic>;
      return list
          .map((item) => ChartPoint.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (e.error is AppException) {
        throw e.error!;
      }
      throw AppException(e.message ?? 'Failed to load chart data');
    }
  }
}
