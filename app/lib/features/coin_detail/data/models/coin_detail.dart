import 'package:freezed_annotation/freezed_annotation.dart';

part 'coin_detail.freezed.dart';
part 'coin_detail.g.dart';

@freezed
class CoinMarketData with _$CoinMarketData {
  const factory CoinMarketData({
    required double price,
    @JsonKey(name: 'volume_24h') required double volume24h,
    @JsonKey(name: 'market_cap') required double marketCap,
    @JsonKey(name: 'change_24h_pct') required double change24hPct,
    @JsonKey(name: 'high_24h') required double high24h,
    @JsonKey(name: 'low_24h') required double low24h,
    required double ath,
    @JsonKey(name: 'ath_date') required DateTime athDate,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _CoinMarketData;

  factory CoinMarketData.fromJson(Map<String, dynamic> json) =>
      _$CoinMarketDataFromJson(json);
}

@freezed
class CoinDetail with _$CoinDetail {
  const factory CoinDetail({
    required String id,
    required String symbol,
    required String name,
    @JsonKey(name: 'image_url') String? imageUrl,
    required String description,
    required String category,
    @JsonKey(name: 'circulating_supply') required double circulatingSupply,
    @JsonKey(name: 'total_supply') required double totalSupply,
    @JsonKey(name: 'max_supply') double? maxSupply,
    required int rank,
    required CoinMarketData market,
  }) = _CoinDetail;

  factory CoinDetail.fromJson(Map<String, dynamic> json) =>
      _$CoinDetailFromJson(json);
}
