import 'package:currency_converter/src/data/currency.dart';
import 'package:currency_converter/src/storage/user_prefs_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('UserPrefsRepository', () {
    test('loads defaults when storage is empty', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final repo = UserPrefsRepository(prefs);

      expect(repo.loadBase(), Currency.GBP);
      expect(repo.loadAmount(), 100.0);
      expect(repo.loadTargets(), [Currency.EUR, Currency.USD, Currency.JPY]);
    });

    test('reads stored values, dedupes targets (keeps base if present)', () async {
      SharedPreferences.setMockInitialValues({
        'user_prefs/base_currency': 'USD',
        'user_prefs/target_currencies': <String>['GBP', 'EUR', 'USD', 'EUR'],
        'user_prefs/amount': 50.0,
      });
      final prefs = await SharedPreferences.getInstance();
      final repo = UserPrefsRepository(prefs);

      expect(repo.loadBase(), Currency.USD);
      expect(repo.loadAmount(), 50.0);
      expect(repo.loadTargets(base: Currency.USD), [Currency.GBP, Currency.EUR, Currency.USD]);
    });

    test('saves and loads back values', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final repo = UserPrefsRepository(prefs);

      await repo.saveBase(Currency.CHF);
      await repo.saveTargets([Currency.JPY, Currency.EUR, Currency.GBP]);
      await repo.saveAmount(42.5);

      expect(prefs.getString('user_prefs/base_currency'), 'CHF');
      expect(prefs.getStringList('user_prefs/target_currencies'), ['JPY', 'EUR', 'GBP']);
      expect(prefs.getDouble('user_prefs/amount'), 42.5);

      expect(repo.loadBase(), Currency.CHF);
      expect(repo.loadTargets(), [Currency.JPY, Currency.EUR, Currency.GBP]);
      expect(repo.loadAmount(), 42.5);
    });
  });
}

