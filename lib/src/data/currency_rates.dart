import 'currency.dart';

class CurrencyRates {
  CurrencyRates({
    required this.amount,
    required this.base,
    required this.date,
    required this.rates,
  });

  final double amount;
  final Currency base;
  final DateTime date;
  final Map<Currency, double> rates;

  factory CurrencyRates.fromFrankfurterApi(Map<String, dynamic> json) {
    final baseCode = json['base'] as String;
    final baseCurrency = Currency.from(baseCode);
    if (baseCurrency == null) {
      throw FormatException('Unknown base currency: $baseCode');
    }

    final rawRates = json['rates'] as Map<String, dynamic>;
    final Map<Currency, double> parsedRates = {};

    for (final entry in rawRates.entries) {
      final currency = Currency.from(entry.key);
      if (currency != null) {
        parsedRates[currency] = (entry.value as num).toDouble();
      }
    }

    return CurrencyRates(
      amount: (json['amount'] as num).toDouble(),
      base: baseCurrency,
      date: DateTime.parse(json['date'] as String),
      rates: parsedRates,
    );
  }

  /// Builds a CurrencyRates instance from a CurrencyAPI.com response shape.
  ///
  /// Expected input:
  /// {
  ///   "meta": {"last_updated_at": "2025-09-22T23:59:59Z"},
  ///   "data": {"EUR": {"code": "EUR", "value": 0.84}, ...}
  /// }
  factory CurrencyRates.fromCurrencyApi(
    Map<String, dynamic> json, {
    required Currency base,
    double amount = 1.0,
  }) {
    final meta = json['meta'] as Map<String, dynamic>?;
    final lastUpdatedAt = meta != null
        ? meta['last_updated_at'] as String?
        : null;
    final date = lastUpdatedAt != null
        ? DateTime.parse(lastUpdatedAt).toUtc()
        : DateTime.now().toUtc();

    final rawData = json['data'] as Map<String, dynamic>? ?? const {};
    final Map<Currency, double> parsedRates = {};

    for (final entry in rawData.entries) {
      final currency = Currency.from(entry.key);
      if (currency != null) {
        final value = ((entry.value as Map<String, dynamic>)['value'] as num).toDouble();
        parsedRates[currency] = value * amount;
      }
    }

    return CurrencyRates(
      amount: amount,
      base: base,
      date: date,
      rates: parsedRates,
    );
  }
}
