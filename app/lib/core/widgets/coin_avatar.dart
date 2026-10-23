import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CoinAvatar extends StatelessWidget {
  final String? imageUrl;
  final String symbol;
  final double size;

  const CoinAvatar({
    super.key,
    required this.imageUrl,
    required this.symbol,
    this.size = 36,
  });

  Color _generateColor(String text) {
    int hash = 0;
    for (int i = 0; i < text.length; i++) {
      hash = text.codeUnitAt(i) + ((hash << 5) - hash);
    }
    final hue = (hash % 360).abs().toDouble();
    return HSLColor.fromAHSL(1.0, hue, 0.65, 0.50).toColor();
  }

  Widget _buildFallback() {
    final bg = _generateColor(symbol);
    final letter = symbol.isNotEmpty ? symbol.substring(0, 1).toUpperCase() : '?';

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bg.withValues(alpha: 0.2),
        shape: BoxShape.circle,
        border: Border.all(color: bg.withValues(alpha: 0.6), width: 1.5),
      ),
      child: Center(
        child: Text(
          letter,
          style: TextStyle(
            color: bg,
            fontWeight: FontWeight.bold,
            fontSize: size * 0.44,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildFallback();
    }

    return CachedNetworkImage(
      imageUrl: imageUrl!,
      width: size,
      height: size,
      imageBuilder: (context, imageProvider) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
      placeholder: (context, url) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
      ),
      errorWidget: (context, url, error) => _buildFallback(),
    );
  }
}
