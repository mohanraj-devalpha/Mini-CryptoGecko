import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/network_providers.dart';
import '../../coins/data/models/coin.dart';
import '../data/models/watchlist_item.dart';
import '../data/watchlist_repository.dart';

final watchlistRepositoryProvider = Provider<WatchlistRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return WatchlistRepository(apiClient: apiClient);
});

final watchlistProvider =
    AsyncNotifierProvider<WatchlistNotifier, List<WatchlistItem>>(() {
  return WatchlistNotifier();
});

class WatchlistNotifier extends AsyncNotifier<List<WatchlistItem>> {
  @override
  Future<List<WatchlistItem>> build() async {
    final repo = ref.watch(watchlistRepositoryProvider);
    final items = await repo.getWatchlist();

    // Subscribe to websocket for all coins in watchlist
    ref.read(wsClientProvider).subscribe(items.map((i) => i.coinId).toList());
    return items;
  }

  bool isWatchlisted(String coinId) {
    final current = state.valueOrNull;
    if (current == null) return false;
    return current.any((item) => item.coinId == coinId);
  }

  Future<bool> toggleWatchlist(String coinId, Coin? fallbackCoin) async {
    final previousList = state.valueOrNull ?? [];
    final currentlyIn = previousList.any((item) => item.coinId == coinId);
    final repo = ref.read(watchlistRepositoryProvider);

    if (currentlyIn) {
      // Optimistic removal
      state = AsyncData(previousList.where((item) => item.coinId != coinId).toList());

      try {
        await repo.removeFromWatchlist(coinId);
        return false;
      } catch (e) {
        // Rollback
        state = AsyncData(previousList);
        rethrow;
      }
    } else {
      // Optimistic addition
      final placeholderCoin = fallbackCoin ??
          Coin(
            id: coinId,
            symbol: coinId.toUpperCase(),
            name: coinId,
            category: 'General',
            rank: 99,
            price: 0,
            volume24h: 0,
            marketCap: 0,
            change24hPct: 0,
            high24h: 0,
            low24h: 0,
          );

      final optimisticItem = WatchlistItem(
        id: DateTime.now().millisecondsSinceEpoch,
        deviceId: '',
        coinId: coinId,
        createdAt: DateTime.now(),
        coin: placeholderCoin,
      );

      state = AsyncData([optimisticItem, ...previousList]);

      try {
        final realItem = await repo.addToWatchlist(coinId);
        // Replace optimistic placeholder with confirmed server item
        final updated = [
          realItem,
          ...previousList.where((item) => item.coinId != coinId),
        ];
        state = AsyncData(updated);
        return true;
      } catch (e) {
        // Rollback
        state = AsyncData(previousList);
        rethrow;
      }
    }
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

final isCoinWatchlistedProvider = Provider.family<bool, String>((ref, coinId) {
  final watchlistAsync = ref.watch(watchlistProvider);
  return watchlistAsync.maybeWhen(
    data: (items) => items.any((i) => i.coinId == coinId),
    orElse: () => false,
  );
});
