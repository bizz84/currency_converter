# Test Refactoring Plan

## Overview

Refactor test organization to ensure consistent coverage across features, reduce duplication, and follow Flutter testing best practices. This includes adding missing widget tests for ChartsScreen persistence and extracting shared test utilities.

## Current Test Structure

```
test/src/
├── storage/
│   └── user_prefs_notifier_test.dart      ✓ 18 unit tests (convert + chart fields)
└── screens/
    └── convert/
        └── convert_screen_persistence_test.dart  ✓ 5 widget tests (convert only)
```

**Gap Identified:**
- No widget tests for ChartsScreen persistence
- No tests for tab selection persistence at app level
- Duplicated mock setup code across test files

## Goals

1. **Consistency** - All major screens with persistence should have equivalent test coverage
2. **Completeness** - Cover end-to-end flows for all persistent features
3. **Maintainability** - Extract shared utilities to reduce duplication
4. **Professional Standards** - Follow Flutter/Riverpod testing best practices

## Proposed Test Structure

```
test/
├── helpers/
│   ├── test_container_factory.dart        # NEW: Factory for creating test containers
│   └── mock_api_helpers.dart              # NEW: Shared API mocking utilities
├── src/
│   ├── storage/
│   │   └── user_prefs_notifier_test.dart  ✓ Unit tests (no changes needed)
│   └── screens/
│       ├── convert/
│       │   └── convert_screen_persistence_test.dart  ✓ Widget tests (refactor to use helpers)
│       └── charts/
│           └── charts_screen_persistence_test.dart   # NEW: Widget tests for charts
└── app_persistence_integration_test.dart  # NEW: Cross-feature integration tests
```

## Implementation Tasks

### Phase 1: Create Shared Test Utilities

#### File: `test/helpers/test_container_factory.dart`

- [ ] Create helper function to create ProviderContainer with overrides
- [ ] Create helper to initialize SharedPreferences with mock values
- [ ] Create helper to setup container with SharedPreferences loaded
  ```dart
  Future<ProviderContainer> createTestContainer({
    Map<String, Object> mockPreferences = const {},
    List<Override> overrides = const [],
  }) async {
    SharedPreferences.setMockInitialValues(mockPreferences);

    final container = ProviderContainer(overrides: overrides);
    await container.read(sharedPreferencesProvider.future);

    return container;
  }
  ```

#### File: `test/helpers/mock_api_helpers.dart`

- [ ] Extract API mocking setup from `convert_screen_persistence_test.dart`
- [ ] Create `setupMockLatestRates()` helper
- [ ] Create `setupMockTimeSeriesRates()` helper for chart tests
- [ ] Create `setupMockCurrencies()` helper
  ```dart
  void setupMockLatestRates(DioAdapter adapter, Currency baseCurrency) {
    adapter.onGet('/latest', (server) => server.reply(200, {...}),
      queryParameters: {'from': baseCurrency.name},
    );
  }

  void setupMockTimeSeriesRates(DioAdapter adapter,
    Currency baseCurrency, Currency targetCurrency, ChartTimeRange range) {
    // Mock time series endpoint
  }
  ```

### Phase 2: Refactor Existing Convert Screen Tests

**File:** `test/src/screens/convert/convert_screen_persistence_test.dart`

- [ ] Import shared test helpers
- [ ] Replace inline mock setup with helper functions
- [ ] Use `createTestContainer()` helper
- [ ] Remove duplicated code
- [ ] Verify all tests still pass

**Before:**
```dart
setUp(() {
  TestWidgetsFlutterBinding.ensureInitialized();
});

testWidgets('test name', (tester) async {
  SharedPreferences.setMockInitialValues({...});
  final dio = Dio();
  dioAdapter = DioAdapter(dio: dio);
  // Lots of setup...
});
```

**After:**
```dart
testWidgets('test name', (tester) async {
  final dio = Dio();
  dioAdapter = DioAdapter(dio: dio);
  setupMockLatestRates(dioAdapter, Currency.GBP);
  setupMockCurrencies(dioAdapter);

  container = await createTestContainer(
    mockPreferences: {
      UserPrefsNotifier.baseCurrencyKey: 'EUR',
      UserPrefsNotifier.amountKey: 250.0,
    },
    overrides: [dioProvider.overrideWithValue(dio)],
  );

  // Test logic...
});
```

### Phase 3: Create Charts Screen Persistence Tests

**File:** `test/src/screens/charts/charts_screen_persistence_test.dart` (NEW)

Follow the pattern from `convert_screen_persistence_test.dart`, adapted for charts:

- [ ] Import necessary dependencies and helpers
- [ ] Set up test group with DioAdapter and ProviderContainer
- [ ] Add test: 'restores saved chart preferences on app start'
  ```dart
  testWidgets('restores saved chart preferences on app start', (tester) async {
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
    // Could verify button style/state if needed
  });
  ```

- [ ] Add test: 'uses default chart preferences when none saved'
  ```dart
  testWidgets('uses default chart preferences when none saved', (tester) async {
    container = await createTestContainer(
      mockPreferences: {},
      overrides: [dioProvider.overrideWithValue(dio)],
    );

    await tester.pumpWidget(...);
    await tester.pumpAndSettle();

    // Verify defaults: GBP, EUR, 1Y, Convert tab
    expect(find.byType(ConvertScreen), findsOneWidget);

    // Navigate to Charts
    await tester.tap(find.text('Charts'));
    await tester.pumpAndSettle();

    // Verify default chart settings
    expect(find.text('GBP'), findsWidgets);
    expect(find.text('EUR'), findsWidgets);
    // Verify 1Y is selected
  });
  ```

- [ ] Add test: 'app opens on Charts tab when it was last selected'
  ```dart
  testWidgets('app opens on Charts tab when it was last selected', (tester) async {
    container = await createTestContainer(
      mockPreferences: {
        UserPrefsNotifier.selectedTabIndexKey: 1,
      },
      overrides: [dioProvider.overrideWithValue(dio)],
    );

    await tester.pumpWidget(...);
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
  ```

- [ ] Add test: 'persists chart base currency changes'
  ```dart
  testWidgets('persists chart base currency changes', (tester) async {
    container = await createTestContainer(
      mockPreferences: {
        UserPrefsNotifier.selectedTabIndexKey: 1,
      },
      overrides: [dioProvider.overrideWithValue(dio)],
    );

    await tester.pumpWidget(...);
    await tester.pumpAndSettle();

    // Find and tap base currency selector
    // (Implementation depends on UI structure)
    final baseCurrencySelector = find.text('GBP').first;
    await tester.tap(baseCurrencySelector);
    await tester.pumpAndSettle();

    // Select USD from picker
    await tester.tap(find.text('USD').last);
    await tester.pumpAndSettle();

    // Verify persisted
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(UserPrefsNotifier.chartBaseCurrencyKey), 'USD');
  });
  ```

- [ ] Add test: 'persists chart target currency changes'
- [ ] Add test: 'persists time range changes'
  ```dart
  testWidgets('persists time range changes', (tester) async {
    // Navigate to Charts
    // Tap 5Y button
    await tester.tap(find.text('5Y'));
    await tester.pumpAndSettle();

    // Verify persisted
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(UserPrefsNotifier.chartTimeRangeKey), 'fiveYears');
  });
  ```

- [ ] Add test: 'maintains convert preferences when changing chart preferences'
  ```dart
  testWidgets('maintains convert preferences when changing chart preferences', (tester) async {
    container = await createTestContainer(
      mockPreferences: {
        UserPrefsNotifier.baseCurrencyKey: 'EUR',
        UserPrefsNotifier.amountKey: 250.0,
        UserPrefsNotifier.targetCurrenciesKey: ['USD', 'GBP'],
      },
      overrides: [dioProvider.overrideWithValue(dio)],
    );

    // Navigate to Charts and change settings
    // ...

    // Navigate back to Convert
    await tester.tap(find.text('Convert'));
    await tester.pumpAndSettle();

    // Verify convert preferences unchanged
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(UserPrefsNotifier.baseCurrencyKey), 'EUR');
    expect(prefs.getDouble(UserPrefsNotifier.amountKey), 250.0);
  });
  ```

- [ ] Add test: 'tab selection persists across app restarts'
- [ ] Run tests: `flutter test test/src/screens/charts/charts_screen_persistence_test.dart`

### Phase 4: Create App-Level Integration Tests (Optional)

**File:** `test/app_persistence_integration_test.dart` (NEW)

High-level tests that verify cross-feature behavior:

- [ ] Add test: 'complete persistence flow across app restart simulation'
  ```dart
  testWidgets('complete persistence flow across app restart', (tester) async {
    // First "session"
    var container = await createTestContainer(mockPreferences: {});

    await tester.pumpWidget(...);
    await tester.pumpAndSettle();

    // Change convert settings
    // Change chart settings
    // Switch to Charts tab

    // Simulate "restart" by disposing and recreating
    container.dispose();
    await tester.pumpWidget(Container()); // Clear widget tree

    // Second "session" - create new container from persisted data
    final prefs = await SharedPreferences.getInstance();
    final savedPrefs = {
      UserPrefsNotifier.baseCurrencyKey: prefs.getString(UserPrefsNotifier.baseCurrencyKey),
      UserPrefsNotifier.chartBaseCurrencyKey: prefs.getString(UserPrefsNotifier.chartBaseCurrencyKey),
      UserPrefsNotifier.selectedTabIndexKey: prefs.getInt(UserPrefsNotifier.selectedTabIndexKey),
      // ... all other preferences
    };

    container = await createTestContainer(mockPreferences: savedPrefs);

    await tester.pumpWidget(...);
    await tester.pumpAndSettle();

    // Verify everything restored correctly
    expect(find.byType(ChartsScreen), findsOneWidget);
    // Verify all settings match
  });
  ```

- [ ] Add test: 'preferences are isolated between convert and charts'
- [ ] Run tests: `flutter test test/app_persistence_integration_test.dart`

### Phase 5: Run All Tests and Verify

- [ ] Run unit tests: `flutter test test/src/storage/`
- [ ] Run convert widget tests: `flutter test test/src/screens/convert/`
- [ ] Run charts widget tests: `flutter test test/src/screens/charts/`
- [ ] Run integration tests: `flutter test test/app_persistence_integration_test.dart`
- [ ] Run full test suite: `flutter test`
- [ ] Verify all tests pass
- [ ] Verify no test duplication
- [ ] Verify test execution time is reasonable

### Phase 6: Documentation

- [ ] Add README in `test/` directory explaining test organization
- [ ] Document helper usage in helper files
- [ ] Add comments explaining complex test setups
- [ ] Update CLAUDE.md if needed with testing guidelines

## Test Coverage Goals

After refactoring, we should have:

### Unit Tests (Fast, Isolated)
- ✅ `user_prefs_notifier_test.dart` - 18+ tests
  - All data model operations
  - All persistence operations
  - Isolation between fields

### Widget Tests (Medium Speed, Integration)
- ✅ `convert_screen_persistence_test.dart` - 5+ tests
  - UI → Storage flow for convert features
  - User interactions with convert screen
- ✅ `charts_screen_persistence_test.dart` - 6+ tests
  - UI → Storage flow for chart features
  - User interactions with charts screen
  - Tab selection persistence

### Integration Tests (Slower, End-to-End)
- ✅ `app_persistence_integration_test.dart` - 2+ tests
  - Cross-feature behavior
  - App restart simulation
  - Full persistence lifecycle

## Key Principles

1. **Test at the Right Level**
   - Unit tests: Data/business logic
   - Widget tests: UI integration
   - Integration tests: Cross-feature flows

2. **DRY (Don't Repeat Yourself)**
   - Extract common setup to helpers
   - Reuse mock data where possible
   - Share test utilities across test files

3. **Maintainability**
   - Tests should be easy to understand
   - Tests should be easy to modify
   - Tests should run fast

4. **Consistency**
   - Similar features should have similar test coverage
   - Test structure should be predictable
   - Naming conventions should be clear

## Benefits

1. **Complete Coverage** - All persistent features tested at multiple levels
2. **Reduced Duplication** - Shared helpers eliminate copy-paste code
3. **Better Maintainability** - Changes to mock setup only need to happen once
4. **Professional Standard** - Follows Flutter testing best practices
5. **Confidence** - Can refactor knowing tests will catch issues

## Migration Notes

- This can be done incrementally - each phase is independent
- Existing tests continue to work during migration
- Phase 1-2 improve existing tests
- Phase 3 adds new coverage
- Phase 4 is optional (nice to have)

## Future Enhancements (Out of Scope)

- Golden tests for widget visual regression
- Performance benchmarks for persistence operations
- Test coverage reporting integration
- Automated test generation for new features
