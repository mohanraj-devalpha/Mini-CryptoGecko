import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../coins/ui/cryptocurrency_tab.dart';
import 'widgets/coingecko_header.dart';

class MarketsHomeScreen extends StatelessWidget {
  const MarketsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: SafeArea(
        child: Column(
          children: const [
            CoinGeckoHeader(),
            Expanded(
              child: CryptocurrencyTab(),
            ),
          ],
        ),
      ),
    );
  }
}
