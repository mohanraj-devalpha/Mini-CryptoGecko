class NftCollection {
  final String id;
  final String name;
  final String imageUrl;
  final double floorPrice;
  final String currency; // 'Ξ', 'SOL', 'HYPE'
  final double change24hPct;
  final double marketCap;

  const NftCollection({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.floorPrice,
    required this.currency,
    required this.change24hPct,
    required this.marketCap,
  });

  factory NftCollection.fromJson(Map<String, dynamic> json) {
    return NftCollection(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'NFT Collection',
      imageUrl: (json['image'] is Map ? json['image']['small'] : json['thumb'])?.toString() ?? '',
      floorPrice: (json['floor_price_in_native_currency'] as num?)?.toDouble() ??
          (json['floor_price'] as num?)?.toDouble() ??
          0.0,
      currency: json['native_currency_symbol']?.toString().toUpperCase() == 'ETH'
          ? 'Ξ'
          : (json['native_currency_symbol']?.toString() ?? 'Ξ'),
      change24hPct: (json['floor_price_24h_percentage_change_native_currency'] as num?)?.toDouble() ??
          (json['floor_price_in_usd_24h_percentage_change'] as num?)?.toDouble() ??
          0.0,
      marketCap: (json['market_cap_in_native_currency'] as num?)?.toDouble() ??
          (json['market_cap'] as num?)?.toDouble() ??
          0.0,
    );
  }
}
