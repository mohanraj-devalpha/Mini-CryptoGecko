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
      final isCoinGecko = apiClient.isCoinGecko;

      if (isCoinGecko) {
        String orderParam = 'market_cap_desc';
        if (sort == 'price') {
          orderParam = order == 'asc' ? 'price_asc' : 'price_desc';
        } else if (sort == 'volume_24h') {
          orderParam = order == 'asc' ? 'volume_asc' : 'volume_desc';
        } else {
          orderParam = order == 'asc' ? 'market_cap_asc' : 'market_cap_desc';
        }

        final queryParams = <String, dynamic>{
          'vs_currency': 'usd',
          'order': orderParam,
          'per_page': perPage,
          'page': page,
          'sparkline': false,
          'price_change_percentage': '24h',
        };

        if (category != null && category.isNotEmpty && category != 'All') {
          queryParams['category'] = category.toLowerCase().replaceAll(' ', '-');
        }

        int searchTotal = 1000;
        if (query != null && query.trim().isNotEmpty) {
          final searchRes = await apiClient.dio.get(
            '/search',
            queryParameters: {'query': query.trim()},
          );
          final coinsList = (searchRes.data is Map && searchRes.data['coins'] is List)
              ? (searchRes.data['coins'] as List<dynamic>)
              : <dynamic>[];

          searchTotal = coinsList.length;

          if (coinsList.isEmpty) {
            return CoinsResponse(
              coins: const [],
              page: page,
              perPage: perPage,
              total: 0,
              pages: 0,
            );
          }

          final startIndex = (page - 1) * perPage;
          if (startIndex >= coinsList.length) {
            return CoinsResponse(
              coins: const [],
              page: page,
              perPage: perPage,
              total: coinsList.length,
              pages: (coinsList.length / perPage).ceil(),
            );
          }

          final pagedList = coinsList.skip(startIndex).take(perPage).toList();
          final coinIds = pagedList.map((c) => c['id'].toString()).join(',');
          queryParams['ids'] = coinIds;
        }

        final response = await apiClient.dio.get(
          '/coins/markets',
          queryParameters: queryParams,
        );

        final dynamic raw = response.data;
        final List<dynamic> dataList =
            (raw is List) ? raw : (raw['data'] as List<dynamic>? ?? []);
        final coins = dataList
            .map((item) => Coin.fromJson(item as Map<String, dynamic>))
            .toList();

        final totalCount = (query != null && query.trim().isNotEmpty) ? searchTotal : 1000;
        return CoinsResponse(
          coins: coins,
          page: page,
          perPage: perPage,
          total: totalCount,
          pages: (totalCount / perPage).ceil(),
        );
      } else {
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
      }
    } on DioException catch (e) {
      if (e.error is AppException) {
        throw e.error!;
      }
      throw AppException(e.message ?? 'Failed to load coins');
    }
  }
}
