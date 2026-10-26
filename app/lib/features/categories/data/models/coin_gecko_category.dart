class CoinGeckoCategory {
  final String id;
  final String name;
  final double marketCap;
  final double change24hPct;
  final double volume24h;
  final List<String> top3Coins;

  const CoinGeckoCategory({
    required this.id,
    required this.name,
    required this.marketCap,
    required this.change24hPct,
    required this.volume24h,
    this.top3Coins = const [],
  });

  factory CoinGeckoCategory.fromJson(Map<String, dynamic> json) {
    final topCoinsRaw = json['top_3_coins'];
    List<String> topCoinsList = [];
    if (topCoinsRaw is List) {
      topCoinsList = topCoinsRaw.map((e) => e.toString()).toList();
    }

    return CoinGeckoCategory(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Category',
      marketCap: (json['market_cap'] as num?)?.toDouble() ?? 0.0,
      change24hPct: (json['market_cap_change_24h'] as num?)?.toDouble() ?? 0.0,
      volume24h: (json['volume_24h'] as num?)?.toDouble() ?? 0.0,
      top3Coins: topCoinsList,
    );
  }
}
