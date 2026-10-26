import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_shimmer.dart';
import '../providers/categories_providers.dart';
import 'widgets/category_row.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFilter = ref.watch(selectedCategoryFilterProvider);
    final categoriesAsync = ref.watch(coinGeckoCategoriesProvider);

    return Column(
      children: [
        // Sub-filters row
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
                    _buildFilterChip(ref, label: '✨ Insights', isSelected: selectedFilter == 'Insights'),
                    const SizedBox(width: 8),
                    _buildFilterChip(ref, label: 'Key Stats', isSelected: selectedFilter == 'Key Stats'),
                    const SizedBox(width: 8),
                    _buildFilterChip(ref, label: '★ Following', isSelected: selectedFilter == 'Following'),
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
                  icon: const Icon(Icons.swap_vert_rounded, size: 20, color: AppColors.darkTextSecondary),
                  onPressed: () {},
                  padding: const EdgeInsets.all(6),
                  constraints: const BoxConstraints(),
                ),
              ),
            ],
          ),
        ),

        // Institutional Insight Ticker Card
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.darkSurface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.darkBorder),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('✨', style: TextStyle(fontSize: 14)),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Institutional RWA categories including Tokenized Credit and Tradable Ecosystem outperformed speculative sectors today.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.darkTextSecondary,
                    height: 1.35,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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
                child: Text('Category', style: TextStyle(color: AppColors.darkTextMuted, fontSize: 12)),
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

        // Categories List
        Expanded(
          child: categoriesAsync.when(
            loading: () => const LoadingShimmer(itemCount: 12),
            error: (err, _) => ErrorView(
              message: err.toString(),
              onRetry: () => ref.invalidate(coinGeckoCategoriesProvider),
            ),
            data: (categories) {
              return RefreshIndicator(
                onRefresh: () async => ref.invalidate(coinGeckoCategoriesProvider),
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    return CategoryRow(category: categories[index]);
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
          ref.read(selectedCategoryFilterProvider.notifier).state = label.replaceAll('✨ ', '').replaceAll('★ ', '');
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
