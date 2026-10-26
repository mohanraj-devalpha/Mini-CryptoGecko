import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/network/api_client.dart';
import '../../coins/data/models/coin.dart';
import 'models/watchlist_item.dart';

class WatchlistRepository {
  final ApiClient apiClient;
  static const _prefKey = 'coinscope_watchlist_ids';

  WatchlistRepository({required this.apiClient});

  Future<List<String>> _getLocalWatchlistIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_prefKey) ?? [];
  }

  Future<void> _saveLocalWatchlistIds(List<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefKey, ids);
  }

  Future<List<WatchlistItem>> getWatchlist() async {
    try {
      final isCoinGecko = apiClient.isCoinGecko;
      if (isCoinGecko) {
        final ids = await _getLocalWatchlistIds();
        if (ids.isEmpty) {
          return [];
        }

        final response = await apiClient.dio.get(
          '/coins/markets',
          queryParameters: {
            'vs_currency': 'usd',
            'ids': ids.join(','),
            'sparkline': false,
          },
        );

        final dynamic raw = response.data;
        final List<dynamic> list;
        if (raw is List) {
          list = raw;
        } else if (raw is Map<String, dynamic> && raw['data'] is List) {
          list = raw['data'] as List<dynamic>;
        } else {
          list = const [];
        }

        final coins = list
            .map((item) => Coin.fromJson(item as Map<String, dynamic>))
            .toList();

        return coins.asMap().entries.map((entry) {
          return WatchlistItem(
            id: entry.key + 1,
            deviceId: 'local',
            coinId: entry.value.id,
            createdAt: DateTime.now(),
            coin: entry.value,
          );
        }).toList();
      } else {
        final response = await apiClient.dio.get('/api/watchlist');
        final list = response.data['data'] as List<dynamic>;
        return list
            .map((item) => WatchlistItem.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } on DioException catch (e) {
      if (e.error is AppException) {
        throw e.error!;
      }
      throw AppException(e.message ?? 'Failed to load watchlist');
    }
  }

  Future<WatchlistItem> addToWatchlist(String coinId) async {
    try {
      final isCoinGecko = apiClient.isCoinGecko;
      if (isCoinGecko) {
        final ids = await _getLocalWatchlistIds();
        if (!ids.contains(coinId)) {
          ids.add(coinId);
          await _saveLocalWatchlistIds(ids);
        }

        final response = await apiClient.dio.get(
          '/coins/markets',
          queryParameters: {
            'vs_currency': 'usd',
            'ids': coinId,
            'sparkline': false,
          },
        );

        final dynamic raw = response.data;
        final List<dynamic> list =
            (raw is List) ? raw : (raw['data'] as List<dynamic>? ?? []);
        final coin = list.isNotEmpty
            ? Coin.fromJson(list.first as Map<String, dynamic>)
            : Coin(
                id: coinId,
                symbol: coinId.toUpperCase(),
                name: coinId,
                category: 'Crypto',
                rank: 0,
                price: 0,
                volume24h: 0,
                marketCap: 0,
                change24hPct: 0,
                high24h: 0,
                low24h: 0,
              );

        return WatchlistItem(
          id: ids.indexOf(coinId) + 1,
          deviceId: 'local',
          coinId: coinId,
          createdAt: DateTime.now(),
          coin: coin,
        );
      } else {
        final response = await apiClient.dio.post(
          '/api/watchlist',
          data: {'coin_id': coinId},
        );
        final data = response.data['data'] as Map<String, dynamic>;
        return WatchlistItem.fromJson(data);
      }
    } on DioException catch (e) {
      if (e.error is AppException) {
        throw e.error!;
      }
      throw AppException(e.message ?? 'Failed to add to watchlist');
    }
  }

  Future<void> removeFromWatchlist(String coinId) async {
    try {
      final isCoinGecko = apiClient.isCoinGecko;
      if (isCoinGecko) {
        final ids = await _getLocalWatchlistIds();
        ids.remove(coinId);
        await _saveLocalWatchlistIds(ids);
      } else {
        await apiClient.dio.delete('/api/watchlist/$coinId');
      }
    } on DioException catch (e) {
      if (e.error is AppException) {
        throw e.error!;
      }
      throw AppException(e.message ?? 'Failed to remove from watchlist');
    }
  }
}

