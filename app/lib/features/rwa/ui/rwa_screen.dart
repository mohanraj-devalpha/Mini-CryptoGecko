import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../categories/data/models/coin_gecko_category.dart';
import '../../categories/ui/widgets/category_row.dart';

class RwaScreen extends StatelessWidget {
  const RwaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const rwaCategories = [
      CoinGeckoCategory(
        id: 'real-world-assets-rwa',
        name: 'Real World Assets (RWA)',
        marketCap: 38450000000.0,
        change24hPct: 1.4,
        volume24h: 3100000000.0,
        top3Coins: [
          'https://assets.coingecko.com/coins/images/279/small/ethereum.png',
          'https://assets.coingecko.com/coins/images/4128/small/solana.png',
          'https://assets.coingecko.com/coins/images/325/small/Tether.png',
        ],
      ),
      CoinGeckoCategory(
        id: 'tokenized-treasuries',
        name: 'Tokenized US Treasuries',
        marketCap: 2450000000.0,
        change24hPct: 0.1,
        volume24h: 420000000.0,
        top3Coins: [
          'https://assets.coingecko.com/coins/images/6319/small/usdc.png',
          'https://assets.coingecko.com/coins/images/325/small/Tether.png',
        ],
      ),
      CoinGeckoCategory(
        id: 'tokenized-private-credit',
        name: 'Tokenized Private Credit',
        marketCap: 1540000000.0,
        change24hPct: -0.2,
        volume24h: 180000000.0,
        top3Coins: [
          'https://assets.coingecko.com/coins/images/279/small/ethereum.png',
          'https://assets.coingecko.com/coins/images/9956/small/Badge_Dai.png',
        ],
      ),
      CoinGeckoCategory(
        id: 'tokenized-real-estate',
        name: 'Tokenized Real Estate',
        marketCap: 890000000.0,
        change24hPct: 0.6,
        volume24h: 75000000.0,
        top3Coins: [
          'https://assets.coingecko.com/coins/images/279/small/ethereum.png',
        ],
      ),
      CoinGeckoCategory(
        id: 'tokenized-commodities',
        name: 'Tokenized Commodities (Gold/Silver)',
        marketCap: 1250000000.0,
        change24hPct: 0.8,
        volume24h: 110000000.0,
        top3Coins: [
          'https://assets.coingecko.com/coins/images/279/small/ethereum.png',
          'https://assets.coingecko.com/coins/images/325/small/Tether.png',
        ],
      ),
    ];

    return Column(
      children: [
        // RWA Spotlight Banner
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.darkSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: const [
              Text('🏛️', style: TextStyle(fontSize: 20)),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Real World Assets (RWA) brings traditional financial instruments like Treasuries, Credit, and Real Estate on-chain.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.darkTextSecondary,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Table Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: const [
              Expanded(
                child: Text('RWA Sector', style: TextStyle(color: AppColors.darkTextMuted, fontSize: 12)),
              ),
              SizedBox(
                width: 70,
                child: Text('24H', textAlign: TextAlign.right, style: TextStyle(color: AppColors.darkTextMuted, fontSize: 12)),
              ),
              SizedBox(width: 16),
              SizedBox(
                width: 85,
                child: Text('Market Cap ▼', textAlign: TextAlign.right, style: TextStyle(color: AppColors.darkTextMuted, fontSize: 12)),
              ),
            ],
          ),
        ),

        const Divider(height: 1),

        Expanded(
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: rwaCategories.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              return CategoryRow(category: rwaCategories[index]);
            },
          ),
        ),
      ],
    );
  }
}
