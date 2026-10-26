import '../../../core/network/api_client.dart';
import 'models/coin_gecko_category.dart';

class CategoriesRepository {
  final ApiClient apiClient;

  CategoriesRepository({required this.apiClient});

  Future<List<CoinGeckoCategory>> getCategories() async {
    try {
      final res = await apiClient.dio.get('/coins/categories');
      final list = (res.data is List) ? res.data as List<dynamic> : [];
      if (list.isNotEmpty) {
        return list
            .take(40)
            .map((item) => CoinGeckoCategory.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {
      // Fallback
    }

    return _getFallbackCategories();
  }

  List<CoinGeckoCategory> _getFallbackCategories() {
    return const [
      CoinGeckoCategory(
        id: 'smart-contract-platform',
        name: 'Smart Contract Platforms',
        marketCap: 2323000000000.0,
        change24hPct: -0.4,
        volume24h: 75200000000.0,
        top3Coins: [
          'https://assets.coingecko.com/coins/images/279/small/ethereum.png',
          'https://assets.coingecko.com/coins/images/825/small/bnb-icon2_2x.png',
          'https://assets.coingecko.com/coins/images/4128/small/solana.png',
        ],
      ),
      CoinGeckoCategory(
        id: 'layer-1',
        name: 'Layer 1 (L1)',
        marketCap: 2291000000000.0,
        change24hPct: -0.4,
        volume24h: 82100000000.0,
        top3Coins: [
          'https://assets.coingecko.com/coins/images/1/small/bitcoin_2.png',
          'https://assets.coingecko.com/coins/images/279/small/ethereum.png',
          'https://assets.coingecko.com/coins/images/825/small/bnb-icon2_2x.png',
        ],
      ),
      CoinGeckoCategory(
        id: 'proof-of-work-pow',
        name: 'Proof of Work (PoW)',
        marketCap: 1672000000000.0,
        change24hPct: -0.3,
        volume24h: 42100000000.0,
        top3Coins: [
          'https://assets.coingecko.com/coins/images/1/small/bitcoin_2.png',
          'https://assets.coingecko.com/coins/images/5/small/dogecoin.png',
          'https://assets.coingecko.com/coins/images/2/small/litecoin.png',
        ],
      ),
      CoinGeckoCategory(
        id: 'world-liberty-financial',
        name: 'World Liberty Financial',
        marketCap: 594870000000.0,
        change24hPct: -0.9,
        volume24h: 12500000000.0,
        top3Coins: [
          'https://assets.coingecko.com/coins/images/279/small/ethereum.png',
          'https://assets.coingecko.com/coins/images/325/small/Tether.png',
          'https://assets.coingecko.com/coins/images/6319/small/usdc.png',
        ],
      ),
      CoinGeckoCategory(
        id: 'proof-of-stake-pos',
        name: 'Proof of Stake (PoS)',
        marketCap: 524140000000.0,
        change24hPct: -0.9,
        volume24h: 21900000000.0,
        top3Coins: [
          'https://assets.coingecko.com/coins/images/279/small/ethereum.png',
          'https://assets.coingecko.com/coins/images/825/small/bnb-icon2_2x.png',
          'https://assets.coingecko.com/coins/images/4128/small/solana.png',
        ],
      ),
      CoinGeckoCategory(
        id: 'made-in-usa',
        name: 'Made in USA',
        marketCap: 312600000000.0,
        change24hPct: 0.2,
        volume24h: 18400000000.0,
        top3Coins: [
          'https://assets.coingecko.com/coins/images/44/small/xrp-symbol-white-128.png',
          'https://assets.coingecko.com/coins/images/6319/small/usdc.png',
          'https://assets.coingecko.com/coins/images/4128/small/solana.png',
        ],
      ),
      CoinGeckoCategory(
        id: 'stablecoins',
        name: 'Stablecoins',
        marketCap: 297120000000.0,
        change24hPct: -0.1,
        volume24h: 58900000000.0,
        top3Coins: [
          'https://assets.coingecko.com/coins/images/325/small/Tether.png',
          'https://assets.coingecko.com/coins/images/6319/small/usdc.png',
          'https://assets.coingecko.com/coins/images/9956/small/Badge_Dai.png',
        ],
      ),
      CoinGeckoCategory(
        id: 'usd-stablecoin',
        name: 'USD Stablecoin',
        marketCap: 293940000000.0,
        change24hPct: -0.1,
        volume24h: 56400000000.0,
        top3Coins: [
          'https://assets.coingecko.com/coins/images/325/small/Tether.png',
          'https://assets.coingecko.com/coins/images/6319/small/usdc.png',
          'https://assets.coingecko.com/coins/images/9956/small/Badge_Dai.png',
        ],
      ),
      CoinGeckoCategory(
        id: 'fiat-backed-stablecoins',
        name: 'Fiat-backed Stablecoins',
        marketCap: 282250000000.0,
        change24hPct: -0.1,
        volume24h: 52100000000.0,
        top3Coins: [
          'https://assets.coingecko.com/coins/images/325/small/Tether.png',
          'https://assets.coingecko.com/coins/images/6319/small/usdc.png',
          'https://assets.coingecko.com/coins/images/12645/small/First_Digital_USD_Logo.png',
        ],
      ),
      CoinGeckoCategory(
        id: 'exchange-based-tokens',
        name: 'Exchange-based Tokens',
        marketCap: 156700000000.0,
        change24hPct: 0.2,
        volume24h: 6200000000.0,
        top3Coins: [
          'https://assets.coingecko.com/coins/images/825/small/bnb-icon2_2x.png',
          'https://assets.coingecko.com/coins/images/11683/small/OKB_Logo_2020.png',
          'https://assets.coingecko.com/coins/images/12304/small/leo.png',
        ],
      ),
      CoinGeckoCategory(
        id: 'alleged-sec-securities',
        name: 'Alleged SEC Securities',
        marketCap: 143260000000.0,
        change24hPct: 0.3,
        volume24h: 8900000000.0,
        top3Coins: [
          'https://assets.coingecko.com/coins/images/825/small/bnb-icon2_2x.png',
          'https://assets.coingecko.com/coins/images/4128/small/solana.png',
          'https://assets.coingecko.com/coins/images/975/small/cardano.png',
        ],
      ),
    ];
  }
}
