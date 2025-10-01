import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:currency_converter/src/storage/user_prefs_notifier.dart';
import 'package:currency_converter/src/utils/shared_preferences_provider.dart';
import 'package:currency_converter/src/data/currency.dart';

void main() {
  group('UserPrefsNotifier', () {
    late ProviderContainer container;

    setUp(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    tearDown(() {
      container.dispose();
    });

    test('loads saved preferences on initialization', () async {
      // Initialize with test values
      SharedPreferences.setMockInitialValues({
        UserPrefsNotifier.baseCurrencyKey: 'EUR',
        UserPrefsNotifier.amountKey: 50.0,
        UserPrefsNotifier.targetCurrenciesKey: ['USD', 'GBP'],
      });

      container = ProviderContainer();
      // Initialize SharedPreferences
      await container.read(sharedPreferencesProvider.future);

      final prefs = container.read(userPrefsProvider);
      expect(prefs.baseCurrency, Currency.EUR);
      expect(prefs.amount, 50.0);
      expect(prefs.targetCurrencies, [Currency.USD, Currency.GBP]);
    });

    test('falls back to defaults when no saved preferences', () async {
      SharedPreferences.setMockInitialValues({});

      container = ProviderContainer();
      await container.read(sharedPreferencesProvider.future);

      final prefs = container.read(userPrefsProvider);
      expect(prefs.baseCurrency, Currency.GBP);
      expect(prefs.amount, 100.0);
      expect(prefs.targetCurrencies, [
        Currency.EUR,
        Currency.USD,
        Currency.JPY,
      ]);
    });

    test('falls back to defaults for missing individual keys', () async {
      // Only set base_currency, others should use defaults
      SharedPreferences.setMockInitialValues({
        UserPrefsNotifier.baseCurrencyKey: 'CAD',
      });

      container = ProviderContainer();
      await container.read(sharedPreferencesProvider.future);

      final prefs = container.read(userPrefsProvider);
      expect(prefs.baseCurrency, Currency.CAD);
      expect(prefs.amount, 100.0); // default
      expect(prefs.targetCurrencies, [
        Currency.EUR,
        Currency.USD,
        Currency.JPY,
      ]); // default
    });

    test('updates base currency and persists to storage', () async {
      SharedPreferences.setMockInitialValues({});

      container = ProviderContainer();
      await container.read(sharedPreferencesProvider.future);

      container
          .read(userPrefsProvider.notifier)
          .updateBaseCurrency(Currency.JPY);

      final prefs = container.read(userPrefsProvider);
      expect(prefs.baseCurrency, Currency.JPY);

      final sharedPrefs = await SharedPreferences.getInstance();
      expect(sharedPrefs.getString(UserPrefsNotifier.baseCurrencyKey), 'JPY');
    });

    test('updates amount and persists to storage', () async {
      SharedPreferences.setMockInitialValues({});

      container = ProviderContainer();
      await container.read(sharedPreferencesProvider.future);

      container.read(userPrefsProvider.notifier).updateAmount(250.5);

      final prefs = container.read(userPrefsProvider);
      expect(prefs.amount, 250.5);

      final sharedPrefs = await SharedPreferences.getInstance();
      expect(sharedPrefs.getDouble(UserPrefsNotifier.amountKey), 250.5);
    });

    test('updates target currencies and persists to storage', () async {
      SharedPreferences.setMockInitialValues({});

      container = ProviderContainer();
      await container.read(sharedPreferencesProvider.future);

      final newCurrencies = [Currency.CAD, Currency.AUD, Currency.CHF];
      container
          .read(userPrefsProvider.notifier)
          .updateTargetCurrencies(newCurrencies);

      final prefs = container.read(userPrefsProvider);
      expect(prefs.targetCurrencies, newCurrencies);

      final sharedPrefs = await SharedPreferences.getInstance();
      expect(sharedPrefs.getStringList(UserPrefsNotifier.targetCurrenciesKey), [
        'CAD',
        'AUD',
        'CHF',
      ]);
    });

    test('adds target currency without duplicates', () async {
      SharedPreferences.setMockInitialValues({
        UserPrefsNotifier.targetCurrenciesKey: ['USD', 'GBP'],
      });

      container = ProviderContainer();
      await container.read(sharedPreferencesProvider.future);

      final notifier = container.read(userPrefsProvider.notifier);

      // Add new currency
      notifier.addTargetCurrency(Currency.JPY);
      expect(container.read(userPrefsProvider).targetCurrencies, [
        Currency.USD,
        Currency.GBP,
        Currency.JPY,
      ]);

      // Try adding duplicate - should not add
      notifier.addTargetCurrency(Currency.JPY);
      expect(container.read(userPrefsProvider).targetCurrencies, [
        Currency.USD,
        Currency.GBP,
        Currency.JPY,
      ]);

      // Verify persisted
      final sharedPrefs = await SharedPreferences.getInstance();
      expect(sharedPrefs.getStringList(UserPrefsNotifier.targetCurrenciesKey), [
        'USD',
        'GBP',
        'JPY',
      ]);
    });

    test('removes target currency', () async {
      SharedPreferences.setMockInitialValues({
        UserPrefsNotifier.targetCurrenciesKey: ['USD', 'GBP', 'JPY'],
      });

      container = ProviderContainer();
      await container.read(sharedPreferencesProvider.future);

      final notifier = container.read(userPrefsProvider.notifier);

      notifier.removeTargetCurrency(Currency.GBP);
      expect(container.read(userPrefsProvider).targetCurrencies, [
        Currency.USD,
        Currency.JPY,
      ]);

      // Verify persisted
      final sharedPrefs = await SharedPreferences.getInstance();
      expect(sharedPrefs.getStringList(UserPrefsNotifier.targetCurrenciesKey), ['USD', 'JPY']);
    });

    test('reorders target currencies correctly - move forward', () async {
      SharedPreferences.setMockInitialValues({
        UserPrefsNotifier.targetCurrenciesKey: ['EUR', 'USD', 'JPY'],
      });

      container = ProviderContainer();
      await container.read(sharedPreferencesProvider.future);

      // Move EUR from index 0 to index 2 (after JPY)
      container.read(userPrefsProvider.notifier).reorderTargetCurrencies(0, 3);

      expect(container.read(userPrefsProvider).targetCurrencies, [
        Currency.USD,
        Currency.JPY,
        Currency.EUR,
      ]);

      // Verify persisted
      final sharedPrefs = await SharedPreferences.getInstance();
      expect(sharedPrefs.getStringList(UserPrefsNotifier.targetCurrenciesKey), [
        'USD',
        'JPY',
        'EUR',
      ]);
    });

    test('reorders target currencies correctly - move backward', () async {
      SharedPreferences.setMockInitialValues({
        UserPrefsNotifier.targetCurrenciesKey: ['EUR', 'USD', 'JPY'],
      });

      container = ProviderContainer();
      await container.read(sharedPreferencesProvider.future);

      // Move JPY from index 2 to index 0 (before EUR)
      container.read(userPrefsProvider.notifier).reorderTargetCurrencies(2, 0);

      expect(container.read(userPrefsProvider).targetCurrencies, [
        Currency.JPY,
        Currency.EUR,
        Currency.USD,
      ]);

      // Verify persisted
      final sharedPrefs = await SharedPreferences.getInstance();
      expect(sharedPrefs.getStringList(UserPrefsNotifier.targetCurrenciesKey), [
        'JPY',
        'EUR',
        'USD',
      ]);
    });

    test('maintains other preferences when updating one', () async {
      SharedPreferences.setMockInitialValues({
        UserPrefsNotifier.baseCurrencyKey: 'EUR',
        UserPrefsNotifier.amountKey: 75.0,
        UserPrefsNotifier.targetCurrenciesKey: ['USD', 'GBP'],
      });

      container = ProviderContainer();
      await container.read(sharedPreferencesProvider.future);

      // Update only base currency
      container
          .read(userPrefsProvider.notifier)
          .updateBaseCurrency(Currency.CAD);

      final prefs = container.read(userPrefsProvider);
      expect(prefs.baseCurrency, Currency.CAD);
      expect(prefs.amount, 75.0); // unchanged
      expect(prefs.targetCurrencies, [Currency.USD, Currency.GBP]); // unchanged
    });
  });
}
