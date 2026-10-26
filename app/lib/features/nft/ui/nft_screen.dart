import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_shimmer.dart';
import '../providers/nft_providers.dart';
import 'widgets/nft_row.dart';

class NftScreen extends ConsumerWidget {
  const NftScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFilter = ref.watch(selectedNftFilterProvider);
    final nftsAsync = ref.watch(nftCollectionsProvider);

    return Column(
      children: [
        // Sub-filter row
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildFilterChip(ref, label: 'All', isSelected: selectedFilter == 'All'),
                    const SizedBox(width: 8),
                    _buildFilterChip(ref, label: '🔥 Trending', isSelected: selectedFilter == 'Trending'),
                    const SizedBox(width: 8),
                    _buildFilterChip(ref, label: '🚀 Top Gainers', isSelected: selectedFilter == 'Top Gainers'),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.darkSurface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.darkBorder),
                ),
                child: IconButton(
                  icon: const Icon(Icons.link_rounded, size: 20, color: AppColors.darkTextSecondary),
                  onPressed: () {},
                  padding: const EdgeInsets.all(6),
                  constraints: const BoxConstraints(),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.darkSurface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.darkBorder),
                ),
                child: IconButton(
                  icon: const Icon(Icons.tune_rounded, size: 20, color: AppColors.darkTextSecondary),
                  onPressed: () {},
                  padding: const EdgeInsets.all(6),
                  constraints: const BoxConstraints(),
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
                child: Text('NFT', style: TextStyle(color: AppColors.darkTextMuted, fontSize: 12)),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text('Floor Price', textAlign: TextAlign.right, style: TextStyle(color: AppColors.darkTextMuted, fontSize: 12)),
              ),
              SizedBox(width: 12),
              SizedBox(
                width: 90,
                child: Text('Market Cap ▼', textAlign: TextAlign.right, style: TextStyle(color: AppColors.darkTextMuted, fontSize: 12)),
              ),
            ],
          ),
        ),

        const Divider(height: 1),

        // NFT List
        Expanded(
          child: nftsAsync.when(
            loading: () => const LoadingShimmer(itemCount: 10),
            error: (err, _) => ErrorView(
              message: err.toString(),
              onRetry: () => ref.invalidate(nftCollectionsProvider),
            ),
            data: (nfts) {
              return RefreshIndicator(
                onRefresh: () async => ref.invalidate(nftCollectionsProvider),
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: nfts.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    return NftRow(nft: nfts[index]);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(WidgetRef ref, {required String label, required bool isSelected}) {
    return Center(
      child: InkWell(
        onTap: () {
          ref.read(selectedNftFilterProvider.notifier).state =
              label.replaceAll('🔥 ', '').replaceAll('🚀 ', '');
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withValues(alpha: 0.18) : AppColors.darkSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.darkBorder,
              width: 1.0,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? AppColors.primary : AppColors.darkTextSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
