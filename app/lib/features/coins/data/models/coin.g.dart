// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CoinImpl _$$CoinImplFromJson(Map<String, dynamic> json) => _$CoinImpl(
      id: json['id'] as String,
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      imageUrl: json['image_url'] as String?,
      category: json['category'] as String,
      rank: (json['rank'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
      volume24h: (json['volume_24h'] as num).toDouble(),
      marketCap: (json['market_cap'] as num).toDouble(),
      change24hPct: (json['change_24h_pct'] as num).toDouble(),
      high24h: (json['high_24h'] as num).toDouble(),
      low24h: (json['low_24h'] as num).toDouble(),
    );

Map<String, dynamic> _$$CoinImplToJson(_$CoinImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'symbol': instance.symbol,
      'name': instance.name,
      'image_url': instance.imageUrl,
      'category': instance.category,
      'rank': instance.rank,
      'price': instance.price,
      'volume_24h': instance.volume24h,
      'market_cap': instance.marketCap,
      'change_24h_pct': instance.change24hPct,
      'high_24h': instance.high24h,
      'low_24h': instance.low24h,
    };
