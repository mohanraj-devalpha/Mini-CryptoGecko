enum ExchangeType { cex, dex, derivatives }

class Exchange {
  final String id;
  final String name;
  final int rank;
  final String imageUrl;
  final double volume24hBtc;
  final int trustScore; // 1-10
  final ExchangeType type;
  final String? country;
  final String? url;

  const Exchange({
    required this.id,
    required this.name,
    required this.rank,
    required this.imageUrl,
    required this.volume24hBtc,
    required this.trustScore,
    this.type = ExchangeType.cex,
    this.country,
    this.url,
  });

  factory Exchange.fromJson(Map<String, dynamic> json, {ExchangeType type = ExchangeType.cex, int? fallbackRank}) {
    final rankVal = json['trust_score_rank'] ?? fallbackRank ?? 1;
    final volume = (json['trade_volume_24h_btc'] as num?)?.toDouble() ??
        (json['trade_volume_24h_btc_normalized'] as num?)?.toDouble() ??
        0.0;
    final trust = (json['trust_score'] as num?)?.toInt() ?? 10;

    return Exchange(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown Exchange',
      rank: rankVal is int ? rankVal : int.tryParse(rankVal.toString()) ?? 1,
      imageUrl: json['image']?.toString() ?? '',
      volume24hBtc: volume,
      trustScore: trust,
      type: type,
      country: json['country']?.toString(),
      url: json['url']?.toString(),
    );
  }
}
