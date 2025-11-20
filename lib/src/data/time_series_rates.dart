import 'currency.dart';

class TimeSeriesRates {
  TimeSeriesRates({
    required this.amount,
    required this.base,
    required this.startDate,
    required this.endDate,
    required this.rates,
  });

  final double amount;
  final Currency base;
  final String startDate;
  final String endDate;
  final Map<String, Map<Currency, double>> rates;

  factory TimeSeriesRates.fromJson(Map<String, dynamic> json) {
    final baseCode = json['base'] as String;
    final baseCurrency = Currency.from(baseCode);
    if (baseCurrency == null) {
      throw FormatException('Unknown base currency: $baseCode');
    }

    final rawRates = json['rates'] as Map<String, dynamic>;
    final Map<String, Map<Currency, double>> parsedRates = {};

    for (final dateEntry in rawRates.entries) {
      final date = dateEntry.key;
      final currencies = dateEntry.value as Map<String, dynamic>;
      final Map<Currency, double> currencyRates = {};

      for (final currencyEntry in currencies.entries) {
        final currency = Currency.from(currencyEntry.key);
        if (currency != null) {
          currencyRates[currency] = (currencyEntry.value as num).toDouble();
        }
      }

      if (currencyRates.isNotEmpty) {
        parsedRates[date] = currencyRates;
      }
    }

    return TimeSeriesRates(
      amount: (json['amount'] as num).toDouble(),
      base: baseCurrency,
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String,
      rates: parsedRates,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'base': base.name,
      'start_date': startDate,
      'end_date': endDate,
      'rates': {
        for (final dateEntry in rates.entries)
          dateEntry.key: {
            for (final currencyEntry in dateEntry.value.entries)
              currencyEntry.key.name: currencyEntry.value,
          },
      },
    };
  }
}
