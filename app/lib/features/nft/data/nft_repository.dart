import '../../../core/network/api_client.dart';
import 'models/nft_collection.dart';

class NftRepository {
  final ApiClient apiClient;

  NftRepository({required this.apiClient});

  Future<List<NftCollection>> getNfts({String filter = 'All'}) async {
    try {
      final res = await apiClient.dio.get(
        '/nfts/markets',
        queryParameters: {
          'order': filter == 'Top Gainers' ? 'h24_volume_native_currency_desc' : 'market_cap_usd_desc',
          'per_page': 50,
          'page': 1,
        },
      );
      final list = (res.data is List) ? res.data as List<dynamic> : [];
      if (list.isNotEmpty) {
        return list.map((item) => NftCollection.fromJson(item as Map<String, dynamic>)).toList();
      }
    } catch (_) {
      // Fallback
    }

    return _getFallbackNfts(filter);
  }

  List<NftCollection> _getFallbackNfts(String filter) {
    final list = [
      const NftCollection(
        id: 'cryptopunks',
        name: 'CryptoPunks',
        imageUrl: 'https://assets.coingecko.com/nft_contracts/images/280/small/cryptopunks.png',
        floorPrice: 30.49,
        currency: 'Ξ',
        change24hPct: -3.2,
        marketCap: 304717.0,
      ),
      const NftCollection(
        id: 'bored-ape-yacht-club',
        name: 'Bored Ape Yacht Club',
        imageUrl: 'https://assets.coingecko.com/nft_contracts/images/20/small/bayc.png',
        floorPrice: 5.74,
        currency: 'Ξ',
        change24hPct: -0.1,
        marketCap: 57388.0,
      ),
      const NftCollection(
        id: 'autoglyphs',
        name: 'Autoglyphs',
        imageUrl: 'https://assets.coingecko.com/nft_contracts/images/154/small/autoglyphs.png',
        floorPrice: 87.00,
        currency: 'Ξ',
        change24hPct: -1.2,
        marketCap: 44544.0,
      ),
      const NftCollection(
        id: 'hypurr',
        name: 'Hypurr',
        imageUrl: 'https://assets.coingecko.com/nft_contracts/images/3956/small/hypurr.png',
        floorPrice: 199.98,
        currency: 'HYPE',
        change24hPct: -0.7,
        marketCap: 919908.0,
      ),
      const NftCollection(
        id: 'pudgy-penguins',
        name: 'Pudgy Penguins',
        imageUrl: 'https://assets.coingecko.com/nft_contracts/images/233/small/pudgy.png',
        floorPrice: 2.50,
        currency: 'Ξ',
        change24hPct: -0.5,
        marketCap: 22220.0,
      ),
      const NftCollection(
        id: 'fidenza-by-tyler-hobbs',
        name: 'Fidenza by Tyler Hobbs',
        imageUrl: 'https://assets.coingecko.com/nft_contracts/images/183/small/fidenza.png',
        floorPrice: 21.95,
        currency: 'Ξ',
        change24hPct: -1.2,
        marketCap: 21928.0,
      ),
      const NftCollection(
        id: 'chromie-squiggle-by-snowfro',
        name: 'Chromie Squiggle by Snowfro',
        imageUrl: 'https://assets.coingecko.com/nft_contracts/images/179/small/chromie.png',
        floorPrice: 2.19,
        currency: 'Ξ',
        change24hPct: -4.6,
        marketCap: 21858.0,
      ),
      const NftCollection(
        id: 'tomorrowland-ticket-to-medallion',
        name: 'Tomorrowland: A Ticket to...',
        imageUrl: 'https://assets.coingecko.com/nft_contracts/images/1283/small/tomorrowland.png',
        floorPrice: 47.34,
        currency: 'SOL',
        change24hPct: -0.3,
        marketCap: 307188.0,
      ),
      const NftCollection(
        id: 'mutant-ape-yacht-club',
        name: 'Mutant Ape Yacht Club',
        imageUrl: 'https://assets.coingecko.com/nft_contracts/images/223/small/mayc.png',
        floorPrice: 0.80,
        currency: 'Ξ',
        change24hPct: -1.1,
        marketCap: 15598.0,
      ),
      const NftCollection(
        id: 'baby-bears',
        name: 'Baby Bears',
        imageUrl: 'https://assets.coingecko.com/nft_contracts/images/3214/small/baby_bears.png',
        floorPrice: 19.88,
        currency: 'Ξ',
        change24hPct: -21.3,
        marketCap: 11332.0,
      ),
    ];

    if (filter == 'Top Gainers') {
      return [...list]..sort((a, b) => b.change24hPct.compareTo(a.change24hPct));
    }
    return list;
  }
}
