import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import 'models/watchlist_item.dart';

class WatchlistRepository {
  final ApiClient apiClient;

  WatchlistRepository({required this.apiClient});

  Future<List<WatchlistItem>> getWatchlist() async {
    try {
      final response = await apiClient.dio.get('/api/watchlist');
      final list = response.data['data'] as List<dynamic>;
      return list
          .map((item) => WatchlistItem.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (e.error is AppException) {
        throw e.error!;
      }
      throw AppException(e.message ?? 'Failed to load watchlist');
    }
  }

  Future<WatchlistItem> addToWatchlist(String coinId) async {
    try {
      final response = await apiClient.dio.post(
        '/api/watchlist',
        data: {'coin_id': coinId},
      );
      final data = response.data['data'] as Map<String, dynamic>;
      return WatchlistItem.fromJson(data);
    } on DioException catch (e) {
      if (e.error is AppException) {
        throw e.error!;
      }
      throw AppException(e.message ?? 'Failed to add to watchlist');
    }
  }

  Future<void> removeFromWatchlist(String coinId) async {
    try {
      await apiClient.dio.delete('/api/watchlist/$coinId');
    } on DioException catch (e) {
      if (e.error is AppException) {
        throw e.error!;
      }
      throw AppException(e.message ?? 'Failed to remove from watchlist');
    }
  }
}
