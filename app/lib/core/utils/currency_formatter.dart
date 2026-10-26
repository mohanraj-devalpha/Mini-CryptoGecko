import 'package:intl/intl.dart';

class CurrencyFormatter {
  static const Map<String, String> _subscripts = {
    '0': '₀',
    '1': '₁',
    '2': '₂',
    '3': '₃',
    '4': '₄',
    '5': '₅',
    '6': '₆',
    '7': '₇',
    '8': '₈',
    '9': '₉',
  };

  /// Formats tiny crypto prices with subscript zero notation (e.g. ₿0.0₆2924).
  static String formatSubscriptPrice(double price, {String symbol = '₿'}) {
    if (price == 0) return '${symbol}0.00';
    if (price >= 1.0) {
      if (price >= 1000) {
        return '$symbol${NumberFormat("#,##0.00").format(price)}';
      }
      return '$symbol${price.toStringAsFixed(price >= 10 ? 2 : 4)}';
    }

    // Numbers between 0.01 and 1.0
    if (price >= 0.01) {
      return '$symbol${price.toStringAsFixed(4)}';
    }

    // Represent as plain fixed decimal without scientific notation
    final fixedStr = price.toStringAsFixed(12);
    final dotIndex = fixedStr.indexOf('.');
    if (dotIndex == -1) return '$symbol$price';

    final decimals = fixedStr.substring(dotIndex + 1);
    int zeroCount = 0;
    while (zeroCount < decimals.length && decimals[zeroCount] == '0') {
      zeroCount++;
    }

    // If 2 or fewer zeroes, format normally up to 6 decimals
    if (zeroCount < 2) {
      return '$symbol${price.toStringAsFixed(4)}';
    }

    // Convert zero count to subscript
    final subDigits = zeroCount.toString().split('').map((ch) => _subscripts[ch] ?? ch).join();
    final significant = decimals.substring(zeroCount);
    final displayDigits = significant.length > 4 ? significant.substring(0, 4) : significant;

    return '${symbol}0.0$subDigits$displayDigits';
  }

  /// Compact numbers: 11.38K, 20.09M, 524.14B, 2.323T
  static String formatCompact(double number, {String symbol = ''}) {
    if (number.abs() >= 1e12) {
      return '$symbol${(number / 1e12).toStringAsFixed(3)}T';
    } else if (number.abs() >= 1e9) {
      return '$symbol${(number / 1e9).toStringAsFixed(2)}B';
    } else if (number.abs() >= 1e6) {
      return '$symbol${(number / 1e6).toStringAsFixed(2)}M';
    } else if (number.abs() >= 1e3) {
      return '$symbol${(number / 1e3).toStringAsFixed(2)}K';
    } else {
      return '$symbol${NumberFormat("#,##0.##").format(number)}';
    }
  }

  /// Format volume in BTC or other units
  static String formatVolume(double amount, {String symbol = '₿'}) {
    if (amount >= 1000000) {
      return '$symbol${(amount / 1000000).toStringAsFixed(2)}M';
    } else if (amount >= 1000) {
      return '$symbol${(amount / 1000).toStringAsFixed(2)}K';
    } else {
      return '$symbol${NumberFormat("#,##0").format(amount)}';
    }
  }

  /// Percentage string: ▲ 0.3% or ▼ 0.1%
  static String formatPercent(double percent) {
    final absVal = percent.abs().toStringAsFixed(1);
    if (percent > 0) {
      return '▲ $absVal%';
    } else if (percent < 0) {
      return '▼ $absVal%';
    }
    return '0.0%';
  }
}
