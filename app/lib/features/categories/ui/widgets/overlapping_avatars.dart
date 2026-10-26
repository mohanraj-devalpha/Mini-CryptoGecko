import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class OverlappingAvatars extends StatelessWidget {
  final List<String> imageUrls;
  final double size;
  final double overlap;

  const OverlappingAvatars({
    super.key,
    required this.imageUrls,
    this.size = 20,
    this.overlap = 7,
  });

  @override
  Widget build(BuildContext context) {
    final urls = imageUrls.take(3).toList();
    if (urls.isEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: AppColors.darkSurfaceElevated,
          shape: BoxShape.circle,
        ),
      );
    }

    final totalWidth = size + (urls.length - 1) * (size - overlap);

    return SizedBox(
      width: totalWidth,
      height: size,
      child: Stack(
        children: [
          for (int i = 0; i < urls.length; i++)
            Positioned(
              left: i * (size - overlap),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.darkBg, width: 1.5),
                  color: AppColors.darkSurfaceElevated,
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: urls[i],
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => const Icon(
                      Icons.circle,
                      size: 10,
                      color: AppColors.darkTextMuted,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
