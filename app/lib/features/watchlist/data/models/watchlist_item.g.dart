// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watchlist_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WatchlistItemImpl _$$WatchlistItemImplFromJson(Map<String, dynamic> json) =>
    _$WatchlistItemImpl(
      id: (json['id'] as num).toInt(),
      deviceId: json['device_id'] as String,
      coinId: json['coin_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      coin: Coin.fromJson(json['coin'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$WatchlistItemImplToJson(_$WatchlistItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'device_id': instance.deviceId,
      'coin_id': instance.coinId,
      'created_at': instance.createdAt.toIso8601String(),
      'coin': instance.coin,
    };
