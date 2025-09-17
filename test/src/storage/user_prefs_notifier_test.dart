import 'package:currency_converter/src/data/currency.dart';
import 'package:currency_converter/src/storage/user_prefs_notifier.dart';
import 'package:currency_converter/src/utils/shared_preferences_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  ProviderContainer makeContainer() => ProviderContainer();

  Future<ProviderContainer> initContainerWithPrefs(
    Map<String, Object> values,
  ) async {
    SharedPreferences.setMockInitialValues(values);
    final container = makeContainer();
    await container.read(sharedPreferencesProvider.future);
    return container;
  }

  group('UserPrefsNotifier', () {
    test('build loads initial state from repository', () async {
      final container = await initContainerWithPrefs({
        'user_prefs/base_currency': 'USD',
        'user_prefs/target_currencies': <String>['GBP', 'EUR'],
        'user_prefs/amount': 12.0,
      });

      final state = container.read(userPrefsProvider);
      expect(state.baseCurrency, Currency.USD);
      expect(state.amount, 12.0);
      expect(state.targetCurrencies, [Currency.GBP, Currency.EUR]);
    });

    test('setBase updates state and persists', () async {
      final container = await initContainerWithPrefs({});
      final notifier = container.read(userPrefsProvider.notifier);

      await notifier.setBase(Currency.JPY);
      expect(container.read(userPrefsProvider).baseCurrency, Currency.JPY);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('user_prefs/base_currency'), 'JPY');
    });

    test('setAmount updates state and persists', () async {
      final container = await initContainerWithPrefs({});
      final notifier = container.read(userPrefsProvider.notifier);

      await notifier.setAmount(77.7);
      expect(container.read(userPrefsProvider).amount, 77.7);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getDouble('user_prefs/amount'), 77.7);
    });

    test('add/remove/reorder targets updates state and persists', () async {
      final container = await initContainerWithPrefs({
        // start with no targets to avoid defaults [EUR, USD, JPY]
        'user_prefs/target_currencies': <String>[],
      });
      final notifier = container.read(userPrefsProvider.notifier);

      await notifier.addTarget(Currency.USD);
      await notifier.addTarget(Currency.EUR);
      expect(container.read(userPrefsProvider).targetCurrencies, [
        Currency.USD,
        Currency.EUR,
      ]);

      // Reorder: move EUR (index 1) to index 0
      await notifier.reorderTargets(1, 0);
      expect(container.read(userPrefsProvider).targetCurrencies, [
        Currency.EUR,
        Currency.USD,
      ]);

      // Remove
      await notifier.removeTarget(Currency.EUR);
      expect(container.read(userPrefsProvider).targetCurrencies, [
        Currency.USD,
      ]);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getStringList('user_prefs/target_currencies'), ['USD']);
    });
  });
}
