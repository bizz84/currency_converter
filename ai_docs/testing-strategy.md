# Testing Strategy

This document describes the testing strategy and patterns used in the Currency Converter Flutter app.

## Overview

The app uses a layered testing approach with unit tests, widget tests, and shared test utilities to ensure comprehensive coverage while maintaining code quality and maintainability.

## Test Structure

```
test/
├── helpers/                                    # Shared test utilities
│   ├── test_container_factory.dart            # Container setup helper
│   └── mock_api_helpers.dart                  # API mocking helpers
├── src/
│   ├── network/                               # Network layer tests
│   │   ├── currency_api_client_test.dart      # 3 unit tests
│   │   └── frankfurter_client_test.dart       # 17 unit tests
│   ├── storage/                               # Data persistence tests
│   │   └── user_prefs_notifier_test.dart      # 18 unit tests
│   └── screens/                               # UI integration tests
│       ├── convert/
│       │   └── convert_screen_persistence_test.dart  # 5 widget tests
│       └── charts/
│           └── charts_screen_persistence_test.dart   # 6 widget tests
```

**Total: 49 tests**
- Unit tests: 38 (network + storage)
- Widget tests: 11 (convert + charts)
- Execution time: ~5.7 seconds

## Testing Principles

### 1. Test at the Right Level

**Unit Tests** - Fast, isolated, test business logic
- Data model operations
- Persistence operations
- Network client methods
- Pure business logic functions

**Widget Tests** - Medium speed, test UI integration
- UI → Storage flows
- User interactions
- Screen-level behavior
- Cross-feature integration

**Integration Tests** - Slow, end-to-end (optional)
- Full app flows
- Multi-screen workflows
- App restart simulation

### 2. DRY (Don't Repeat Yourself)

- Extract common setup to helpers
- Reuse mock data across tests
- Share test utilities in `test/helpers/`
- Centralize API mocking patterns

### 3. Maintainability

- Use descriptive test names
- Keep tests focused and simple
- Document complex test setups
- Use shared helpers to reduce duplication

### 4. Consistency

- Follow naming conventions
- Use consistent test structure
- Apply same patterns across features
- Maintain predictable organization

## Shared Test Helpers

### Container Factory (`test/helpers/test_container_factory.dart`)

Creates test ProviderContainers with mock SharedPreferences and optional overrides.

**Function:**
```dart
Future<ProviderContainer> createTestContainer({
  Map<String, Object> mockPreferences = const {},
  List<Override> overrides = const [],
})
```

**Usage:**
```dart
container = await createTestContainer(
  mockPreferences: {
    UserPrefsNotifier.baseCurrencyKey: 'EUR',
    UserPrefsNotifier.amountKey: 250.0,
    UserPrefsNotifier.targetCurrenciesKey: ['USD', 'GBP'],
  },
  overrides: [dioProvider.overrideWithValue(dio)],
);
```

**What it does:**
1. Sets up mock SharedPreferences with provided values
2. Creates ProviderContainer with overrides
3. Eagerly initializes SharedPreferences provider
4. Returns ready-to-use container

### API Mocking Helpers (`test/helpers/mock_api_helpers.dart`)

Provides helpers for mocking Frankfurter API endpoints.

**Functions:**

1. **`setupMockLatestRates(DioAdapter adapter, Currency baseCurrency)`**
   - Mocks `/latest` endpoint
   - Provides realistic exchange rates for common currencies
   - Query parameters: `{'from': baseCurrency.name}`

2. **`setupMockTimeSeriesRates(adapter, baseCurrency, targetCurrency, startDate, endDate)`**
   - Mocks `/{startDate}..{endDate}` endpoint
   - Generates progressive rate data over date range
   - Query parameters: `{'from': baseCurrency.name, 'to': targetCurrency.name}`

3. **`setupMockCurrencies(DioAdapter adapter)`**
   - Mocks `/currencies` endpoint
   - Returns list of supported currencies

**Usage:**
```dart
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
```

## Test Patterns

### Unit Test Pattern (Storage/Business Logic)

**File:** `test/src/storage/user_prefs_notifier_test.dart`

**Structure:**
```dart
void main() {
  group('UserPrefsNotifier', () {
    late ProviderContainer container;

    setUp(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    tearDown(() {
      container.dispose();
    });

    test('descriptive test name', () async {
      // Arrange: Set up mock data
      SharedPreferences.setMockInitialValues({
        UserPrefsNotifier.baseCurrencyKey: 'EUR',
      });

      container = ProviderContainer();
      await container.read(sharedPreferencesProvider.future);

      // Act: Perform the operation
      container.read(userPrefsProvider.notifier).updateBaseCurrency(Currency.JPY);

      // Assert: Verify results
      final prefs = container.read(userPrefsProvider);
      expect(prefs.baseCurrency, Currency.JPY);

      final sharedPrefs = await SharedPreferences.getInstance();
      expect(sharedPrefs.getString(UserPrefsNotifier.baseCurrencyKey), 'JPY');
    });
  });
}
```

**Key points:**
- Use `group()` to organize related tests
- Set up/tear down container in setUp/tearDown
- Test both in-memory state and persistence
- Use descriptive test names

### Widget Test Pattern (UI Integration)

**Files:**
- `test/src/screens/convert/convert_screen_persistence_test.dart`
- `test/src/screens/charts/charts_screen_persistence_test.dart`

**Structure:**
```dart
void main() {
  group('ScreenName persistence', () {
    late DioAdapter dioAdapter;
    late ProviderContainer container;

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('descriptive test name', (tester) async {
      // Arrange: Set up mocks and container
      final dio = Dio();
      dioAdapter = DioAdapter(dio: dio);
      setupMockLatestRates(dioAdapter, Currency.GBP);
      setupMockCurrencies(dioAdapter);

      container = await createTestContainer(
        mockPreferences: {
          UserPrefsNotifier.baseCurrencyKey: 'GBP',
          UserPrefsNotifier.amountKey: 100.0,
        },
        overrides: [dioProvider.overrideWithValue(dio)],
      );

      // Act: Pump widget tree
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

      // Assert: Verify UI state
      expect(find.text('GBP'), findsWidgets);
      expect(find.byType(ConvertScreen), findsOneWidget);

      // Act: Interact with UI
      await tester.tap(find.text('Charts'));
      await tester.pumpAndSettle();

      // Assert: Verify persistence
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt(UserPrefsNotifier.selectedTabIndexKey), 1);
    });
  });
}
```

**Key points:**
- Use `testWidgets()` for widget tests
- Set up API mocks before creating container
- Use shared helpers for common setup
- Test both UI state and persistence
- Use `pumpAndSettle()` to wait for animations
- Verify persistence with SharedPreferences.getInstance()

## Test Coverage by Feature

### Convert Screen Persistence

**Coverage:** 5 widget tests + 11 unit tests

**Widget tests verify:**
- Restores saved preferences on app start
- Uses default preferences when none saved
- Persists adding a new target currency
- Persists removing a target currency
- Persists amount changes

**Unit tests verify:**
- Base currency updates and persistence
- Amount updates and persistence
- Target currencies add/remove/reorder
- Default fallback behavior
- Preference isolation

### Charts Screen Persistence

**Coverage:** 6 widget tests + 7 unit tests

**Widget tests verify:**
- Restores saved chart preferences on app start
- Uses default chart preferences when none saved
- App opens on Charts tab when it was last selected
- Persists time range changes
- Maintains convert preferences when changing chart preferences
- Tab selection persists across navigation

**Unit tests verify:**
- Chart base/target currency updates
- Time range updates
- Tab selection updates
- Default fallback behavior
- Isolation from convert preferences

## Common Test Scenarios

### Testing Preference Restoration

```dart
testWidgets('restores saved preferences on app start', (tester) async {
  // Set up mocks
  final dio = Dio();
  dioAdapter = DioAdapter(dio: dio);
  setupMockLatestRates(dioAdapter, Currency.EUR);
  setupMockCurrencies(dioAdapter);

  // Create container with saved preferences
  container = await createTestContainer(
    mockPreferences: {
      UserPrefsNotifier.baseCurrencyKey: 'EUR',
      UserPrefsNotifier.amountKey: 250.0,
      UserPrefsNotifier.targetCurrenciesKey: ['JPY', 'CAD', 'AUD'],
    },
    overrides: [dioProvider.overrideWithValue(dio)],
  );

  // Pump widget tree
  await tester.pumpWidget(...);
  await tester.pumpAndSettle();

  // Verify preferences restored
  expect(find.text('EUR'), findsWidgets);
  // ... more assertions
});
```

### Testing Default Behavior

```dart
testWidgets('uses default preferences when none saved', (tester) async {
  // Set up mocks
  final dio = Dio();
  dioAdapter = DioAdapter(dio: dio);
  setupMockLatestRates(dioAdapter, Currency.GBP);
  setupMockCurrencies(dioAdapter);

  // Create container with NO saved preferences
  container = await createTestContainer(
    mockPreferences: {},
    overrides: [dioProvider.overrideWithValue(dio)],
  );

  // Pump widget tree
  await tester.pumpWidget(...);
  await tester.pumpAndSettle();

  // Verify defaults applied
  expect(find.text('GBP'), findsWidgets);
  // ... more assertions
});
```

### Testing User Interactions

```dart
testWidgets('persists UI changes', (tester) async {
  // Set up initial state
  container = await createTestContainer(...);
  await tester.pumpWidget(...);
  await tester.pumpAndSettle();

  // Interact with UI
  await tester.tap(find.text('5Y'));
  await tester.pumpAndSettle();

  // Verify persistence
  final prefs = await SharedPreferences.getInstance();
  expect(prefs.getString(UserPrefsNotifier.chartTimeRangeKey), 'fiveYears');
});
```

### Testing Preference Isolation

```dart
testWidgets('maintains convert preferences when changing chart preferences',
    (tester) async {
  // Set up both convert and chart preferences
  container = await createTestContainer(
    mockPreferences: {
      UserPrefsNotifier.baseCurrencyKey: 'EUR',
      UserPrefsNotifier.amountKey: 250.0,
      UserPrefsNotifier.targetCurrenciesKey: ['USD', 'GBP'],
      UserPrefsNotifier.selectedTabIndexKey: 1, // Charts tab
    },
    overrides: [dioProvider.overrideWithValue(dio)],
  );

  await tester.pumpWidget(...);
  await tester.pumpAndSettle();

  // Change chart settings
  await tester.tap(find.text('3M'));
  await tester.pumpAndSettle();

  // Navigate to Convert tab
  await tester.tap(find.text('Convert'));
  await tester.pumpAndSettle();

  // Verify convert preferences unchanged
  final prefs = await SharedPreferences.getInstance();
  expect(prefs.getString(UserPrefsNotifier.baseCurrencyKey), 'EUR');
  expect(prefs.getDouble(UserPrefsNotifier.amountKey), 250.0);
  expect(prefs.getStringList(UserPrefsNotifier.targetCurrenciesKey), ['USD', 'GBP']);
});
```

## Running Tests

### Run all tests
```bash
flutter test
```

### Run specific test file
```bash
flutter test test/src/storage/user_prefs_notifier_test.dart
```

### Run tests by pattern
```bash
flutter test --name "persistence"
```

### Run specific directory
```bash
flutter test test/src/screens/convert/
```

### With coverage
```bash
flutter test --coverage
```

## Best Practices

### DO

✅ Use shared helpers for common setup
✅ Write descriptive test names
✅ Test both UI state and persistence
✅ Keep tests focused on one thing
✅ Use `pumpAndSettle()` to wait for animations
✅ Verify persistence with SharedPreferences.getInstance()
✅ Clean up resources in tearDown()
✅ Use type-safe Currency enum instead of strings
✅ Test both success and edge cases
✅ Follow arrange-act-assert pattern

### DON'T

❌ Hardcode test data - use shared helpers
❌ Create inline mock setup - use helpers
❌ Skip setUp/tearDown - always clean up
❌ Test multiple things in one test
❌ Use magic numbers - use named constants
❌ Forget to dispose containers
❌ Mix unit and widget test concerns
❌ Copy-paste test code - extract helpers
❌ Skip edge case testing
❌ Use sleep() - use pumpAndSettle()

## Adding New Tests

### For New Features

1. **Add unit tests** for business logic in `test/src/storage/` or appropriate location
2. **Add widget tests** for UI integration in `test/src/screens/[feature]/`
3. **Use shared helpers** for common setup (container factory, API mocking)
4. **Follow existing patterns** from similar tests
5. **Verify all tests pass** with `flutter test`

### Example: Adding Tests for a New Screen

1. Create test file: `test/src/screens/[screen_name]/[screen_name]_persistence_test.dart`

2. Import dependencies and helpers:
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ... other imports
import '../../../helpers/test_container_factory.dart';
import '../../../helpers/mock_api_helpers.dart';
```

3. Set up test group:
```dart
void main() {
  group('[ScreenName] persistence', () {
    late DioAdapter dioAdapter;
    late ProviderContainer container;

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    tearDown(() {
      container.dispose();
    });

    // Add tests here
  });
}
```

4. Add test cases following patterns in this document

5. Run and verify:
```bash
flutter test test/src/screens/[screen_name]/
```

## Troubleshooting

### Tests fail with "Bad state: No test is currently running"
- Ensure you're calling `TestWidgetsFlutterBinding.ensureInitialized()` in setUp

### Tests timeout
- Check that you're using `await tester.pumpAndSettle()` after interactions
- Verify API mocks are set up correctly
- Ensure async operations are properly awaited

### Container already disposed errors
- Don't dispose container in the test, do it in tearDown
- Ensure tearDown is called after each test

### SharedPreferences not found
- Make sure to await `container.read(sharedPreferencesProvider.future)` after creating container
- Or use `createTestContainer()` helper which does this automatically

### API calls not mocked
- Verify you're setting up mocks before pumping widget tree
- Check that query parameters match what the app is sending
- Use correct Currency enum values, not strings

## References

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Riverpod Testing Guide](https://riverpod.dev/docs/essentials/testing)
- [Test Refactoring Plan](../ai_specs/015-tests-refactor-plan.md)

## Maintenance

- Review tests when adding new features
- Update helpers when API changes
- Keep test execution time under 10 seconds
- Maintain test coverage above 80%
- Refactor tests to use helpers when duplication appears
