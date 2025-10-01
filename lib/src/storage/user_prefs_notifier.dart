import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/src/data/currency.dart';
import '/src/utils/shared_preferences_provider.dart';

part 'user_prefs_notifier.g.dart';

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

@riverpod
class UserPrefsNotifier extends _$UserPrefsNotifier {
  // Separate keys for each preference (public for testing)
  static const baseCurrencyKey = 'user_prefs/base_currency';
  static const amountKey = 'user_prefs/amount';
  static const targetCurrenciesKey = 'user_prefs/target_currencies';

  SharedPreferences get _prefs =>
      ref.watch(sharedPreferencesProvider).requireValue;

  @override
  UserPrefs build() {
    // Load each preference separately with fallback to defaults
    final baseCurrencyName = _prefs.getString(baseCurrencyKey);
    final baseCurrency = baseCurrencyName != null
        ? Currency.values.byName(baseCurrencyName)
        : UserPrefs.defaults.baseCurrency;

    final amount = _prefs.getDouble(amountKey) ?? UserPrefs.defaults.amount;

    final targetCurrencyNames = _prefs.getStringList(targetCurrenciesKey);
    final targetCurrencies = targetCurrencyNames != null
        ? targetCurrencyNames
              .map((name) => Currency.values.byName(name))
              .toList()
        : UserPrefs.defaults.targetCurrencies;

    return UserPrefs(
      baseCurrency: baseCurrency,
      amount: amount,
      targetCurrencies: targetCurrencies,
    );
  }

  void updateBaseCurrency(Currency currency) {
    state = UserPrefs(
      baseCurrency: currency,
      amount: state.amount,
      targetCurrencies: state.targetCurrencies,
    );
    _prefs.setString(baseCurrencyKey, currency.name);
  }

  void updateAmount(double amount) {
    state = UserPrefs(
      baseCurrency: state.baseCurrency,
      amount: amount,
      targetCurrencies: state.targetCurrencies,
    );
    _prefs.setDouble(amountKey, amount);
  }

  void updateTargetCurrencies(List<Currency> currencies) {
    state = UserPrefs(
      baseCurrency: state.baseCurrency,
      amount: state.amount,
      targetCurrencies: currencies,
    );
    _prefs.setStringList(
      targetCurrenciesKey,
      currencies.map((c) => c.name).toList(),
    );
  }

  void addTargetCurrency(Currency currency) {
    if (!state.targetCurrencies.contains(currency)) {
      updateTargetCurrencies([...state.targetCurrencies, currency]);
    }
  }

  void removeTargetCurrency(Currency currency) {
    updateTargetCurrencies(
      state.targetCurrencies.where((c) => c != currency).toList(),
    );
  }

  void reorderTargetCurrencies(int oldIndex, int newIndex) {
    final currencies = [...state.targetCurrencies];
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final currency = currencies.removeAt(oldIndex);
    currencies.insert(newIndex, currency);
    updateTargetCurrencies(currencies);
  }
}
