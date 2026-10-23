import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../coins/data/models/coin.dart';

part 'watchlist_item.freezed.dart';
part 'watchlist_item.g.dart';

@freezed
class WatchlistItem with _$WatchlistItem {
  const factory WatchlistItem({
    required int id,
    @JsonKey(name: 'device_id') required String deviceId,
    @JsonKey(name: 'coin_id') required String coinId,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    required Coin coin,
  }) = _WatchlistItem;

  factory WatchlistItem.fromJson(Map<String, dynamic> json) =>
      _$WatchlistItemFromJson(json);
}
