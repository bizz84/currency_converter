import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/src/data/currency.dart';
import '/src/utils/shared_preferences_provider.dart';

part 'recent_currencies_storage.g.dart';

@riverpod
class RecentCurrenciesStorage extends _$RecentCurrenciesStorage {
  // Public for testing
  static const recentCurrenciesKey = 'recent_currencies/mru_list';
  static const maxRecentCurrencies = 10;

  SharedPreferences get _prefs =>
      ref.watch(sharedPreferencesProvider).requireValue;

  @override
  List<Currency> build() {
    final currencyNames = _prefs.getStringList(recentCurrenciesKey);
    if (currencyNames == null) {
      return [];
    }
    return currencyNames
        .map((name) {
          try {
            return Currency.values.byName(name);
          } catch (e) {
            // Invalid currency name, skip it
            return null;
          }
        })
        .whereType<Currency>()
        .toList();
  }

  void addCurrency(Currency currency) {
    // Remove if already exists
    final currencies = state.where((c) => c != currency).toList();
    // Add to front (most recently used)
    currencies.insert(0, currency);
    // Limit to max size
    if (currencies.length > maxRecentCurrencies) {
      currencies.removeRange(maxRecentCurrencies, currencies.length);
    }
    state = currencies;
    _prefs.setStringList(
      recentCurrenciesKey,
      currencies.map((c) => c.name).toList(),
    );
  }

  void clear() {
    state = [];
    _prefs.remove(recentCurrenciesKey);
  }
}
