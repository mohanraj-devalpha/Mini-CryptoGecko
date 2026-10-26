import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../data/models/nft_collection.dart';

class NftRow extends StatelessWidget {
  final NftCollection nft;

  const NftRow({super.key, required this.nft});

  @override
  Widget build(BuildContext context) {
    final isNegative = nft.change24hPct < 0;
    final changeColor = isNegative ? AppColors.red : AppColors.green;

    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Thumbnail & Name
            Expanded(
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 34,
                      height: 34,
                      color: AppColors.darkSurfaceElevated,
                      child: nft.imageUrl.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: nft.imageUrl,
                              fit: BoxFit.cover,
                              errorWidget: (_, __, ___) => const Icon(
                                Icons.image_outlined,
                                size: 18,
                                color: AppColors.darkTextMuted,
                              ),
                            )
                          : const Icon(
                              Icons.image_outlined,
                              size: 18,
                              color: AppColors.darkTextMuted,
                            ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      nft.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkTextPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // Floor Price & 24h %
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${nft.currency}${nft.floorPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    CurrencyFormatter.formatPercent(nft.change24hPct),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: changeColor,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Market Cap
            SizedBox(
              width: 90,
              child: Text(
                '${nft.currency}${CurrencyFormatter.formatCompact(nft.marketCap)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkTextPrimary,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
