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

  factory Coin.fromJson(Map<String, dynamic> json) => _$CoinFromJson(json);
}
