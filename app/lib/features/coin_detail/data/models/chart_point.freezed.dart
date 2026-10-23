// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chart_point.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChartPoint _$ChartPointFromJson(Map<String, dynamic> json) {
  return _ChartPoint.fromJson(json);
}

/// @nodoc
mixin _$ChartPoint {
  DateTime get t => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;

  /// Serializes this ChartPoint to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChartPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChartPointCopyWith<ChartPoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChartPointCopyWith<$Res> {
  factory $ChartPointCopyWith(
          ChartPoint value, $Res Function(ChartPoint) then) =
      _$ChartPointCopyWithImpl<$Res, ChartPoint>;
  @useResult
  $Res call({DateTime t, double price});
}

/// @nodoc
class _$ChartPointCopyWithImpl<$Res, $Val extends ChartPoint>
    implements $ChartPointCopyWith<$Res> {
  _$ChartPointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChartPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? t = null,
    Object? price = null,
  }) {
    return _then(_value.copyWith(
      t: null == t
          ? _value.t
          : t // ignore: cast_nullable_to_non_nullable
              as DateTime,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChartPointImplCopyWith<$Res>
    implements $ChartPointCopyWith<$Res> {
  factory _$$ChartPointImplCopyWith(
          _$ChartPointImpl value, $Res Function(_$ChartPointImpl) then) =
      __$$ChartPointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime t, double price});
}

/// @nodoc
class __$$ChartPointImplCopyWithImpl<$Res>
    extends _$ChartPointCopyWithImpl<$Res, _$ChartPointImpl>
    implements _$$ChartPointImplCopyWith<$Res> {
  __$$ChartPointImplCopyWithImpl(
      _$ChartPointImpl _value, $Res Function(_$ChartPointImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChartPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? t = null,
    Object? price = null,
  }) {
    return _then(_$ChartPointImpl(
      t: null == t
          ? _value.t
          : t // ignore: cast_nullable_to_non_nullable
              as DateTime,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChartPointImpl implements _ChartPoint {
  const _$ChartPointImpl({required this.t, required this.price});

  factory _$ChartPointImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChartPointImplFromJson(json);

  @override
  final DateTime t;
  @override
  final double price;

  @override
  String toString() {
    return 'ChartPoint(t: $t, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChartPointImpl &&
            (identical(other.t, t) || other.t == t) &&
            (identical(other.price, price) || other.price == price));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, t, price);

  /// Create a copy of ChartPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChartPointImplCopyWith<_$ChartPointImpl> get copyWith =>
      __$$ChartPointImplCopyWithImpl<_$ChartPointImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChartPointImplToJson(
      this,
    );
  }
}

abstract class _ChartPoint implements ChartPoint {
  const factory _ChartPoint(
      {required final DateTime t,
      required final double price}) = _$ChartPointImpl;

  factory _ChartPoint.fromJson(Map<String, dynamic> json) =
      _$ChartPointImpl.fromJson;

  @override
  DateTime get t;
  @override
  double get price;

  /// Create a copy of ChartPoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChartPointImplCopyWith<_$ChartPointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
