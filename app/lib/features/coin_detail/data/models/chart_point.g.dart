// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_point.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChartPointImpl _$$ChartPointImplFromJson(Map<String, dynamic> json) =>
    _$ChartPointImpl(
      t: DateTime.parse(json['t'] as String),
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$$ChartPointImplToJson(_$ChartPointImpl instance) =>
    <String, dynamic>{
      't': instance.t.toIso8601String(),
      'price': instance.price,
    };
