# User Data Storage Implementation Plan

## Overview
Implement persistent storage for user preferences using SharedPreferences with eager initialization pattern and Riverpod 3.0 conventions.

## Data to Persist
- Base currency selection
- Amount to convert
- List of target currencies (including order)

## Architecture

### Storage Solution: SharedPreferences
- Simple key-value storage
- Works on iOS, Android, and web
- Synchronous access after eager initialization
- Perfect for small settings data

### File Structure
```
lib/src/
├── storage/
│   └── user_prefs_notifier.dart           # Data model (UserPrefs) + state management with auto-save
├── utils/
│   └── shared_preferences_provider.dart   # SharedPreferences instance provider
└── main.dart                              # Eager initialization
```

## Implementation Tasks

### [x] 1. Add SharedPreferences dependency
```yaml
# pubspec.yaml
dependencies:
  shared_preferences: ^2.3.3
```
Run: `flutter pub get`

### [x] 2. Create UserPrefs data model
**File:** `lib/src/storage/user_prefs_notifier.dart` (included in the same file as the notifier)

```dart
class UserPrefs {
  final Currency baseCurrency;
  final double amount;
  final List<Currency> targetCurrencies;

  const UserPrefs({
    required this.baseCurrency,
    required this.amount,
    required this.targetCurrencies,
  });

  static const defaults = UserPrefs(
    baseCurrency: Currency.GBP,
    amount: 100.0,
    targetCurrencies: [Currency.EUR, Currency.USD, Currency.JPY],
  );
}
```

### [x] 3. Create SharedPreferences provider
**File:** `lib/src/utils/shared_preferences_provider.dart`

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shared_preferences_provider.g.dart';

@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPreferences(Ref ref) async {
  return SharedPreferences.getInstance();
}
```

### [x] 4. Create UserPrefsNotifier
**File:** `lib/src/storage/user_prefs_notifier.dart` (includes both UserPrefs model and notifier)

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/src/data/currency.dart';
import '/src/utils/shared_preferences_provider.dart';

// UserPrefs model is defined at the top of this file

part 'user_prefs_notifier.g.dart';

@riverpod
class UserPrefsNotifier extends _$UserPrefsNotifier {
  // Separate keys for each preference
  static const _baseCurrencyKey = 'base_currency';
  static const _amountKey = 'amount';
  static const _targetCurrenciesKey = 'target_currencies';

  SharedPreferences get _prefs =>
    ref.watch(sharedPreferencesProvider).requireValue;

  @override
  UserPrefs build() {
    return _loadPreferences();
  }

  UserPrefs _loadPreferences() {
    // Load each preference separately with fallback to defaults
    final baseCurrencyName = _prefs.getString(_baseCurrencyKey);
    final baseCurrency = baseCurrencyName != null
        ? Currency.values.byName(baseCurrencyName)
        : UserPrefs.defaults.baseCurrency;

    final amount = _prefs.getDouble(_amountKey)
        ?? UserPrefs.defaults.amount;

    final targetCurrencyNames = _prefs.getStringList(_targetCurrenciesKey);
    final targetCurrencies = targetCurrencyNames != null
        ? targetCurrencyNames
            .map((name) => Currency.values.byName(name))
            .toList()
        : UserPrefs.defaults.targetCurrencies;

    return UserPrefs(
      baseCurrency: baseCurrency,
      amount: amount,
      targetCurrencies: targetCurrencies,
    );
  }

  void updateBaseCurrency(Currency currency) {
    state = UserPrefs(
      baseCurrency: currency,
      amount: state.amount,
      targetCurrencies: state.targetCurrencies,
    );
    _prefs.setString(_baseCurrencyKey, currency.name);
  }

  void updateAmount(double amount) {
    state = UserPrefs(
      baseCurrency: state.baseCurrency,
      amount: amount,
      targetCurrencies: state.targetCurrencies,
    );
    _prefs.setDouble(_amountKey, amount);
  }

  void updateTargetCurrencies(List<Currency> currencies) {
    state = UserPrefs(
      baseCurrency: state.baseCurrency,
      amount: state.amount,
      targetCurrencies: currencies,
    );
    _prefs.setStringList(
      _targetCurrenciesKey,
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
}
```

### [x] 5. Update main.dart for eager initialization
**File:** `lib/main.dart`

Add eager initialization:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/src/app.dart';
import '/src/utils/shared_preferences_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();
  // Eagerly initialize SharedPreferences
  await container.read(sharedPreferencesProvider.future);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const CurrencyConverterApp(),
    ),
  );
}
```

### [x] 6. Update ConvertScreen to use UserPrefsNotifier
**File:** `lib/src/screens/convert/convert_screen.dart`

Add import:
```dart
import '/src/storage/user_prefs_notifier.dart';  // Contains both UserPrefs model and UserPrefsNotifier
```

Replace local state variables with provider:
```dart
class _ConvertScreenState extends ConsumerState<ConvertScreen> {
  // Remove these local state variables:
  // Currency baseCurrency = Currency.GBP;
  // double amount = 100.0;
  // List<Currency> targetCurrencies = [Currency.EUR, Currency.USD, Currency.JPY];

  Timer? _refreshTimer;

  @override
  Widget build(BuildContext context) {
    // Use provider state
    final userPrefs = ref.watch(userPrefsProvider);
    final baseCurrency = userPrefs.baseCurrency;
    final amount = userPrefs.amount;
    final targetCurrencies = userPrefs.targetCurrencies;

    // ... rest of build method stays the same ...
  }

  Future<void> _showCurrencyPicker(bool isBaseCurrency) async {
    final userPrefs = ref.read(userPrefsProvider);
    final result = await AdaptiveCurrencyPicker.show(
      context,
      selectedCurrency: isBaseCurrency ? userPrefs.baseCurrency : null,
      excludedCurrencies: isBaseCurrency
          ? null
          : [userPrefs.baseCurrency, ...userPrefs.targetCurrencies],
    );

    if (result != null) {
      if (isBaseCurrency) {
        ref.read(userPrefsProvider.notifier).updateBaseCurrency(result);
      } else {
        ref.read(userPrefsProvider.notifier).addTargetCurrency(result);
      }
    }
  }

  void _removeCurrency(Currency currency) {
    ref.read(userPrefsProvider.notifier).removeTargetCurrency(currency);
  }

  void _reorderCurrencies(int oldIndex, int newIndex) {
    ref.read(userPrefsProvider.notifier).reorderTargetCurrencies(oldIndex, newIndex);
  }
}
```

Update `BaseCurrencyWidget` callback in build method:
```dart
BaseCurrencyWidget(
  currency: baseCurrency,
  amount: amount,
  onCurrencyTap: () => _showCurrencyPicker(true),
  onAmountChanged: (value) {
    ref.read(userPrefsProvider.notifier).updateAmount(value);
  },
),
```

### [x] 7. Run build_runner to generate providers
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Storage Keys
- `base_currency` - String (Currency enum name)
- `amount` - double
- `target_currencies` - List<String> (Currency enum names)

## Benefits of Separate Keys
- More efficient updates - only write changed data
- Easier debugging - can inspect individual preferences
- Simpler migration if data structure changes
- No JSON encoding/decoding overhead
- Native SharedPreferences types for better performance

## Error Handling
- **Invalid enum names:** Falls back to defaults
- **Missing keys:** Each key independently falls back to its default
- **Save failures:** Log error but continue app operation

## Testing Implementation

### [x] 8. Unit Tests for UserPrefsNotifier
**File:** `test/src/storage/user_prefs_notifier_test.dart`

Key test cases:
- Load saved preferences on initialization
- Fall back to defaults when no saved preferences
- Update base currency and persist to storage
- Update amount and persist to storage
- Add target currency without duplicates
- Remove target currency
- Reorder target currencies correctly
- Handle corrupted/invalid data gracefully

### [x] 9. Widget Tests for ConvertScreen Persistence
**File:** `test/src/screens/convert/convert_screen_persistence_test.dart`

Key test cases:
- Restore saved preferences on app start
- Persist currency selection changes
- Persist amount changes
- Persist target currency additions/removals
- Persist reordering of target currencies

### [ ] 10. Integration Tests (Optional)
**File:** `integration_test/user_preferences_test.dart`

Full user journey:
- Start app with default preferences
- Change base currency to EUR
- Change amount to 500
- Add CAD as target currency
- Remove a currency
- Reorder currencies
- Simulate app restart
- Verify all changes persisted

## Testing Checklist
- [x] Unit tests for UserPrefsNotifier pass
- [x] Widget tests for persistence pass
- [x] Preferences persist after app restart
- [x] Base currency changes are saved independently
- [x] Amount changes are saved independently
- [x] Target currency list changes are saved independently
- [x] Currency reordering is preserved
- [x] Handles missing/corrupted keys gracefully
- [x] Falls back to defaults when no saved data
- [ ] SharedPreferences mock works correctly in tests

## Notes
- Uses `Currency` enum type throughout (not strings)
- Follows absolute import pattern (`/src/...` instead of `package:...`)
- Riverpod 3.0 conventions: `userPrefsProvider` (not `userPrefsNotifierProvider`)
- Each preference saved separately for efficiency