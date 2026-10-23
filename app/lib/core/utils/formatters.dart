import 'package:intl/intl.dart';

class Formatters {
  static final _numberFormat = NumberFormat('#,##0.00');

  /// Formats cryptocurrency price with adaptive decimals for small prices.
  static String formatPrice(double price) {
    if (price >= 1000) {
      return '\$${_numberFormat.format(price)}';
    } else if (price >= 1.0) {
      return '\$${price.toStringAsFixed(2)}';
    } else if (price >= 0.01) {
      return '\$${price.toStringAsFixed(4)}';
    } else if (price >= 0.0001) {
      return '\$${price.toStringAsFixed(6)}';
    } else {
      return '\$${price.toStringAsFixed(8)}';
    }
  }

  /// Compact currency format: $1.24T, $34.5B, $812M, $45.2K
  static String formatCompactCurrency(double value) {
    final abs = value.abs();
    if (abs >= 1e12) {
      return '\$${(value / 1e12).toStringAsFixed(2)}T';
    } else if (abs >= 1e9) {
      return '\$${(value / 1e9).toStringAsFixed(2)}B';
    } else if (abs >= 1e6) {
      return '\$${(value / 1e6).toStringAsFixed(2)}M';
    } else if (abs >= 1e3) {
      return '\$${(value / 1e3).toStringAsFixed(2)}K';
    } else {
      return formatPrice(value);
    }
  }

  /// Compact number format without dollar sign (e.g. for coin supplies).
  static String formatCompactNumber(double value) {
    final abs = value.abs();
    if (abs >= 1e12) {
      return '${(value / 1e12).toStringAsFixed(2)}T';
    } else if (abs >= 1e9) {
      return '${(value / 1e9).toStringAsFixed(2)}B';
    } else if (abs >= 1e6) {
      return '${(value / 1e6).toStringAsFixed(2)}M';
    } else if (abs >= 1e3) {
      return '${(value / 1e3).toStringAsFixed(2)}K';
    } else {
      return value.toStringAsFixed(0);
    }
  }

  /// Formats 24h percentage with sign: +2.45% or -1.20%
  static String formatPercentage(double pct) {
    final sign = pct > 0 ? '+' : '';
    return '$sign${pct.toStringAsFixed(2)}%';
  }

  /// Date format: Oct 23, 2026
  static String formatDate(DateTime dt) {
    return DateFormat('MMM d, y').format(dt.toLocal());
  }

  /// Date & time format: Oct 23, 2026 11:45 AM
  static String formatDateTime(DateTime dt) {
    return DateFormat('MMM d, y h:mm a').format(dt.toLocal());
  }

  /// Short chart tooltip time: Oct 23, 11:45
  static String formatChartTooltip(DateTime dt) {
    return DateFormat('MMM d, HH:mm').format(dt.toLocal());
  }
}
