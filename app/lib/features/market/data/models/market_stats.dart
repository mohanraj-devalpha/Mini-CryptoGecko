import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../coins/data/models/coin.dart';

part 'market_stats.freezed.dart';
part 'market_stats.g.dart';

@freezed
class GlobalMarket with _$GlobalMarket {
  const factory GlobalMarket({
    @JsonKey(name: 'total_market_cap') required double totalMarketCap,
    @JsonKey(name: 'total_volume_24h') required double totalVolume24h,
    @JsonKey(name: 'btc_dominance') required double btcDominance,
    @JsonKey(name: 'eth_dominance') required double ethDominance,
    @JsonKey(name: 'market_cap_change_24h_pct')
    required double marketCapChange24hPct,
    @JsonKey(name: 'coin_count') required int coinCount,
  }) = _GlobalMarket;

  factory GlobalMarket.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('active_cryptocurrencies') || json.containsKey('market_cap_percentage')) {
      return GlobalMarket.fromCoinGecko(json);
    }
    return _$GlobalMarketFromJson(json);
  }

  factory GlobalMarket.fromCoinGecko(Map<String, dynamic> json) {
    final totalMarketCapMap = json['total_market_cap'] as Map<String, dynamic>? ?? {};
    final totalVolumeMap = json['total_volume'] as Map<String, dynamic>? ?? {};
    final marketCapPctMap = json['market_cap_percentage'] as Map<String, dynamic>? ?? {};

    return GlobalMarket(
      totalMarketCap: (totalMarketCapMap['usd'] as num?)?.toDouble() ?? 0.0,
      totalVolume24h: (totalVolumeMap['usd'] as num?)?.toDouble() ?? 0.0,
      btcDominance: (marketCapPctMap['btc'] as num?)?.toDouble() ?? 0.0,
      ethDominance: (marketCapPctMap['eth'] as num?)?.toDouble() ?? 0.0,
      marketCapChange24hPct: (json['market_cap_change_percentage_24h_usd'] as num?)?.toDouble() ?? 0.0,
      coinCount: (json['active_cryptocurrencies'] as num?)?.toInt() ?? 1000,
    );
  }
}

@freezed
class MarketMovers with _$MarketMovers {
  const factory MarketMovers({
    required List<Coin> gainers,
    required List<Coin> losers,
  }) = _MarketMovers;

  factory MarketMovers.fromJson(Map<String, dynamic> json) =>
      _$MarketMoversFromJson(json);
}

@freezed
class CategoryItem with _$CategoryItem {
  const factory CategoryItem({
    required String name,
    required int count,
  }) = _CategoryItem;

  factory CategoryItem.fromJson(Map<String, dynamic> json) =>
      _$CategoryItemFromJson(json);
}
