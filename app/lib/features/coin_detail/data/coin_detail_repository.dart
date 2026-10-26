import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import 'models/chart_point.dart';
import 'models/coin_detail.dart';

class CoinDetailRepository {
  final ApiClient apiClient;

  CoinDetailRepository({required this.apiClient});

  Future<CoinDetail> getCoinDetail(String coinId) async {
    try {
      final isCoinGecko = apiClient.isCoinGecko;
      final endpoint = isCoinGecko ? '/coins/$coinId' : '/api/coins/$coinId';
      final queryParams = isCoinGecko
          ? {
              'localization': false,
              'tickers': false,
              'market_data': true,
              'community_data': false,
              'developer_data': false,
            }
          : null;

      final response = await apiClient.dio.get(
        endpoint,
        queryParameters: queryParams,
      );
      final dynamic raw = response.data;
      final map = (raw is Map<String, dynamic> && raw['data'] is Map<String, dynamic>)
          ? raw['data'] as Map<String, dynamic>
          : raw as Map<String, dynamic>;
      return CoinDetail.fromJson(map);
    } on DioException catch (e) {
      if (e.error is AppException) {
        throw e.error!;
      }
      throw AppException(e.message ?? 'Failed to load coin details');
    }
  }

  Future<List<ChartPoint>> getCoinChart(String coinId, String range) async {
    try {
      final isCoinGecko = apiClient.isCoinGecko;

      if (isCoinGecko) {
        final days = switch (range.toUpperCase()) {
          '24H' || '1D' => '1',
          '7D' => '7',
          '30D' || '1M' => '30',
          '90D' || '3M' => '90',
          '1Y' => '365',
          'ALL' => 'max',
          _ => '7',
        };

        final response = await apiClient.dio.get(
          '/coins/$coinId/market_chart',
          queryParameters: {
            'vs_currency': 'usd',
            'days': days,
          },
        );

        final dynamic raw = response.data;
        if (raw is Map<String, dynamic> && raw['prices'] is List) {
          final prices = raw['prices'] as List<dynamic>;
          return prices.map((entry) {
            final list = entry as List<dynamic>;
            return ChartPoint(
              t: DateTime.fromMillisecondsSinceEpoch((list[0] as num).toInt()),
              price: (list[1] as num).toDouble(),
            );
          }).toList();
        } else if (raw is Map<String, dynamic> && raw['data'] is List) {
          final list = raw['data'] as List<dynamic>;
          return list
              .map((item) => ChartPoint.fromJson(item as Map<String, dynamic>))
              .toList();
        }
        return const [];
      } else {
        final response = await apiClient.dio.get(
          '/api/coins/$coinId/chart',
          queryParameters: {'range': range},
        );
        final list = response.data['data'] as List<dynamic>;
        return list
            .map((item) => ChartPoint.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } on DioException catch (e) {
      if (e.error is AppException) {
        throw e.error!;
      }
      throw AppException(e.message ?? 'Failed to load chart data');
    }
  }
}
