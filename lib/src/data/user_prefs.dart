import '/src/data/currency.dart';

class UserPrefs {
  final Currency baseCurrency;
  final double amount;
  final List<Currency> targetCurrencies;

  const UserPrefs({
    required this.baseCurrency,
    required this.amount,
    required this.targetCurrencies,
  });

  static const defaults = UserPrefs(
    baseCurrency: Currency.GBP,
    amount: 100.0,
    targetCurrencies: [Currency.EUR, Currency.USD, Currency.JPY],
  );
}