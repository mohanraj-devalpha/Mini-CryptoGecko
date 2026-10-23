// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coin.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Coin _$CoinFromJson(Map<String, dynamic> json) {
  return _Coin.fromJson(json);
}

/// @nodoc
mixin _$Coin {
  String get id => throw _privateConstructorUsedError;
  String get symbol => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String? get imageUrl => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  int get rank => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  @JsonKey(name: 'volume_24h')
  double get volume24h => throw _privateConstructorUsedError;
  @JsonKey(name: 'market_cap')
  double get marketCap => throw _privateConstructorUsedError;
  @JsonKey(name: 'change_24h_pct')
  double get change24hPct => throw _privateConstructorUsedError;
  @JsonKey(name: 'high_24h')
  double get high24h => throw _privateConstructorUsedError;
  @JsonKey(name: 'low_24h')
  double get low24h => throw _privateConstructorUsedError;

  /// Serializes this Coin to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Coin
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CoinCopyWith<Coin> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CoinCopyWith<$Res> {
  factory $CoinCopyWith(Coin value, $Res Function(Coin) then) =
      _$CoinCopyWithImpl<$Res, Coin>;
  @useResult
  $Res call(
      {String id,
      String symbol,
      String name,
      @JsonKey(name: 'image_url') String? imageUrl,
      String category,
      int rank,
      double price,
      @JsonKey(name: 'volume_24h') double volume24h,
      @JsonKey(name: 'market_cap') double marketCap,
      @JsonKey(name: 'change_24h_pct') double change24hPct,
      @JsonKey(name: 'high_24h') double high24h,
      @JsonKey(name: 'low_24h') double low24h});
}

/// @nodoc
class _$CoinCopyWithImpl<$Res, $Val extends Coin>
    implements $CoinCopyWith<$Res> {
  _$CoinCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Coin
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? symbol = null,
    Object? name = null,
    Object? imageUrl = freezed,
    Object? category = null,
    Object? rank = null,
    Object? price = null,
    Object? volume24h = null,
    Object? marketCap = null,
    Object? change24hPct = null,
    Object? high24h = null,
    Object? low24h = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      rank: null == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      volume24h: null == volume24h
          ? _value.volume24h
          : volume24h // ignore: cast_nullable_to_non_nullable
              as double,
      marketCap: null == marketCap
          ? _value.marketCap
          : marketCap // ignore: cast_nullable_to_non_nullable
              as double,
      change24hPct: null == change24hPct
          ? _value.change24hPct
          : change24hPct // ignore: cast_nullable_to_non_nullable
              as double,
      high24h: null == high24h
          ? _value.high24h
          : high24h // ignore: cast_nullable_to_non_nullable
              as double,
      low24h: null == low24h
          ? _value.low24h
          : low24h // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CoinImplCopyWith<$Res> implements $CoinCopyWith<$Res> {
  factory _$$CoinImplCopyWith(
          _$CoinImpl value, $Res Function(_$CoinImpl) then) =
      __$$CoinImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String symbol,
      String name,
      @JsonKey(name: 'image_url') String? imageUrl,
      String category,
      int rank,
      double price,
      @JsonKey(name: 'volume_24h') double volume24h,
      @JsonKey(name: 'market_cap') double marketCap,
      @JsonKey(name: 'change_24h_pct') double change24hPct,
      @JsonKey(name: 'high_24h') double high24h,
      @JsonKey(name: 'low_24h') double low24h});
}

/// @nodoc
class __$$CoinImplCopyWithImpl<$Res>
    extends _$CoinCopyWithImpl<$Res, _$CoinImpl>
    implements _$$CoinImplCopyWith<$Res> {
  __$$CoinImplCopyWithImpl(_$CoinImpl _value, $Res Function(_$CoinImpl) _then)
      : super(_value, _then);

  /// Create a copy of Coin
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? symbol = null,
    Object? name = null,
    Object? imageUrl = freezed,
    Object? category = null,
    Object? rank = null,
    Object? price = null,
    Object? volume24h = null,
    Object? marketCap = null,
    Object? change24hPct = null,
    Object? high24h = null,
    Object? low24h = null,
  }) {
    return _then(_$CoinImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      rank: null == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      volume24h: null == volume24h
          ? _value.volume24h
          : volume24h // ignore: cast_nullable_to_non_nullable
              as double,
      marketCap: null == marketCap
          ? _value.marketCap
          : marketCap // ignore: cast_nullable_to_non_nullable
              as double,
      change24hPct: null == change24hPct
          ? _value.change24hPct
          : change24hPct // ignore: cast_nullable_to_non_nullable
              as double,
      high24h: null == high24h
          ? _value.high24h
          : high24h // ignore: cast_nullable_to_non_nullable
              as double,
      low24h: null == low24h
          ? _value.low24h
          : low24h // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CoinImpl implements _Coin {
  const _$CoinImpl(
      {required this.id,
      required this.symbol,
      required this.name,
      @JsonKey(name: 'image_url') this.imageUrl,
      required this.category,
      required this.rank,
      required this.price,
      @JsonKey(name: 'volume_24h') required this.volume24h,
      @JsonKey(name: 'market_cap') required this.marketCap,
      @JsonKey(name: 'change_24h_pct') required this.change24hPct,
      @JsonKey(name: 'high_24h') required this.high24h,
      @JsonKey(name: 'low_24h') required this.low24h});

  factory _$CoinImpl.fromJson(Map<String, dynamic> json) =>
      _$$CoinImplFromJson(json);

  @override
  final String id;
  @override
  final String symbol;
  @override
  final String name;
  @override
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @override
  final String category;
  @override
  final int rank;
  @override
  final double price;
  @override
  @JsonKey(name: 'volume_24h')
  final double volume24h;
  @override
  @JsonKey(name: 'market_cap')
  final double marketCap;
  @override
  @JsonKey(name: 'change_24h_pct')
  final double change24hPct;
  @override
  @JsonKey(name: 'high_24h')
  final double high24h;
  @override
  @JsonKey(name: 'low_24h')
  final double low24h;

  @override
  String toString() {
    return 'Coin(id: $id, symbol: $symbol, name: $name, imageUrl: $imageUrl, category: $category, rank: $rank, price: $price, volume24h: $volume24h, marketCap: $marketCap, change24hPct: $change24hPct, high24h: $high24h, low24h: $low24h)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CoinImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.rank, rank) || other.rank == rank) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.volume24h, volume24h) ||
                other.volume24h == volume24h) &&
            (identical(other.marketCap, marketCap) ||
                other.marketCap == marketCap) &&
            (identical(other.change24hPct, change24hPct) ||
                other.change24hPct == change24hPct) &&
            (identical(other.high24h, high24h) || other.high24h == high24h) &&
            (identical(other.low24h, low24h) || other.low24h == low24h));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      symbol,
      name,
      imageUrl,
      category,
      rank,
      price,
      volume24h,
      marketCap,
      change24hPct,
      high24h,
      low24h);

  /// Create a copy of Coin
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CoinImplCopyWith<_$CoinImpl> get copyWith =>
      __$$CoinImplCopyWithImpl<_$CoinImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CoinImplToJson(
      this,
    );
  }
}

abstract class _Coin implements Coin {
  const factory _Coin(
      {required final String id,
      required final String symbol,
      required final String name,
      @JsonKey(name: 'image_url') final String? imageUrl,
      required final String category,
      required final int rank,
      required final double price,
      @JsonKey(name: 'volume_24h') required final double volume24h,
      @JsonKey(name: 'market_cap') required final double marketCap,
      @JsonKey(name: 'change_24h_pct') required final double change24hPct,
      @JsonKey(name: 'high_24h') required final double high24h,
      @JsonKey(name: 'low_24h') required final double low24h}) = _$CoinImpl;

  factory _Coin.fromJson(Map<String, dynamic> json) = _$CoinImpl.fromJson;

  @override
  String get id;
  @override
  String get symbol;
  @override
  String get name;
  @override
  @JsonKey(name: 'image_url')
  String? get imageUrl;
  @override
  String get category;
  @override
  int get rank;
  @override
  double get price;
  @override
  @JsonKey(name: 'volume_24h')
  double get volume24h;
  @override
  @JsonKey(name: 'market_cap')
  double get marketCap;
  @override
  @JsonKey(name: 'change_24h_pct')
  double get change24hPct;
  @override
  @JsonKey(name: 'high_24h')
  double get high24h;
  @override
  @JsonKey(name: 'low_24h')
  double get low24h;

  /// Create a copy of Coin
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CoinImplCopyWith<_$CoinImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
