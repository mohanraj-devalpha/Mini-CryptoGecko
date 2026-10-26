import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../data/models/exchange.dart';
import 'trust_score_badge.dart';

class ExchangeRow extends StatelessWidget {
  final Exchange exchange;

  const ExchangeRow({super.key, required this.exchange});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Can open exchange url or details
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Rank Number
            SizedBox(
              width: 24,
              child: Text(
                '${exchange.rank}',
                style: const TextStyle(
                  color: AppColors.darkTextMuted,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(width: 8),

            // Logo & Name
            Expanded(
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: 32,
                      height: 32,
                      color: AppColors.darkSurfaceElevated,
                      child: exchange.imageUrl.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: exchange.imageUrl,
                              fit: BoxFit.cover,
                              errorWidget: (_, __, ___) => const Icon(
                                Icons.account_balance_rounded,
                                size: 18,
                                color: AppColors.darkTextMuted,
                              ),
                            )
                          : const Icon(
                              Icons.account_balance_rounded,
                              size: 18,
                              color: AppColors.darkTextMuted,
                            ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      exchange.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkTextPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // Reported Volume
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                CurrencyFormatter.formatVolume(exchange.volume24hBtc, symbol: '₿'),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkTextPrimary,
                ),
              ),
            ),

            // Trust Score
            SizedBox(
              width: 52,
              child: Align(
                alignment: Alignment.centerRight,
                child: TrustScoreBadge(score: exchange.trustScore),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
