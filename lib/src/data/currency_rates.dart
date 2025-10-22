class CurrencyRates {
  CurrencyRates({
    required this.amount,
    required this.base,
    required this.date,
    required this.rates,
  });

  final double amount;
  // TODO: Change to Currency
  final String base;
  final DateTime date;
  // TODO: Change to Currency
  final Map<String, double> rates;

  factory CurrencyRates.fromFrankfurterApi(Map<String, dynamic> json) {
    return CurrencyRates(
      amount: (json['amount'] as num).toDouble(),
      base: json['base'] as String,
      date: DateTime.parse(json['date'] as String),
      rates: (json['rates'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, (value as num).toDouble()),
      ),
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
    required String base,
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
    final Map<String, double> flattenedRates = {
      for (final entry in rawData.entries)
        entry.key: ((entry.value as Map<String, dynamic>)['value'] as num)
            .toDouble(),
    };

    final Map<String, double> adjustedRates = {
      for (final e in flattenedRates.entries) e.key: e.value * amount,
    };

    return CurrencyRates(
      amount: amount,
      base: base,
      date: date,
      rates: adjustedRates,
    );
  }
}
