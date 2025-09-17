import 'package:currency_converter/src/data/currency.dart';
import 'package:currency_converter/src/data/currency_rates.dart';
import 'package:currency_converter/src/network/frankfurter_client.dart';
import 'package:currency_converter/src/screens/convert/convert_screen.dart';
import 'package:currency_converter/src/utils/shared_preferences_provider.dart';
import 'package:currency_converter/src/screens/convert/exchange_rates_error.dart';
import 'package:currency_converter/src/storage/user_prefs_notifier.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeFrankfurterClient extends FrankfurterClient {
  FakeFrankfurterClient(this.dates) : super(dio: Dio());
  final Map<Currency, String> dates;

  @override
  Future<CurrencyRates> getLatestRates({
    required Currency base,
    List<Currency>? to,
    double? amount,
  }) async {
    return CurrencyRates(
      amount: amount ?? 1.0,
      base: base.name,
      date: dates[base] ?? '2024-01-01',
      rates: {
        'EUR': 1.1,
        'GBP': 0.8,
      },
    );
  }
}

class ErrorFrankfurterClient extends FrankfurterClient {
  ErrorFrankfurterClient() : super(dio: Dio());
  @override
  Future<CurrencyRates> getLatestRates({
    required Currency base,
    List<Currency>? to,
    double? amount,
  }) async {
    throw Exception('Network error');
  }
}

Future<ProviderContainer> _initContainerWithPrefs(
  Map<String, Object> values,
) async {
  SharedPreferences.setMockInitialValues(values);
  final container = ProviderContainer();
  await container.read(sharedPreferencesProvider.future);
  return container;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Changing base persists and refreshes rates', (tester) async {
    final container = await _initContainerWithPrefs({
      'user_prefs/base_currency': 'USD',
      'user_prefs/target_currencies': <String>['GBP', 'EUR'],
      'user_prefs/amount': 100.0,
    });

    final fakeClient = FakeFrankfurterClient({
      Currency.USD: '2024-01-01',
      Currency.GBP: '2024-02-02',
    });

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: ProviderContainer(
          overrides: [
            frankfurterClientProvider.overrideWithValue(fakeClient),
          ],
          parent: container,
        ),
        child: const MaterialApp(home: ConvertScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Last updated: 1 Jan 2024'), findsOneWidget);

    // Change base to GBP
    await container.read(userPrefsProvider.notifier).setBase(Currency.GBP);
    await tester.pumpAndSettle();

    expect(find.textContaining('Last updated: 2 Feb 2024'), findsOneWidget);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('user_prefs/base_currency'), 'GBP');
  }, skip: true);

  testWidgets('Error state is shown when latest rates fail', (tester) async {
    final container = await _initContainerWithPrefs({
      'user_prefs/base_currency': 'USD',
    });

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: ProviderContainer(
          overrides: [
            frankfurterClientProvider.overrideWithValue(
              ErrorFrankfurterClient(),
            ),
          ],
          parent: container,
        ),
        child: const MaterialApp(home: ConvertScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ExchangeRatesError), findsOneWidget);
  }, skip: true);

  testWidgets('Base currency can appear in targets and shows 1.0000 rate', (
    tester,
  ) async {
    final container = await _initContainerWithPrefs({
      'user_prefs/base_currency': 'USD',
      'user_prefs/target_currencies': <String>['USD', 'EUR'],
      'user_prefs/amount': 50.0,
    });

    final fakeClient = FakeFrankfurterClient({
      Currency.USD: '2024-03-03',
    });

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: ProviderContainer(
          overrides: [
            frankfurterClientProvider.overrideWithValue(fakeClient),
          ],
          parent: container,
        ),
        child: const MaterialApp(home: ConvertScreen()),
      ),
    );
    await tester.pumpAndSettle();

    // Assert a line shows "1 USD = 1.0000 USD" for the USD tile
    expect(find.textContaining('1 USD = 1.0000 USD'), findsOneWidget);
  }, skip: true);
}
