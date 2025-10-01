import 'package:currency_converter/src/data/currency_rates.dart';

extension CurrencyRatesTestX on CurrencyRates {
  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'base': base,
      'date': _formatYyyyMmDd(date),
      'rates': rates,
    };
  }

  String _formatYyyyMmDd(DateTime dt) {
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}

