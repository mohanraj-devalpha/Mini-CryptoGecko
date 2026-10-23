// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'market_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GlobalMarket _$GlobalMarketFromJson(Map<String, dynamic> json) {
  return _GlobalMarket.fromJson(json);
}

/// @nodoc
mixin _$GlobalMarket {
  @JsonKey(name: 'total_market_cap')
  double get totalMarketCap => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_volume_24h')
  double get totalVolume24h => throw _privateConstructorUsedError;
  @JsonKey(name: 'btc_dominance')
  double get btcDominance => throw _privateConstructorUsedError;
  @JsonKey(name: 'eth_dominance')
  double get ethDominance => throw _privateConstructorUsedError;
  @JsonKey(name: 'market_cap_change_24h_pct')
  double get marketCapChange24hPct => throw _privateConstructorUsedError;
  @JsonKey(name: 'coin_count')
  int get coinCount => throw _privateConstructorUsedError;

  /// Serializes this GlobalMarket to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GlobalMarket
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GlobalMarketCopyWith<GlobalMarket> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GlobalMarketCopyWith<$Res> {
  factory $GlobalMarketCopyWith(
          GlobalMarket value, $Res Function(GlobalMarket) then) =
      _$GlobalMarketCopyWithImpl<$Res, GlobalMarket>;
  @useResult
  $Res call(
      {@JsonKey(name: 'total_market_cap') double totalMarketCap,
      @JsonKey(name: 'total_volume_24h') double totalVolume24h,
      @JsonKey(name: 'btc_dominance') double btcDominance,
      @JsonKey(name: 'eth_dominance') double ethDominance,
      @JsonKey(name: 'market_cap_change_24h_pct') double marketCapChange24hPct,
      @JsonKey(name: 'coin_count') int coinCount});
}

/// @nodoc
class _$GlobalMarketCopyWithImpl<$Res, $Val extends GlobalMarket>
    implements $GlobalMarketCopyWith<$Res> {
  _$GlobalMarketCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GlobalMarket
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalMarketCap = null,
    Object? totalVolume24h = null,
    Object? btcDominance = null,
    Object? ethDominance = null,
    Object? marketCapChange24hPct = null,
    Object? coinCount = null,
  }) {
    return _then(_value.copyWith(
      totalMarketCap: null == totalMarketCap
          ? _value.totalMarketCap
          : totalMarketCap // ignore: cast_nullable_to_non_nullable
              as double,
      totalVolume24h: null == totalVolume24h
          ? _value.totalVolume24h
          : totalVolume24h // ignore: cast_nullable_to_non_nullable
              as double,
      btcDominance: null == btcDominance
          ? _value.btcDominance
          : btcDominance // ignore: cast_nullable_to_non_nullable
              as double,
      ethDominance: null == ethDominance
          ? _value.ethDominance
          : ethDominance // ignore: cast_nullable_to_non_nullable
              as double,
      marketCapChange24hPct: null == marketCapChange24hPct
          ? _value.marketCapChange24hPct
          : marketCapChange24hPct // ignore: cast_nullable_to_non_nullable
              as double,
      coinCount: null == coinCount
          ? _value.coinCount
          : coinCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GlobalMarketImplCopyWith<$Res>
    implements $GlobalMarketCopyWith<$Res> {
  factory _$$GlobalMarketImplCopyWith(
          _$GlobalMarketImpl value, $Res Function(_$GlobalMarketImpl) then) =
      __$$GlobalMarketImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'total_market_cap') double totalMarketCap,
      @JsonKey(name: 'total_volume_24h') double totalVolume24h,
      @JsonKey(name: 'btc_dominance') double btcDominance,
      @JsonKey(name: 'eth_dominance') double ethDominance,
      @JsonKey(name: 'market_cap_change_24h_pct') double marketCapChange24hPct,
      @JsonKey(name: 'coin_count') int coinCount});
}

/// @nodoc
class __$$GlobalMarketImplCopyWithImpl<$Res>
    extends _$GlobalMarketCopyWithImpl<$Res, _$GlobalMarketImpl>
    implements _$$GlobalMarketImplCopyWith<$Res> {
  __$$GlobalMarketImplCopyWithImpl(
      _$GlobalMarketImpl _value, $Res Function(_$GlobalMarketImpl) _then)
      : super(_value, _then);

  /// Create a copy of GlobalMarket
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalMarketCap = null,
    Object? totalVolume24h = null,
    Object? btcDominance = null,
    Object? ethDominance = null,
    Object? marketCapChange24hPct = null,
    Object? coinCount = null,
  }) {
    return _then(_$GlobalMarketImpl(
      totalMarketCap: null == totalMarketCap
          ? _value.totalMarketCap
          : totalMarketCap // ignore: cast_nullable_to_non_nullable
              as double,
      totalVolume24h: null == totalVolume24h
          ? _value.totalVolume24h
          : totalVolume24h // ignore: cast_nullable_to_non_nullable
              as double,
      btcDominance: null == btcDominance
          ? _value.btcDominance
          : btcDominance // ignore: cast_nullable_to_non_nullable
              as double,
      ethDominance: null == ethDominance
          ? _value.ethDominance
          : ethDominance // ignore: cast_nullable_to_non_nullable
              as double,
      marketCapChange24hPct: null == marketCapChange24hPct
          ? _value.marketCapChange24hPct
          : marketCapChange24hPct // ignore: cast_nullable_to_non_nullable
              as double,
      coinCount: null == coinCount
          ? _value.coinCount
          : coinCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GlobalMarketImpl implements _GlobalMarket {
  const _$GlobalMarketImpl(
      {@JsonKey(name: 'total_market_cap') required this.totalMarketCap,
      @JsonKey(name: 'total_volume_24h') required this.totalVolume24h,
      @JsonKey(name: 'btc_dominance') required this.btcDominance,
      @JsonKey(name: 'eth_dominance') required this.ethDominance,
      @JsonKey(name: 'market_cap_change_24h_pct')
      required this.marketCapChange24hPct,
      @JsonKey(name: 'coin_count') required this.coinCount});

  factory _$GlobalMarketImpl.fromJson(Map<String, dynamic> json) =>
      _$$GlobalMarketImplFromJson(json);

  @override
  @JsonKey(name: 'total_market_cap')
  final double totalMarketCap;
  @override
  @JsonKey(name: 'total_volume_24h')
  final double totalVolume24h;
  @override
  @JsonKey(name: 'btc_dominance')
  final double btcDominance;
  @override
  @JsonKey(name: 'eth_dominance')
  final double ethDominance;
  @override
  @JsonKey(name: 'market_cap_change_24h_pct')
  final double marketCapChange24hPct;
  @override
  @JsonKey(name: 'coin_count')
  final int coinCount;

  @override
  String toString() {
    return 'GlobalMarket(totalMarketCap: $totalMarketCap, totalVolume24h: $totalVolume24h, btcDominance: $btcDominance, ethDominance: $ethDominance, marketCapChange24hPct: $marketCapChange24hPct, coinCount: $coinCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GlobalMarketImpl &&
            (identical(other.totalMarketCap, totalMarketCap) ||
                other.totalMarketCap == totalMarketCap) &&
            (identical(other.totalVolume24h, totalVolume24h) ||
                other.totalVolume24h == totalVolume24h) &&
            (identical(other.btcDominance, btcDominance) ||
                other.btcDominance == btcDominance) &&
            (identical(other.ethDominance, ethDominance) ||
                other.ethDominance == ethDominance) &&
            (identical(other.marketCapChange24hPct, marketCapChange24hPct) ||
                other.marketCapChange24hPct == marketCapChange24hPct) &&
            (identical(other.coinCount, coinCount) ||
                other.coinCount == coinCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, totalMarketCap, totalVolume24h,
      btcDominance, ethDominance, marketCapChange24hPct, coinCount);

  /// Create a copy of GlobalMarket
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GlobalMarketImplCopyWith<_$GlobalMarketImpl> get copyWith =>
      __$$GlobalMarketImplCopyWithImpl<_$GlobalMarketImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GlobalMarketImplToJson(
      this,
    );
  }
}

abstract class _GlobalMarket implements GlobalMarket {
  const factory _GlobalMarket(
      {@JsonKey(name: 'total_market_cap') required final double totalMarketCap,
      @JsonKey(name: 'total_volume_24h') required final double totalVolume24h,
      @JsonKey(name: 'btc_dominance') required final double btcDominance,
      @JsonKey(name: 'eth_dominance') required final double ethDominance,
      @JsonKey(name: 'market_cap_change_24h_pct')
      required final double marketCapChange24hPct,
      @JsonKey(name: 'coin_count')
      required final int coinCount}) = _$GlobalMarketImpl;

  factory _GlobalMarket.fromJson(Map<String, dynamic> json) =
      _$GlobalMarketImpl.fromJson;

  @override
  @JsonKey(name: 'total_market_cap')
  double get totalMarketCap;
  @override
  @JsonKey(name: 'total_volume_24h')
  double get totalVolume24h;
  @override
  @JsonKey(name: 'btc_dominance')
  double get btcDominance;
  @override
  @JsonKey(name: 'eth_dominance')
  double get ethDominance;
  @override
  @JsonKey(name: 'market_cap_change_24h_pct')
  double get marketCapChange24hPct;
  @override
  @JsonKey(name: 'coin_count')
  int get coinCount;

  /// Create a copy of GlobalMarket
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GlobalMarketImplCopyWith<_$GlobalMarketImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MarketMovers _$MarketMoversFromJson(Map<String, dynamic> json) {
  return _MarketMovers.fromJson(json);
}

/// @nodoc
mixin _$MarketMovers {
  List<Coin> get gainers => throw _privateConstructorUsedError;
  List<Coin> get losers => throw _privateConstructorUsedError;

  /// Serializes this MarketMovers to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MarketMovers
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MarketMoversCopyWith<MarketMovers> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MarketMoversCopyWith<$Res> {
  factory $MarketMoversCopyWith(
          MarketMovers value, $Res Function(MarketMovers) then) =
      _$MarketMoversCopyWithImpl<$Res, MarketMovers>;
  @useResult
  $Res call({List<Coin> gainers, List<Coin> losers});
}

/// @nodoc
class _$MarketMoversCopyWithImpl<$Res, $Val extends MarketMovers>
    implements $MarketMoversCopyWith<$Res> {
  _$MarketMoversCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MarketMovers
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gainers = null,
    Object? losers = null,
  }) {
    return _then(_value.copyWith(
      gainers: null == gainers
          ? _value.gainers
          : gainers // ignore: cast_nullable_to_non_nullable
              as List<Coin>,
      losers: null == losers
          ? _value.losers
          : losers // ignore: cast_nullable_to_non_nullable
              as List<Coin>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MarketMoversImplCopyWith<$Res>
    implements $MarketMoversCopyWith<$Res> {
  factory _$$MarketMoversImplCopyWith(
          _$MarketMoversImpl value, $Res Function(_$MarketMoversImpl) then) =
      __$$MarketMoversImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Coin> gainers, List<Coin> losers});
}

/// @nodoc
class __$$MarketMoversImplCopyWithImpl<$Res>
    extends _$MarketMoversCopyWithImpl<$Res, _$MarketMoversImpl>
    implements _$$MarketMoversImplCopyWith<$Res> {
  __$$MarketMoversImplCopyWithImpl(
      _$MarketMoversImpl _value, $Res Function(_$MarketMoversImpl) _then)
      : super(_value, _then);

  /// Create a copy of MarketMovers
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gainers = null,
    Object? losers = null,
  }) {
    return _then(_$MarketMoversImpl(
      gainers: null == gainers
          ? _value._gainers
          : gainers // ignore: cast_nullable_to_non_nullable
              as List<Coin>,
      losers: null == losers
          ? _value._losers
          : losers // ignore: cast_nullable_to_non_nullable
              as List<Coin>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MarketMoversImpl implements _MarketMovers {
  const _$MarketMoversImpl(
      {required final List<Coin> gainers, required final List<Coin> losers})
      : _gainers = gainers,
        _losers = losers;

  factory _$MarketMoversImpl.fromJson(Map<String, dynamic> json) =>
      _$$MarketMoversImplFromJson(json);

  final List<Coin> _gainers;
  @override
  List<Coin> get gainers {
    if (_gainers is EqualUnmodifiableListView) return _gainers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_gainers);
  }

  final List<Coin> _losers;
  @override
  List<Coin> get losers {
    if (_losers is EqualUnmodifiableListView) return _losers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_losers);
  }

  @override
  String toString() {
    return 'MarketMovers(gainers: $gainers, losers: $losers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MarketMoversImpl &&
            const DeepCollectionEquality().equals(other._gainers, _gainers) &&
            const DeepCollectionEquality().equals(other._losers, _losers));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_gainers),
      const DeepCollectionEquality().hash(_losers));

  /// Create a copy of MarketMovers
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MarketMoversImplCopyWith<_$MarketMoversImpl> get copyWith =>
      __$$MarketMoversImplCopyWithImpl<_$MarketMoversImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MarketMoversImplToJson(
      this,
    );
  }
}

abstract class _MarketMovers implements MarketMovers {
  const factory _MarketMovers(
      {required final List<Coin> gainers,
      required final List<Coin> losers}) = _$MarketMoversImpl;

  factory _MarketMovers.fromJson(Map<String, dynamic> json) =
      _$MarketMoversImpl.fromJson;

  @override
  List<Coin> get gainers;
  @override
  List<Coin> get losers;

  /// Create a copy of MarketMovers
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MarketMoversImplCopyWith<_$MarketMoversImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CategoryItem _$CategoryItemFromJson(Map<String, dynamic> json) {
  return _CategoryItem.fromJson(json);
}

/// @nodoc
mixin _$CategoryItem {
  String get name => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;

  /// Serializes this CategoryItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CategoryItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoryItemCopyWith<CategoryItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryItemCopyWith<$Res> {
  factory $CategoryItemCopyWith(
          CategoryItem value, $Res Function(CategoryItem) then) =
      _$CategoryItemCopyWithImpl<$Res, CategoryItem>;
  @useResult
  $Res call({String name, int count});
}

/// @nodoc
class _$CategoryItemCopyWithImpl<$Res, $Val extends CategoryItem>
    implements $CategoryItemCopyWith<$Res> {
  _$CategoryItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategoryItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? count = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CategoryItemImplCopyWith<$Res>
    implements $CategoryItemCopyWith<$Res> {
  factory _$$CategoryItemImplCopyWith(
          _$CategoryItemImpl value, $Res Function(_$CategoryItemImpl) then) =
      __$$CategoryItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, int count});
}

/// @nodoc
class __$$CategoryItemImplCopyWithImpl<$Res>
    extends _$CategoryItemCopyWithImpl<$Res, _$CategoryItemImpl>
    implements _$$CategoryItemImplCopyWith<$Res> {
  __$$CategoryItemImplCopyWithImpl(
      _$CategoryItemImpl _value, $Res Function(_$CategoryItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of CategoryItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? count = null,
  }) {
    return _then(_$CategoryItemImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CategoryItemImpl implements _CategoryItem {
  const _$CategoryItemImpl({required this.name, required this.count});

  factory _$CategoryItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryItemImplFromJson(json);

  @override
  final String name;
  @override
  final int count;

  @override
  String toString() {
    return 'CategoryItem(name: $name, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryItemImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, count);

  /// Create a copy of CategoryItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryItemImplCopyWith<_$CategoryItemImpl> get copyWith =>
      __$$CategoryItemImplCopyWithImpl<_$CategoryItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryItemImplToJson(
      this,
    );
  }
}

abstract class _CategoryItem implements CategoryItem {
  const factory _CategoryItem(
      {required final String name,
      required final int count}) = _$CategoryItemImpl;

  factory _CategoryItem.fromJson(Map<String, dynamic> json) =
      _$CategoryItemImpl.fromJson;

  @override
  String get name;
  @override
  int get count;

  /// Create a copy of CategoryItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryItemImplCopyWith<_$CategoryItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
