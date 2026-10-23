// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coin_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CoinMarketDataImpl _$$CoinMarketDataImplFromJson(Map<String, dynamic> json) =>
    _$CoinMarketDataImpl(
      price: (json['price'] as num).toDouble(),
      volume24h: (json['volume_24h'] as num).toDouble(),
      marketCap: (json['market_cap'] as num).toDouble(),
      change24hPct: (json['change_24h_pct'] as num).toDouble(),
      high24h: (json['high_24h'] as num).toDouble(),
      low24h: (json['low_24h'] as num).toDouble(),
      ath: (json['ath'] as num).toDouble(),
      athDate: DateTime.parse(json['ath_date'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$CoinMarketDataImplToJson(
        _$CoinMarketDataImpl instance) =>
    <String, dynamic>{
      'price': instance.price,
      'volume_24h': instance.volume24h,
      'market_cap': instance.marketCap,
      'change_24h_pct': instance.change24hPct,
      'high_24h': instance.high24h,
      'low_24h': instance.low24h,
      'ath': instance.ath,
      'ath_date': instance.athDate.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_$CoinDetailImpl _$$CoinDetailImplFromJson(Map<String, dynamic> json) =>
    _$CoinDetailImpl(
      id: json['id'] as String,
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      imageUrl: json['image_url'] as String?,
      description: json['description'] as String,
      category: json['category'] as String,
      circulatingSupply: (json['circulating_supply'] as num).toDouble(),
      totalSupply: (json['total_supply'] as num).toDouble(),
      maxSupply: (json['max_supply'] as num?)?.toDouble(),
      rank: (json['rank'] as num).toInt(),
      market: CoinMarketData.fromJson(json['market'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$CoinDetailImplToJson(_$CoinDetailImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'symbol': instance.symbol,
      'name': instance.name,
      'image_url': instance.imageUrl,
      'description': instance.description,
      'category': instance.category,
      'circulating_supply': instance.circulatingSupply,
      'total_supply': instance.totalSupply,
      'max_supply': instance.maxSupply,
      'rank': instance.rank,
      'market': instance.market,
    };
