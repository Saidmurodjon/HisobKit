import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String format(double amount, String currencyCode, {bool showSymbol = true}) {
    final symbols = {
      'UZS': "so'm",
      'USD': '\$',
      'EUR': '€',
      'RUB': '₽',
      'GBP': '£',
      'KZT': '₸',
    };

    final formatter = NumberFormat('#,##0.##', 'en_US');
    final formatted = formatter.format(amount);
    if (!showSymbol) return formatted;

    final symbol = symbols[currencyCode] ?? currencyCode;
    // For UZS, put symbol after amount
    if (currencyCode == 'UZS') return '$formatted $symbol';
    return '$symbol$formatted';
  }

  static String formatCompact(double amount, String currencyCode) {
    if (amount >= 1000000000) {
      return '${format(amount / 1000000000, currencyCode)}B';
    } else if (amount >= 1000000) {
      return '${format(amount / 1000000, currencyCode)}M';
    } else if (amount >= 1000) {
      return '${format(amount / 1000, currencyCode)}K';
    }
    return format(amount, currencyCode);
  }
}
