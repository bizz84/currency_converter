import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:currency_converter/src/app.dart';
import 'package:currency_converter/src/utils/shared_preferences_provider.dart';
import 'package:currency_converter/src/screens/convert/amount_input_field.dart';
import 'package:currency_converter/src/storage/user_prefs_notifier.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:dio/dio.dart';
import 'package:currency_converter/src/utils/dio_provider.dart';

void main() {
  group('ConvertScreen persistence', () {
    late DioAdapter dioAdapter;
    late ProviderContainer container;

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    tearDown(() {
      container.dispose();
    });

    // Helper to set up mock API responses
    void setupMockApi(DioAdapter adapter) {
      // Mock latest rates endpoint for GBP
      adapter.onGet(
        '/latest',
        (server) => server.reply(200, {
          'amount': 1.0,
          'base': 'GBP',
          'date': '2024-01-01',
          'rates': {
            'EUR': 1.17,
            'USD': 1.27,
            'JPY': 180.5,
            'CAD': 1.68,
            'AUD': 1.87,
            'CHF': 1.09,
          },
        }),
        queryParameters: {'from': 'GBP'},
      );

      // Mock latest rates endpoint for EUR
      adapter.onGet(
        '/latest',
        (server) => server.reply(200, {
          'amount': 1.0,
          'base': 'EUR',
          'date': '2024-01-01',
          'rates': {
            'GBP': 0.85,
            'USD': 1.08,
            'JPY': 154.2,
            'CAD': 1.44,
            'AUD': 1.60,
            'CHF': 0.93,
          },
        }),
        queryParameters: {'from': 'EUR'},
      );

      // Mock currencies endpoint
      adapter.onGet(
        '/currencies',
        (server) => server.reply(200, {
          'EUR': 'Euro',
          'USD': 'United States Dollar',
          'GBP': 'British Pound',
          'JPY': 'Japanese Yen',
          'CAD': 'Canadian Dollar',
          'AUD': 'Australian Dollar',
          'CHF': 'Swiss Franc',
          'SEK': 'Swedish Krona',
          'NZD': 'New Zealand Dollar',
        }),
      );
    }

    testWidgets('restores saved preferences on app start', (tester) async {
      // Set up saved preferences
      SharedPreferences.setMockInitialValues({
        UserPrefsNotifier.baseCurrencyKey: 'EUR',
        UserPrefsNotifier.amountKey: 250.0,
        UserPrefsNotifier.targetCurrenciesKey: ['JPY', 'CAD', 'AUD'],
      });

      // Set up the mock Dio adapter BEFORE creating the container
      final dio = Dio();
      dioAdapter = DioAdapter(dio: dio);
      setupMockApi(dioAdapter);

      container = ProviderContainer(
        overrides: [
          dioProvider.overrideWithValue(dio),
        ],
      );

      await container.read(sharedPreferencesProvider.future);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: CurrencyConverterApp(),
          ),
        ),
      );

      // Wait for the screen to load
      await tester.pumpAndSettle();

      // Verify base currency is EUR (in the base currency selector)
      expect(find.text('EUR'), findsWidgets);

      // Verify amount is 250.0 in the amount input field
      final amountField = find.byType(AmountInputField);
      expect(amountField, findsOneWidget);
      final amountWidget = tester.widget<AmountInputField>(amountField);
      expect(amountWidget.initialAmount, 250.0);

      // Verify target currencies are displayed
      expect(find.text('JPY'), findsOneWidget);
      expect(find.text('CAD'), findsOneWidget);
      expect(find.text('AUD'), findsOneWidget);

      // Verify default currencies are not displayed
      expect(find.text('USD'), findsNothing);
    });

    testWidgets('uses default preferences when none saved', (tester) async {
      // No saved preferences
      SharedPreferences.setMockInitialValues({});

      // Set up the mock Dio adapter BEFORE creating the container
      final dio = Dio();
      dioAdapter = DioAdapter(dio: dio);
      setupMockApi(dioAdapter);

      container = ProviderContainer(
        overrides: [
          dioProvider.overrideWithValue(dio),
        ],
      );

      await container.read(sharedPreferencesProvider.future);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: CurrencyConverterApp(),
          ),
        ),
      );

      // Wait for the screen to load
      await tester.pumpAndSettle();

      // Verify default base currency is GBP
      expect(find.text('GBP'), findsWidgets);

      // Verify default amount is 100.0
      final amountField = find.byType(AmountInputField);
      final amountWidget = tester.widget<AmountInputField>(amountField);
      expect(amountWidget.initialAmount, 100.0);

      // Verify default target currencies
      expect(find.text('EUR'), findsOneWidget);
      expect(find.text('USD'), findsOneWidget);
      expect(find.text('JPY'), findsOneWidget);
    });

    testWidgets('persists adding a new target currency', (tester) async {
      SharedPreferences.setMockInitialValues({
        UserPrefsNotifier.baseCurrencyKey: 'GBP',
        UserPrefsNotifier.amountKey: 100.0,
        UserPrefsNotifier.targetCurrenciesKey: ['EUR'],
      });

      // Set up the mock Dio adapter BEFORE creating the container
      final dio = Dio();
      dioAdapter = DioAdapter(dio: dio);
      setupMockApi(dioAdapter);

      container = ProviderContainer(
        overrides: [
          dioProvider.overrideWithValue(dio),
        ],
      );

      await container.read(sharedPreferencesProvider.future);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: CurrencyConverterApp(),
          ),
        ),
      );

      // Wait for the screen to load
      await tester.pumpAndSettle();

      // Initially only EUR is shown as target
      expect(find.text('EUR'), findsOneWidget);
      expect(find.text('USD'), findsNothing);

      // Tap the FAB to add a currency
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Select USD from the picker
      await tester.tap(find.text('USD').last);
      await tester.pumpAndSettle();

      // Verify USD is now displayed
      expect(find.text('USD'), findsOneWidget);

      // Verify it was persisted
      final prefs = await SharedPreferences.getInstance();
      final savedCurrencies = prefs.getStringList(UserPrefsNotifier.targetCurrenciesKey);
      expect(savedCurrencies, contains('USD'));
      expect(savedCurrencies, contains('EUR'));
    });

    testWidgets('persists removing a target currency', (tester) async {
      SharedPreferences.setMockInitialValues({
        UserPrefsNotifier.baseCurrencyKey: 'GBP',
        UserPrefsNotifier.amountKey: 100.0,
        UserPrefsNotifier.targetCurrenciesKey: ['EUR', 'USD', 'JPY'],
      });

      // Set up the mock Dio adapter BEFORE creating the container
      final dio = Dio();
      dioAdapter = DioAdapter(dio: dio);
      setupMockApi(dioAdapter);

      container = ProviderContainer(
        overrides: [
          dioProvider.overrideWithValue(dio),
        ],
      );

      await container.read(sharedPreferencesProvider.future);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: CurrencyConverterApp(),
          ),
        ),
      );

      // Wait for the screen to load
      await tester.pumpAndSettle();

      // Verify all three currencies are displayed
      expect(find.text('EUR'), findsOneWidget);
      expect(find.text('USD'), findsOneWidget);
      expect(find.text('JPY'), findsOneWidget);

      // Swipe to dismiss the USD tile
      final usdTile = find.text('USD');
      await tester.drag(usdTile, const Offset(-500.0, 0.0));
      await tester.pumpAndSettle();

      // Verify USD is removed
      expect(find.text('USD'), findsNothing);
      expect(find.text('EUR'), findsOneWidget);
      expect(find.text('JPY'), findsOneWidget);

      // Verify it was persisted
      final prefs = await SharedPreferences.getInstance();
      final savedCurrencies = prefs.getStringList(UserPrefsNotifier.targetCurrenciesKey);
      expect(savedCurrencies, isNot(contains('USD')));
      expect(savedCurrencies, contains('EUR'));
      expect(savedCurrencies, contains('JPY'));
    });

    testWidgets('persists amount changes', (tester) async {
      SharedPreferences.setMockInitialValues({
        UserPrefsNotifier.baseCurrencyKey: 'GBP',
        UserPrefsNotifier.amountKey: 100.0,
        UserPrefsNotifier.targetCurrenciesKey: ['EUR'],
      });

      // Set up the mock Dio adapter BEFORE creating the container
      final dio = Dio();
      dioAdapter = DioAdapter(dio: dio);
      setupMockApi(dioAdapter);

      container = ProviderContainer(
        overrides: [
          dioProvider.overrideWithValue(dio),
        ],
      );

      await container.read(sharedPreferencesProvider.future);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: CurrencyConverterApp(),
          ),
        ),
      );

      // Wait for the screen to load
      await tester.pumpAndSettle();

      // Find the amount input field
      final amountField = find.byType(AmountInputField);
      expect(amountField, findsOneWidget);

      // Find the actual TextField inside AmountInputField
      final textField = find.descendant(
        of: amountField,
        matching: find.byType(TextField),
      );
      expect(textField, findsOneWidget);

      // Clear and enter new amount
      await tester.tap(textField);
      await tester.pumpAndSettle();

      // Enter new amount
      await tester.enterText(textField, '500');
      await tester.pumpAndSettle();

      // Unfocus to trigger save
      await tester.tap(find.text('Currency Converter'));
      await tester.pumpAndSettle();

      // Verify it was persisted
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getDouble(UserPrefsNotifier.amountKey), 500.0);
    });
  });
}