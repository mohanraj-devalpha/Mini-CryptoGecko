import 'package:freezed_annotation/freezed_annotation.dart';

part 'coin.freezed.dart';
part 'coin.g.dart';

@freezed
class Coin with _$Coin {
  const factory Coin({
    required String id,
    required String symbol,
    required String name,
    @JsonKey(name: 'image_url') String? imageUrl,
    required String category,
    required int rank,
    required double price,
    @JsonKey(name: 'volume_24h') required double volume24h,
    @JsonKey(name: 'market_cap') required double marketCap,
    @JsonKey(name: 'change_24h_pct') required double change24hPct,
    @JsonKey(name: 'high_24h') required double high24h,
    @JsonKey(name: 'low_24h') required double low24h,
  }) = _Coin;

  factory Coin.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('current_price')) {
      return Coin.fromCoinGecko(json);
    }
    return _$CoinFromJson(json);
  }

  factory Coin.fromCoinGecko(Map<String, dynamic> json) {
    return Coin(
      id: json['id'] as String? ?? '',
      symbol: (json['symbol'] as String? ?? '').toUpperCase(),
      name: json['name'] as String? ?? '',
      imageUrl: json['image'] as String? ?? json['image_url'] as String?,
      category: json['category'] as String? ?? 'Crypto',
      rank: (json['market_cap_rank'] as num?)?.toInt() ?? (json['rank'] as num?)?.toInt() ?? 0,
      price: (json['current_price'] as num?)?.toDouble() ?? (json['price'] as num?)?.toDouble() ?? 0.0,
      volume24h: (json['total_volume'] as num?)?.toDouble() ?? (json['volume_24h'] as num?)?.toDouble() ?? 0.0,
      marketCap: (json['market_cap'] as num?)?.toDouble() ?? 0.0,
      change24hPct: (json['price_change_percentage_24h'] as num?)?.toDouble() ?? (json['change_24h_pct'] as num?)?.toDouble() ?? 0.0,
      high24h: (json['high_24h'] as num?)?.toDouble() ?? 0.0,
      low24h: (json['low_24h'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
