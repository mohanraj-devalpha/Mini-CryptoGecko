// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coin_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CoinMarketData _$CoinMarketDataFromJson(Map<String, dynamic> json) {
  return _CoinMarketData.fromJson(json);
}

/// @nodoc
mixin _$CoinMarketData {
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
  double get ath => throw _privateConstructorUsedError;
  @JsonKey(name: 'ath_date')
  DateTime get athDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this CoinMarketData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CoinMarketData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CoinMarketDataCopyWith<CoinMarketData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CoinMarketDataCopyWith<$Res> {
  factory $CoinMarketDataCopyWith(
          CoinMarketData value, $Res Function(CoinMarketData) then) =
      _$CoinMarketDataCopyWithImpl<$Res, CoinMarketData>;
  @useResult
  $Res call(
      {double price,
      @JsonKey(name: 'volume_24h') double volume24h,
      @JsonKey(name: 'market_cap') double marketCap,
      @JsonKey(name: 'change_24h_pct') double change24hPct,
      @JsonKey(name: 'high_24h') double high24h,
      @JsonKey(name: 'low_24h') double low24h,
      double ath,
      @JsonKey(name: 'ath_date') DateTime athDate,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class _$CoinMarketDataCopyWithImpl<$Res, $Val extends CoinMarketData>
    implements $CoinMarketDataCopyWith<$Res> {
  _$CoinMarketDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CoinMarketData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? price = null,
    Object? volume24h = null,
    Object? marketCap = null,
    Object? change24hPct = null,
    Object? high24h = null,
    Object? low24h = null,
    Object? ath = null,
    Object? athDate = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
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
      ath: null == ath
          ? _value.ath
          : ath // ignore: cast_nullable_to_non_nullable
              as double,
      athDate: null == athDate
          ? _value.athDate
          : athDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CoinMarketDataImplCopyWith<$Res>
    implements $CoinMarketDataCopyWith<$Res> {
  factory _$$CoinMarketDataImplCopyWith(_$CoinMarketDataImpl value,
          $Res Function(_$CoinMarketDataImpl) then) =
      __$$CoinMarketDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double price,
      @JsonKey(name: 'volume_24h') double volume24h,
      @JsonKey(name: 'market_cap') double marketCap,
      @JsonKey(name: 'change_24h_pct') double change24hPct,
      @JsonKey(name: 'high_24h') double high24h,
      @JsonKey(name: 'low_24h') double low24h,
      double ath,
      @JsonKey(name: 'ath_date') DateTime athDate,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class __$$CoinMarketDataImplCopyWithImpl<$Res>
    extends _$CoinMarketDataCopyWithImpl<$Res, _$CoinMarketDataImpl>
    implements _$$CoinMarketDataImplCopyWith<$Res> {
  __$$CoinMarketDataImplCopyWithImpl(
      _$CoinMarketDataImpl _value, $Res Function(_$CoinMarketDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of CoinMarketData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? price = null,
    Object? volume24h = null,
    Object? marketCap = null,
    Object? change24hPct = null,
    Object? high24h = null,
    Object? low24h = null,
    Object? ath = null,
    Object? athDate = null,
    Object? updatedAt = null,
  }) {
    return _then(_$CoinMarketDataImpl(
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
      ath: null == ath
          ? _value.ath
          : ath // ignore: cast_nullable_to_non_nullable
              as double,
      athDate: null == athDate
          ? _value.athDate
          : athDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CoinMarketDataImpl implements _CoinMarketData {
  const _$CoinMarketDataImpl(
      {required this.price,
      @JsonKey(name: 'volume_24h') required this.volume24h,
      @JsonKey(name: 'market_cap') required this.marketCap,
      @JsonKey(name: 'change_24h_pct') required this.change24hPct,
      @JsonKey(name: 'high_24h') required this.high24h,
      @JsonKey(name: 'low_24h') required this.low24h,
      required this.ath,
      @JsonKey(name: 'ath_date') required this.athDate,
      @JsonKey(name: 'updated_at') required this.updatedAt});

  factory _$CoinMarketDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$CoinMarketDataImplFromJson(json);

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
  final double ath;
  @override
  @JsonKey(name: 'ath_date')
  final DateTime athDate;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'CoinMarketData(price: $price, volume24h: $volume24h, marketCap: $marketCap, change24hPct: $change24hPct, high24h: $high24h, low24h: $low24h, ath: $ath, athDate: $athDate, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CoinMarketDataImpl &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.volume24h, volume24h) ||
                other.volume24h == volume24h) &&
            (identical(other.marketCap, marketCap) ||
                other.marketCap == marketCap) &&
            (identical(other.change24hPct, change24hPct) ||
                other.change24hPct == change24hPct) &&
            (identical(other.high24h, high24h) || other.high24h == high24h) &&
            (identical(other.low24h, low24h) || other.low24h == low24h) &&
            (identical(other.ath, ath) || other.ath == ath) &&
            (identical(other.athDate, athDate) || other.athDate == athDate) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, price, volume24h, marketCap,
      change24hPct, high24h, low24h, ath, athDate, updatedAt);

  /// Create a copy of CoinMarketData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CoinMarketDataImplCopyWith<_$CoinMarketDataImpl> get copyWith =>
      __$$CoinMarketDataImplCopyWithImpl<_$CoinMarketDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CoinMarketDataImplToJson(
      this,
    );
  }
}

abstract class _CoinMarketData implements CoinMarketData {
  const factory _CoinMarketData(
          {required final double price,
          @JsonKey(name: 'volume_24h') required final double volume24h,
          @JsonKey(name: 'market_cap') required final double marketCap,
          @JsonKey(name: 'change_24h_pct') required final double change24hPct,
          @JsonKey(name: 'high_24h') required final double high24h,
          @JsonKey(name: 'low_24h') required final double low24h,
          required final double ath,
          @JsonKey(name: 'ath_date') required final DateTime athDate,
          @JsonKey(name: 'updated_at') required final DateTime updatedAt}) =
      _$CoinMarketDataImpl;

  factory _CoinMarketData.fromJson(Map<String, dynamic> json) =
      _$CoinMarketDataImpl.fromJson;

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
  @override
  double get ath;
  @override
  @JsonKey(name: 'ath_date')
  DateTime get athDate;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of CoinMarketData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CoinMarketDataImplCopyWith<_$CoinMarketDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CoinDetail _$CoinDetailFromJson(Map<String, dynamic> json) {
  return _CoinDetail.fromJson(json);
}

/// @nodoc
mixin _$CoinDetail {
  String get id => throw _privateConstructorUsedError;
  String get symbol => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String? get imageUrl => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  @JsonKey(name: 'circulating_supply')
  double get circulatingSupply => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_supply')
  double get totalSupply => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_supply')
  double? get maxSupply => throw _privateConstructorUsedError;
  int get rank => throw _privateConstructorUsedError;
  CoinMarketData get market => throw _privateConstructorUsedError;

  /// Serializes this CoinDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CoinDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CoinDetailCopyWith<CoinDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CoinDetailCopyWith<$Res> {
  factory $CoinDetailCopyWith(
          CoinDetail value, $Res Function(CoinDetail) then) =
      _$CoinDetailCopyWithImpl<$Res, CoinDetail>;
  @useResult
  $Res call(
      {String id,
      String symbol,
      String name,
      @JsonKey(name: 'image_url') String? imageUrl,
      String description,
      String category,
      @JsonKey(name: 'circulating_supply') double circulatingSupply,
      @JsonKey(name: 'total_supply') double totalSupply,
      @JsonKey(name: 'max_supply') double? maxSupply,
      int rank,
      CoinMarketData market});

  $CoinMarketDataCopyWith<$Res> get market;
}

/// @nodoc
class _$CoinDetailCopyWithImpl<$Res, $Val extends CoinDetail>
    implements $CoinDetailCopyWith<$Res> {
  _$CoinDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CoinDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? symbol = null,
    Object? name = null,
    Object? imageUrl = freezed,
    Object? description = null,
    Object? category = null,
    Object? circulatingSupply = null,
    Object? totalSupply = null,
    Object? maxSupply = freezed,
    Object? rank = null,
    Object? market = null,
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
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      circulatingSupply: null == circulatingSupply
          ? _value.circulatingSupply
          : circulatingSupply // ignore: cast_nullable_to_non_nullable
              as double,
      totalSupply: null == totalSupply
          ? _value.totalSupply
          : totalSupply // ignore: cast_nullable_to_non_nullable
              as double,
      maxSupply: freezed == maxSupply
          ? _value.maxSupply
          : maxSupply // ignore: cast_nullable_to_non_nullable
              as double?,
      rank: null == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int,
      market: null == market
          ? _value.market
          : market // ignore: cast_nullable_to_non_nullable
              as CoinMarketData,
    ) as $Val);
  }

  /// Create a copy of CoinDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CoinMarketDataCopyWith<$Res> get market {
    return $CoinMarketDataCopyWith<$Res>(_value.market, (value) {
      return _then(_value.copyWith(market: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CoinDetailImplCopyWith<$Res>
    implements $CoinDetailCopyWith<$Res> {
  factory _$$CoinDetailImplCopyWith(
          _$CoinDetailImpl value, $Res Function(_$CoinDetailImpl) then) =
      __$$CoinDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String symbol,
      String name,
      @JsonKey(name: 'image_url') String? imageUrl,
      String description,
      String category,
      @JsonKey(name: 'circulating_supply') double circulatingSupply,
      @JsonKey(name: 'total_supply') double totalSupply,
      @JsonKey(name: 'max_supply') double? maxSupply,
      int rank,
      CoinMarketData market});

  @override
  $CoinMarketDataCopyWith<$Res> get market;
}

/// @nodoc
class __$$CoinDetailImplCopyWithImpl<$Res>
    extends _$CoinDetailCopyWithImpl<$Res, _$CoinDetailImpl>
    implements _$$CoinDetailImplCopyWith<$Res> {
  __$$CoinDetailImplCopyWithImpl(
      _$CoinDetailImpl _value, $Res Function(_$CoinDetailImpl) _then)
      : super(_value, _then);

  /// Create a copy of CoinDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? symbol = null,
    Object? name = null,
    Object? imageUrl = freezed,
    Object? description = null,
    Object? category = null,
    Object? circulatingSupply = null,
    Object? totalSupply = null,
    Object? maxSupply = freezed,
    Object? rank = null,
    Object? market = null,
  }) {
    return _then(_$CoinDetailImpl(
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
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      circulatingSupply: null == circulatingSupply
          ? _value.circulatingSupply
          : circulatingSupply // ignore: cast_nullable_to_non_nullable
              as double,
      totalSupply: null == totalSupply
          ? _value.totalSupply
          : totalSupply // ignore: cast_nullable_to_non_nullable
              as double,
      maxSupply: freezed == maxSupply
          ? _value.maxSupply
          : maxSupply // ignore: cast_nullable_to_non_nullable
              as double?,
      rank: null == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int,
      market: null == market
          ? _value.market
          : market // ignore: cast_nullable_to_non_nullable
              as CoinMarketData,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CoinDetailImpl implements _CoinDetail {
  const _$CoinDetailImpl(
      {required this.id,
      required this.symbol,
      required this.name,
      @JsonKey(name: 'image_url') this.imageUrl,
      required this.description,
      required this.category,
      @JsonKey(name: 'circulating_supply') required this.circulatingSupply,
      @JsonKey(name: 'total_supply') required this.totalSupply,
      @JsonKey(name: 'max_supply') this.maxSupply,
      required this.rank,
      required this.market});

  factory _$CoinDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$CoinDetailImplFromJson(json);

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
  final String description;
  @override
  final String category;
  @override
  @JsonKey(name: 'circulating_supply')
  final double circulatingSupply;
  @override
  @JsonKey(name: 'total_supply')
  final double totalSupply;
  @override
  @JsonKey(name: 'max_supply')
  final double? maxSupply;
  @override
  final int rank;
  @override
  final CoinMarketData market;

  @override
  String toString() {
    return 'CoinDetail(id: $id, symbol: $symbol, name: $name, imageUrl: $imageUrl, description: $description, category: $category, circulatingSupply: $circulatingSupply, totalSupply: $totalSupply, maxSupply: $maxSupply, rank: $rank, market: $market)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CoinDetailImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.circulatingSupply, circulatingSupply) ||
                other.circulatingSupply == circulatingSupply) &&
            (identical(other.totalSupply, totalSupply) ||
                other.totalSupply == totalSupply) &&
            (identical(other.maxSupply, maxSupply) ||
                other.maxSupply == maxSupply) &&
            (identical(other.rank, rank) || other.rank == rank) &&
            (identical(other.market, market) || other.market == market));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      symbol,
      name,
      imageUrl,
      description,
      category,
      circulatingSupply,
      totalSupply,
      maxSupply,
      rank,
      market);

  /// Create a copy of CoinDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CoinDetailImplCopyWith<_$CoinDetailImpl> get copyWith =>
      __$$CoinDetailImplCopyWithImpl<_$CoinDetailImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CoinDetailImplToJson(
      this,
    );
  }
}

abstract class _CoinDetail implements CoinDetail {
  const factory _CoinDetail(
      {required final String id,
      required final String symbol,
      required final String name,
      @JsonKey(name: 'image_url') final String? imageUrl,
      required final String description,
      required final String category,
      @JsonKey(name: 'circulating_supply')
      required final double circulatingSupply,
      @JsonKey(name: 'total_supply') required final double totalSupply,
      @JsonKey(name: 'max_supply') final double? maxSupply,
      required final int rank,
      required final CoinMarketData market}) = _$CoinDetailImpl;

  factory _CoinDetail.fromJson(Map<String, dynamic> json) =
      _$CoinDetailImpl.fromJson;

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
  String get description;
  @override
  String get category;
  @override
  @JsonKey(name: 'circulating_supply')
  double get circulatingSupply;
  @override
  @JsonKey(name: 'total_supply')
  double get totalSupply;
  @override
  @JsonKey(name: 'max_supply')
  double? get maxSupply;
  @override
  int get rank;
  @override
  CoinMarketData get market;

  /// Create a copy of CoinDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CoinDetailImplCopyWith<_$CoinDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
