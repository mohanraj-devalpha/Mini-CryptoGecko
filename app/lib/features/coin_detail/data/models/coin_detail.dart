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

  factory CoinDetail.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('market_data')) {
      return CoinDetail.fromCoinGecko(json);
    }
    return _$CoinDetailFromJson(json);
  }

  factory CoinDetail.fromCoinGecko(Map<String, dynamic> json) {
    final market = json['market_data'] as Map<String, dynamic>? ?? {};
    final currentPriceMap = market['current_price'] as Map<String, dynamic>? ?? {};
    final totalVolumeMap = market['total_volume'] as Map<String, dynamic>? ?? {};
    final marketCapMap = market['market_cap'] as Map<String, dynamic>? ?? {};
    final high24hMap = market['high_24h'] as Map<String, dynamic>? ?? {};
    final low24hMap = market['low_24h'] as Map<String, dynamic>? ?? {};
    final athMap = market['ath'] as Map<String, dynamic>? ?? {};
    final athDateMap = market['ath_date'] as Map<String, dynamic>? ?? {};

    final desc = json['description'];
    final descriptionString = desc is Map ? (desc['en']?.toString() ?? '') : (desc?.toString() ?? '');

    final categories = json['categories'] as List<dynamic>? ?? [];
    final categoryString = categories.isNotEmpty ? categories.first.toString() : 'Crypto';

    final imageObj = json['image'];
    final imageUrlString = imageObj is Map 
        ? (imageObj['large'] ?? imageObj['small'] ?? imageObj['thumb'])?.toString()
        : json['image_url']?.toString();

    DateTime parsedAthDate = DateTime.now();
    if (athDateMap['usd'] != null) {
      parsedAthDate = DateTime.tryParse(athDateMap['usd'].toString()) ?? DateTime.now();
    }

    final coinMarketData = CoinMarketData(
      price: (currentPriceMap['usd'] as num?)?.toDouble() ?? 0.0,
      volume24h: (totalVolumeMap['usd'] as num?)?.toDouble() ?? 0.0,
      marketCap: (marketCapMap['usd'] as num?)?.toDouble() ?? 0.0,
      change24hPct: (market['price_change_percentage_24h'] as num?)?.toDouble() ?? 0.0,
      high24h: (high24hMap['usd'] as num?)?.toDouble() ?? 0.0,
      low24h: (low24hMap['usd'] as num?)?.toDouble() ?? 0.0,
      ath: (athMap['usd'] as num?)?.toDouble() ?? 0.0,
      athDate: parsedAthDate,
      updatedAt: DateTime.now(),
    );

    return CoinDetail(
      id: json['id'] as String? ?? '',
      symbol: (json['symbol'] as String? ?? '').toUpperCase(),
      name: json['name'] as String? ?? '',
      imageUrl: imageUrlString,
      description: descriptionString,
      category: categoryString,
      circulatingSupply: (market['circulating_supply'] as num?)?.toDouble() ?? 0.0,
      totalSupply: (market['total_supply'] as num?)?.toDouble() ?? 0.0,
      maxSupply: (market['max_supply'] as num?)?.toDouble(),
      rank: (json['market_cap_rank'] as num?)?.toInt() ?? 0,
      market: coinMarketData,
    );
  }
}
