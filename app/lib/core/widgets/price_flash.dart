import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/formatters.dart';

class PriceFlashText extends StatefulWidget {
  final double price;
  final TextStyle? style;

  const PriceFlashText({
    super.key,
    required this.price,
    this.style,
  });

  @override
  State<PriceFlashText> createState() => _PriceFlashTextState();
}

class _PriceFlashTextState extends State<PriceFlashText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _colorAnimation = ColorTween(
      begin: Colors.transparent,
      end: Colors.transparent,
    ).animate(_controller);
  }

  @override
  void didUpdateWidget(covariant PriceFlashText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.price != oldWidget.price) {
      final isUp = widget.price > oldWidget.price;
      final flashColor = isUp ? AppColors.green : AppColors.red;

      _colorAnimation = ColorTween(
        begin: flashColor.withValues(alpha: 0.35),
        end: Colors.transparent,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
            color: _colorAnimation.value,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            Formatters.formatPrice(widget.price),
            style: widget.style ??
                const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
          ),
        );
      },
    );
  }
}
