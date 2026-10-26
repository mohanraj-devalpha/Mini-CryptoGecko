import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_shimmer.dart';
import '../data/models/exchange.dart';
import '../providers/exchanges_providers.dart';
import 'widgets/exchange_row.dart';

class ExchangesScreen extends ConsumerWidget {
  const ExchangesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedType = ref.watch(selectedExchangeTypeProvider);
    final exchangesAsync = ref.watch(exchangesListProvider);

    return Column(
      children: [
        // Filter Chips (CEX, DEX, Derivatives)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          alignment: Alignment.centerLeft,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildTypeChip(
                  context,
                  ref,
                  type: ExchangeType.cex,
                  label: 'CEX',
                  icon: Icons.account_balance_outlined,
                  isSelected: selectedType == ExchangeType.cex,
                ),
                const SizedBox(width: 8),
                _buildTypeChip(
                  context,
                  ref,
                  type: ExchangeType.dex,
                  label: 'DEX',
                  icon: Icons.hub_outlined,
                  isSelected: selectedType == ExchangeType.dex,
                ),
                const SizedBox(width: 8),
                _buildTypeChip(
                  context,
                  ref,
                  type: ExchangeType.derivatives,
                  label: 'Derivatives',
                  icon: Icons.trending_up_rounded,
                  isSelected: selectedType == ExchangeType.derivatives,
                ),
              ],
            ),
          ),
        ),

        // Table Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: const [
              SizedBox(
                width: 24,
                child: Text('#', style: TextStyle(color: AppColors.darkTextMuted, fontSize: 12)),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text('Exchange', style: TextStyle(color: AppColors.darkTextMuted, fontSize: 12)),
              ),
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: Text('Reported Volume', style: TextStyle(color: AppColors.darkTextMuted, fontSize: 12)),
              ),
              SizedBox(
                width: 52,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text('Trust', style: TextStyle(color: AppColors.darkTextMuted, fontSize: 12)),
                ),
              ),
            ],
          ),
        ),

        const Divider(height: 1),

        // List
        Expanded(
          child: exchangesAsync.when(
            loading: () => const LoadingShimmer(itemCount: 10),
            error: (err, _) => ErrorView(
              message: err.toString(),
              onRetry: () => ref.invalidate(exchangesListProvider),
            ),
            data: (exchanges) {
              return RefreshIndicator(
                onRefresh: () async => ref.invalidate(exchangesListProvider),
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: exchanges.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    return ExchangeRow(exchange: exchanges[index]);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTypeChip(
    BuildContext context,
    WidgetRef ref, {
    required ExchangeType type,
    required String label,
    required IconData icon,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () {
        ref.read(selectedExchangeTypeProvider.notifier).state = type;
      },
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.darkSurfaceElevated : AppColors.darkSurface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.darkBorder,
            width: isSelected ? 1.4 : 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15,
              color: isSelected ? AppColors.primary : AppColors.darkTextSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.darkTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
