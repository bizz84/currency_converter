import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/src/data/currency.dart';
import '/src/data/user_prefs.dart';
import '/src/utils/shared_preferences_provider.dart';

part 'user_prefs_notifier.g.dart';

@riverpod
class UserPrefsNotifier extends _$UserPrefsNotifier {
  // Separate keys for each preference
  static const _baseCurrencyKey = 'base_currency';
  static const _amountKey = 'amount';
  static const _targetCurrenciesKey = 'target_currencies';

  SharedPreferences get _prefs =>
      ref.watch(sharedPreferencesProvider).requireValue;

  @override
  UserPrefs build() {
    return _loadPreferences();
  }

  UserPrefs _loadPreferences() {
    // Load each preference separately with fallback to defaults
    final baseCurrencyName = _prefs.getString(_baseCurrencyKey);
    final baseCurrency = baseCurrencyName != null
        ? Currency.values.byName(baseCurrencyName)
        : UserPrefs.defaults.baseCurrency;

    final amount = _prefs.getDouble(_amountKey) ?? UserPrefs.defaults.amount;

    final targetCurrencyNames = _prefs.getStringList(_targetCurrenciesKey);
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
    _prefs.setString(_baseCurrencyKey, currency.name);
  }

  void updateAmount(double amount) {
    state = UserPrefs(
      baseCurrency: state.baseCurrency,
      amount: amount,
      targetCurrencies: state.targetCurrencies,
    );
    _prefs.setDouble(_amountKey, amount);
  }

  void updateTargetCurrencies(List<Currency> currencies) {
    state = UserPrefs(
      baseCurrency: state.baseCurrency,
      amount: state.amount,
      targetCurrencies: currencies,
    );
    _prefs.setStringList(
      _targetCurrenciesKey,
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