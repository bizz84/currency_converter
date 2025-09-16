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
  final String date;
  // TODO: Change to Currency
  final Map<String, double> rates;

  /// Parses the date string (yyyy-mm-dd format) from the API into a DateTime
  DateTime get dateTime => DateTime.parse(date);

  factory CurrencyRates.fromJson(Map<String, dynamic> json) {
    return CurrencyRates(
      amount: (json['amount'] as num).toDouble(),
      base: json['base'] as String,
      date: json['date'] as String,
      rates: (json['rates'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, (value as num).toDouble()),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'base': base,
      'date': date,
      'rates': rates,
    };
  }
}
