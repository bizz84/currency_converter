import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:currency_converter/src/app.dart';
import 'package:currency_converter/src/theme/app_theme.dart';
import 'package:currency_converter/src/screens/charts/charts_screen.dart';
import 'package:currency_converter/src/screens/convert/convert_screen.dart';
import 'package:currency_converter/src/storage/user_prefs_notifier.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:dio/dio.dart';
import 'package:currency_converter/src/utils/dio_provider.dart';
import 'package:currency_converter/src/data/currency.dart';
import '../../../helpers/test_container_factory.dart';
import '../../../helpers/mock_api_helpers.dart';

void main() {
  group('ChartsScreen persistence', () {
    late DioAdapter dioAdapter;
    late ProviderContainer container;

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('restores saved chart preferences on app start',
        (tester) async {
      // Set up the mock Dio adapter
      final dio = Dio();
      dioAdapter = DioAdapter(dio: dio);
      setupMockLatestRates(dioAdapter, Currency.GBP);
      setupMockTimeSeriesRates(
        dioAdapter,
        Currency.USD,
        Currency.JPY,
        '2024-01-01',
        '2024-12-31',
      );
      setupMockCurrencies(dioAdapter);

      // Create container with saved chart preferences
      container = await createTestContainer(
        mockPreferences: {
          UserPrefsNotifier.chartBaseCurrencyKey: 'USD',
          UserPrefsNotifier.chartTargetCurrencyKey: 'JPY',
          UserPrefsNotifier.chartTimeRangeKey: 'threeMonths',
          UserPrefsNotifier.selectedTabIndexKey: 1,
        },
        overrides: [dioProvider.overrideWithValue(dio)],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.lightTheme(),
            home: const CurrencyConverterApp(),
          ),
        ),
      );

      // Wait for the screen to load
      await tester.pumpAndSettle();

      // Verify app opens on Charts tab
      expect(find.byType(ChartsScreen), findsOneWidget);
      expect(find.byType(ConvertScreen), findsNothing);

      // Verify chart shows correct currencies
      expect(find.text('USD'), findsWidgets);
      expect(find.text('JPY'), findsWidgets);

      // Verify time range is 3M (button should be selected)
      final threeMonthsButton = find.text('3M');
      expect(threeMonthsButton, findsOneWidget);
    });

    testWidgets('uses default chart preferences when none saved',
        (tester) async {
      // Set up the mock Dio adapter
      final dio = Dio();
      dioAdapter = DioAdapter(dio: dio);
      setupMockLatestRates(dioAdapter, Currency.GBP);
      setupMockTimeSeriesRates(
        dioAdapter,
        Currency.GBP,
        Currency.EUR,
        '2024-01-01',
        '2024-12-31',
      );
      setupMockCurrencies(dioAdapter);

      // Create container with no saved preferences
      container = await createTestContainer(
        mockPreferences: {},
        overrides: [dioProvider.overrideWithValue(dio)],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.lightTheme(),
            home: const CurrencyConverterApp(),
          ),
        ),
      );

      // Wait for the screen to load
      await tester.pumpAndSettle();

      // Verify defaults: Convert tab is shown (default selectedTabIndex = 0)
      expect(find.byType(ConvertScreen), findsOneWidget);
      expect(find.byType(ChartsScreen), findsNothing);

      // Navigate to Charts tab
      await tester.tap(find.text('Charts'));
      await tester.pumpAndSettle();

      // Verify Charts screen is now displayed
      expect(find.byType(ChartsScreen), findsOneWidget);

      // Verify default chart settings: GBP and EUR
      expect(find.text('GBP'), findsWidgets);
      expect(find.text('EUR'), findsWidgets);

      // Verify 1Y is selected (default time range)
      expect(find.text('1Y'), findsOneWidget);
    });

    testWidgets('app opens on Charts tab when it was last selected',
        (tester) async {
      // Set up the mock Dio adapter
      final dio = Dio();
      dioAdapter = DioAdapter(dio: dio);
      setupMockLatestRates(dioAdapter, Currency.GBP);
      setupMockTimeSeriesRates(
        dioAdapter,
        Currency.GBP,
        Currency.EUR,
        '2024-01-01',
        '2024-12-31',
      );
      setupMockCurrencies(dioAdapter);

      // Create container with Charts tab selected
      container = await createTestContainer(
        mockPreferences: {
          UserPrefsNotifier.selectedTabIndexKey: 1,
        },
        overrides: [dioProvider.overrideWithValue(dio)],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.lightTheme(),
            home: const CurrencyConverterApp(),
          ),
        ),
      );

      // Wait for the screen to load
      await tester.pumpAndSettle();

      // Verify Charts screen is displayed, not Convert
      expect(find.byType(ChartsScreen), findsOneWidget);
      expect(find.byType(ConvertScreen), findsNothing);

      // Verify bottom nav shows Charts as selected
      final navigationBar = find.byType(NavigationBar);
      expect(navigationBar, findsOneWidget);
      final navWidget = tester.widget<NavigationBar>(navigationBar);
      expect(navWidget.selectedIndex, 1);
    });

    testWidgets('persists time range changes', (tester) async {
      // Set up the mock Dio adapter
      final dio = Dio();
      dioAdapter = DioAdapter(dio: dio);
      setupMockLatestRates(dioAdapter, Currency.GBP);
      setupMockTimeSeriesRates(
        dioAdapter,
        Currency.GBP,
        Currency.EUR,
        '2024-01-01',
        '2024-12-31',
      );
      setupMockCurrencies(dioAdapter);

      // Create container starting on Charts tab
      container = await createTestContainer(
        mockPreferences: {
          UserPrefsNotifier.selectedTabIndexKey: 1,
        },
        overrides: [dioProvider.overrideWithValue(dio)],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.lightTheme(),
            home: const CurrencyConverterApp(),
          ),
        ),
      );

      // Wait for the screen to load
      await tester.pumpAndSettle();

      // Tap 5Y button
      await tester.tap(find.text('5Y'));
      await tester.pumpAndSettle();

      // Verify persisted
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString(UserPrefsNotifier.chartTimeRangeKey), 'fiveYears');
    });

    testWidgets('maintains convert preferences when changing chart preferences',
        (tester) async {
      // Set up the mock Dio adapter
      final dio = Dio();
      dioAdapter = DioAdapter(dio: dio);
      setupMockLatestRates(dioAdapter, Currency.EUR);
      setupMockTimeSeriesRates(
        dioAdapter,
        Currency.GBP,
        Currency.EUR,
        '2024-01-01',
        '2024-12-31',
      );
      setupMockCurrencies(dioAdapter);

      // Create container with convert preferences set
      container = await createTestContainer(
        mockPreferences: {
          UserPrefsNotifier.baseCurrencyKey: 'EUR',
          UserPrefsNotifier.amountKey: 250.0,
          UserPrefsNotifier.targetCurrenciesKey: ['USD', 'GBP'],
          UserPrefsNotifier.selectedTabIndexKey: 1,
        },
        overrides: [dioProvider.overrideWithValue(dio)],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.lightTheme(),
            home: const CurrencyConverterApp(),
          ),
        ),
      );

      // Wait for the screen to load (Charts tab)
      await tester.pumpAndSettle();

      // Change time range on Charts
      await tester.tap(find.text('3M'));
      await tester.pumpAndSettle();

      // Navigate back to Convert
      await tester.tap(find.text('Convert'));
      await tester.pumpAndSettle();

      // Verify convert preferences unchanged
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString(UserPrefsNotifier.baseCurrencyKey), 'EUR');
      expect(prefs.getDouble(UserPrefsNotifier.amountKey), 250.0);
      expect(prefs.getStringList(UserPrefsNotifier.targetCurrenciesKey),
          ['USD', 'GBP']);
    });

    testWidgets('tab selection persists across navigation', (tester) async {
      // Set up the mock Dio adapter
      final dio = Dio();
      dioAdapter = DioAdapter(dio: dio);
      setupMockLatestRates(dioAdapter, Currency.GBP);
      setupMockTimeSeriesRates(
        dioAdapter,
        Currency.GBP,
        Currency.EUR,
        '2024-01-01',
        '2024-12-31',
      );
      setupMockCurrencies(dioAdapter);

      // Create container starting on Convert tab
      container = await createTestContainer(
        mockPreferences: {
          UserPrefsNotifier.selectedTabIndexKey: 0,
        },
        overrides: [dioProvider.overrideWithValue(dio)],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.lightTheme(),
            home: const CurrencyConverterApp(),
          ),
        ),
      );

      // Wait for the screen to load
      await tester.pumpAndSettle();

      // Verify we're on Convert tab
      expect(find.byType(ConvertScreen), findsOneWidget);

      // Navigate to Charts tab
      await tester.tap(find.text('Charts'));
      await tester.pumpAndSettle();

      // Verify tab selection was persisted
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt(UserPrefsNotifier.selectedTabIndexKey), 1);

      // Navigate back to Convert
      await tester.tap(find.text('Convert'));
      await tester.pumpAndSettle();

      // Verify tab selection was updated again
      expect(prefs.getInt(UserPrefsNotifier.selectedTabIndexKey), 0);
    });
  });
}
