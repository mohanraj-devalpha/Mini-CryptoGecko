import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        title: const Text('Explore Web3'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCard(
            title: '🔥 Trending Narratives',
            subtitle: 'AI Agents, DePIN, Real World Assets (RWA), Solana Ecosystem',
            icon: Icons.local_fire_department_rounded,
          ),
          const SizedBox(height: 12),
          _buildCard(
            title: '📰 Crypto News & Research',
            subtitle: 'Gecko Research reports, daily market recaps & deep dives',
            icon: Icons.article_rounded,
          ),
          const SizedBox(height: 12),
          _buildCard(
            title: '🍬 Candy Rewards Center',
            subtitle: 'Redeem your candies for subscription vouchers, books & gear',
            icon: Icons.card_giftcard_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required String title, required String subtitle, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 28),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: AppColors.darkTextSecondary, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.darkTextMuted),
        ],
      ),
    );
  }
}
