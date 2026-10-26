import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../coins/data/models/coin.dart';
import 'models/market_stats.dart';

class MarketRepository {
  final ApiClient apiClient;

  MarketRepository({required this.apiClient});

  Future<GlobalMarket> getGlobalMarket() async {
    try {
      final isCoinGecko = apiClient.isCoinGecko;
      final endpoint = isCoinGecko ? '/global' : '/api/market/global';
      final response = await apiClient.dio.get(endpoint);
      final dynamic raw = response.data;
      final data = (raw is Map<String, dynamic> && raw['data'] is Map<String, dynamic>)
          ? raw['data'] as Map<String, dynamic>
          : raw as Map<String, dynamic>;
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
      final isCoinGecko = apiClient.isCoinGecko;
      if (isCoinGecko) {
        final response = await apiClient.dio.get(
          '/coins/markets',
          queryParameters: {
            'vs_currency': 'usd',
            'order': 'market_cap_desc',
            'per_page': 50,
            'page': 1,
            'sparkline': false,
            'price_change_percentage': '24h',
          },
        );

        final dynamic raw = response.data;
        if (raw is Map<String, dynamic> && raw['data'] is Map<String, dynamic>) {
          return MarketMovers.fromJson(raw['data'] as Map<String, dynamic>);
        }

        final List<dynamic> list = (raw is List) ? raw : const [];
        final coins = list
            .map((item) => Coin.fromJson(item as Map<String, dynamic>))
            .toList();

        final sortedForGainers = [...coins]
          ..sort((a, b) => b.change24hPct.compareTo(a.change24hPct));
        final sortedForLosers = [...coins]
          ..sort((a, b) => a.change24hPct.compareTo(b.change24hPct));

        return MarketMovers(
          gainers: sortedForGainers.take(limit).toList(),
          losers: sortedForLosers.take(limit).toList(),
        );
      } else {
        final response = await apiClient.dio.get(
          '/api/market/movers',
          queryParameters: {'limit': limit},
        );
        final data = response.data['data'] as Map<String, dynamic>;
        return MarketMovers.fromJson(data);
      }
    } on DioException catch (e) {
      if (e.error is AppException) {
        throw e.error!;
      }
      throw AppException(e.message ?? 'Failed to load top market movers');
    }
  }

  Future<List<CategoryItem>> getCategories() async {
    try {
      final isCoinGecko = apiClient.isCoinGecko;
      if (isCoinGecko) {
        final response = await apiClient.dio.get('/coins/categories');
        final list = (response.data is List) ? (response.data as List<dynamic>) : [];
        if (list.isEmpty) throw Exception('Empty categories');
        return list.take(15).map((item) {
          final map = item as Map<String, dynamic>;
          return CategoryItem(
            name: map['name']?.toString() ?? 'Category',
            count: (map['top_3_coins'] as List?)?.length ?? 10,
          );
        }).toList();
      } else {
        final response = await apiClient.dio.get('/api/categories');
        final list = response.data['data'] as List<dynamic>;
        return list
            .map((item) => CategoryItem.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {
      // Clean fallback if categories fail or are rate limited
      return const [
        CategoryItem(name: 'Layer 1', count: 25),
        CategoryItem(name: 'Smart Contract Platform', count: 20),
        CategoryItem(name: 'Decentralized Finance (DeFi)', count: 35),
        CategoryItem(name: 'Layer 2', count: 18),
        CategoryItem(name: 'Meme Coins', count: 15),
      ];
    }
  }
}

