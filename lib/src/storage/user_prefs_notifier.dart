import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/src/data/chart_time_range.dart';
import '/src/data/currency.dart';
import '/src/utils/shared_preferences_provider.dart';

part 'user_prefs_notifier.g.dart';

class UserPrefs {
  final Currency baseCurrency;
  final double amount;
  final List<Currency> targetCurrencies;
  final Currency chartBaseCurrency;
  final Currency chartTargetCurrency;
  final ChartTimeRange chartTimeRange;
  final int selectedTabIndex;

  const UserPrefs({
    required this.baseCurrency,
    required this.amount,
    required this.targetCurrencies,
    required this.chartBaseCurrency,
    required this.chartTargetCurrency,
    required this.chartTimeRange,
    required this.selectedTabIndex,
  });

  UserPrefs copyWith({
    Currency? baseCurrency,
    double? amount,
    List<Currency>? targetCurrencies,
    Currency? chartBaseCurrency,
    Currency? chartTargetCurrency,
    ChartTimeRange? chartTimeRange,
    int? selectedTabIndex,
  }) {
    return UserPrefs(
      baseCurrency: baseCurrency ?? this.baseCurrency,
      amount: amount ?? this.amount,
      targetCurrencies: targetCurrencies ?? this.targetCurrencies,
      chartBaseCurrency: chartBaseCurrency ?? this.chartBaseCurrency,
      chartTargetCurrency: chartTargetCurrency ?? this.chartTargetCurrency,
      chartTimeRange: chartTimeRange ?? this.chartTimeRange,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
    );
  }

  static const defaults = UserPrefs(
    baseCurrency: Currency.GBP,
    amount: 100.0,
    targetCurrencies: [Currency.EUR, Currency.USD, Currency.JPY],
    chartBaseCurrency: Currency.GBP,
    chartTargetCurrency: Currency.EUR,
    chartTimeRange: ChartTimeRange.oneYear,
    selectedTabIndex: 0,
  );
}

@riverpod
class UserPrefsNotifier extends _$UserPrefsNotifier {
  // Separate keys for each preference (public for testing)
  static const baseCurrencyKey = 'user_prefs/base_currency';
  static const amountKey = 'user_prefs/amount';
  static const targetCurrenciesKey = 'user_prefs/target_currencies';
  static const chartBaseCurrencyKey = 'user_prefs/chart_base_currency';
  static const chartTargetCurrencyKey = 'user_prefs/chart_target_currency';
  static const chartTimeRangeKey = 'user_prefs/chart_time_range';
  static const selectedTabIndexKey = 'user_prefs/selected_tab_index';

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

    final chartBaseCurrencyName = _prefs.getString(chartBaseCurrencyKey);
    final chartBaseCurrency = chartBaseCurrencyName != null
        ? Currency.values.byName(chartBaseCurrencyName)
        : UserPrefs.defaults.chartBaseCurrency;

    final chartTargetCurrencyName = _prefs.getString(chartTargetCurrencyKey);
    final chartTargetCurrency = chartTargetCurrencyName != null
        ? Currency.values.byName(chartTargetCurrencyName)
        : UserPrefs.defaults.chartTargetCurrency;

    final chartTimeRangeName = _prefs.getString(chartTimeRangeKey);
    final chartTimeRange = chartTimeRangeName != null
        ? ChartTimeRange.values.byName(chartTimeRangeName)
        : UserPrefs.defaults.chartTimeRange;

    final selectedTabIndex =
        _prefs.getInt(selectedTabIndexKey) ??
        UserPrefs.defaults.selectedTabIndex;

    return UserPrefs(
      baseCurrency: baseCurrency,
      amount: amount,
      targetCurrencies: targetCurrencies,
      chartBaseCurrency: chartBaseCurrency,
      chartTargetCurrency: chartTargetCurrency,
      chartTimeRange: chartTimeRange,
      selectedTabIndex: selectedTabIndex,
    );
  }

  void updateBaseCurrency(Currency currency) {
    state = state.copyWith(baseCurrency: currency);
    _prefs.setString(baseCurrencyKey, currency.name);
  }

  void updateAmount(double amount) {
    state = state.copyWith(amount: amount);
    _prefs.setDouble(amountKey, amount);
  }

  void updateTargetCurrencies(List<Currency> currencies) {
    state = state.copyWith(targetCurrencies: currencies);
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

  void updateChartBaseCurrency(Currency currency) {
    state = state.copyWith(chartBaseCurrency: currency);
    _prefs.setString(chartBaseCurrencyKey, currency.name);
  }

  void updateChartTargetCurrency(Currency currency) {
    state = state.copyWith(chartTargetCurrency: currency);
    _prefs.setString(chartTargetCurrencyKey, currency.name);
  }

  void updateChartTimeRange(ChartTimeRange range) {
    state = state.copyWith(chartTimeRange: range);
    _prefs.setString(chartTimeRangeKey, range.name);
  }

  void updateSelectedTabIndex(int index) {
    state = state.copyWith(selectedTabIndex: index);
    _prefs.setInt(selectedTabIndexKey, index);
  }
}
