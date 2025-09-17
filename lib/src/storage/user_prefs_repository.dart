import 'package:currency_converter/src/data/currency.dart';
import 'package:currency_converter/src/utils/shared_preferences_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'user_prefs_repository.g.dart';

class UserPrefsRepository {
  const UserPrefsRepository(this._prefs);

  final SharedPreferences _prefs;
  static const _kBase = 'user_prefs/base_currency';
  static const _kTargets = 'user_prefs/target_currencies';
  static const _kAmount = 'user_prefs/amount';

  static const Currency _defaultBase = Currency.GBP;
  static const List<Currency> _defaultTargets = [
    Currency.EUR,
    Currency.USD,
    Currency.JPY,
  ];
  static const double _defaultAmount = 100.0;

  Currency loadBase() {
    final code = _prefs.getString(_kBase);
    return Currency.from(code ?? '') ?? _defaultBase;
  }

  Future<void> saveBase(Currency base) async {
    await _prefs.setString(_kBase, base.name);
  }

  List<Currency> loadTargets({Currency? base}) {
    final codes = _prefs.getStringList(_kTargets);
    final list = (codes ?? _defaultTargets.map((c) => c.name).toList())
        .map((c) => Currency.from(c))
        .whereType<Currency>()
        .toList();
    // Dedupe preserving order
    final seen = <Currency>{};
    final deduped = <Currency>[];
    for (final c in list) {
      if (seen.add(c)) deduped.add(c);
    }
    return deduped;
  }

  Future<void> saveTargets(List<Currency> targets) async {
    final codes = targets.map((c) => c.name).toList();
    await _prefs.setStringList(_kTargets, codes);
  }

  double loadAmount() {
    return _prefs.getDouble(_kAmount) ?? _defaultAmount;
  }

  Future<void> saveAmount(double amount) async {
    await _prefs.setDouble(_kAmount, amount);
  }
}

@riverpod
UserPrefsRepository userPrefsRepository(Ref ref) {
  final prefs = ref.watch(sharedPreferencesProvider).requireValue;
  return UserPrefsRepository(prefs);
}
