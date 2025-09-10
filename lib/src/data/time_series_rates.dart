class TimeSeriesRates {
  TimeSeriesRates({
    required this.amount,
    required this.base,
    required this.startDate,
    required this.endDate,
    required this.rates,
  });

  final double amount;
  final String base;
  final String startDate;
  final String endDate;
  final Map<String, Map<String, double>> rates;

  factory TimeSeriesRates.fromJson(Map<String, dynamic> json) {
    return TimeSeriesRates(
      amount: (json['amount'] as num).toDouble(),
      base: json['base'] as String,
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String,
      rates: (json['rates'] as Map<String, dynamic>).map(
        (date, currencies) => MapEntry(
          date,
          (currencies as Map<String, dynamic>).map(
            (currency, value) => MapEntry(currency, (value as num).toDouble()),
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'base': base,
      'start_date': startDate,
      'end_date': endDate,
      'rates': rates,
    };
  }
}