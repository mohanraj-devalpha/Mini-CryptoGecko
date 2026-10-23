// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'market_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GlobalMarketImpl _$$GlobalMarketImplFromJson(Map<String, dynamic> json) =>
    _$GlobalMarketImpl(
      totalMarketCap: (json['total_market_cap'] as num).toDouble(),
      totalVolume24h: (json['total_volume_24h'] as num).toDouble(),
      btcDominance: (json['btc_dominance'] as num).toDouble(),
      ethDominance: (json['eth_dominance'] as num).toDouble(),
      marketCapChange24hPct:
          (json['market_cap_change_24h_pct'] as num).toDouble(),
      coinCount: (json['coin_count'] as num).toInt(),
    );

Map<String, dynamic> _$$GlobalMarketImplToJson(_$GlobalMarketImpl instance) =>
    <String, dynamic>{
      'total_market_cap': instance.totalMarketCap,
      'total_volume_24h': instance.totalVolume24h,
      'btc_dominance': instance.btcDominance,
      'eth_dominance': instance.ethDominance,
      'market_cap_change_24h_pct': instance.marketCapChange24hPct,
      'coin_count': instance.coinCount,
    };

_$MarketMoversImpl _$$MarketMoversImplFromJson(Map<String, dynamic> json) =>
    _$MarketMoversImpl(
      gainers: (json['gainers'] as List<dynamic>)
          .map((e) => Coin.fromJson(e as Map<String, dynamic>))
          .toList(),
      losers: (json['losers'] as List<dynamic>)
          .map((e) => Coin.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$MarketMoversImplToJson(_$MarketMoversImpl instance) =>
    <String, dynamic>{
      'gainers': instance.gainers,
      'losers': instance.losers,
    };

_$CategoryItemImpl _$$CategoryItemImplFromJson(Map<String, dynamic> json) =>
    _$CategoryItemImpl(
      name: json['name'] as String,
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$$CategoryItemImplToJson(_$CategoryItemImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'count': instance.count,
    };
