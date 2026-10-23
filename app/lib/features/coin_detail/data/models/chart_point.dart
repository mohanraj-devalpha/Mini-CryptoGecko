import 'package:freezed_annotation/freezed_annotation.dart';

part 'chart_point.freezed.dart';
part 'chart_point.g.dart';

@freezed
class ChartPoint with _$ChartPoint {
  const factory ChartPoint({
    required DateTime t,
    required double price,
  }) = _ChartPoint;

  factory ChartPoint.fromJson(Map<String, dynamic> json) =>
      _$ChartPointFromJson(json);
}
