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

  factory GlobalMarket.fromJson(Map<String, dynamic> json) =>
      _$GlobalMarketFromJson(json);
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
