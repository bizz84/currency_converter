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

### 1. Add SharedPreferences dependency
- [x] Add `shared_preferences: ^2.3.3` to pubspec.yaml
- [x] Run `flutter pub get`

### 2. Create UserPrefs data model
**File:** `lib/src/storage/user_prefs_notifier.dart`
- [x] Define `UserPrefs` class with baseCurrency, amount, and targetCurrencies
- [x] Add static defaults: GBP, 100.0, [EUR, USD, JPY]
- [x] Keep model in same file as notifier for simplicity

### 3. Create SharedPreferences provider
**File:** `lib/src/utils/shared_preferences_provider.dart`
- [x] Create a Riverpod provider for SharedPreferences instance
- [x] Use `@Riverpod(keepAlive: true)` annotation
- [x] Return `SharedPreferences.getInstance()`

### 4. Create UserPrefsNotifier
**File:** `lib/src/storage/user_prefs_notifier.dart`
- [x] Extend generated Riverpod notifier class
- [x] Define storage keys: `base_currency`, `amount`, `target_currencies`
- [x] Implement methods:
  - [x] `build()`: Load preferences from storage with fallback to defaults
  - [x] `updateBaseCurrency()`: Update and persist base currency
  - [x] `updateAmount()`: Update and persist amount
  - [x] `updateTargetCurrencies()`: Update and persist target currency list
  - [x] `addTargetCurrency()`: Add currency without duplicates
  - [x] `removeTargetCurrency()`: Remove currency from list
  - [x] `reorderTargetCurrencies()`: Handle drag-to-reorder

### 5. Update main.dart for eager initialization
- [x] Add `WidgetsFlutterBinding.ensureInitialized()`
- [x] Create `ProviderContainer` before runApp
- [x] Eagerly load SharedPreferences: `await container.read(sharedPreferencesProvider.future)`
- [x] Use `UncontrolledProviderScope` with container

### 6. Update ConvertScreen to use UserPrefsNotifier
**File:** `lib/src/screens/convert/convert_screen.dart`
- [x] Remove local state variables (baseCurrency, amount, targetCurrencies)
- [x] Watch `userPrefsProvider` for state
- [x] Use `ref.read(userPrefsProvider.notifier)` for updates
- [x] Update all setState calls to use notifier methods

### 7. Run build_runner to generate providers
- [x] Run `flutter pub run build_runner build --delete-conflicting-outputs`
- [x] Or use alias: `brb` (build_runner is running in watch mode)

## Storage Keys
- `base_currency` - String (Currency enum name)
- `amount` - double
- `target_currencies` - List<String> (Currency enum names)

## Testing Implementation

### 8. Unit Tests for UserPrefsNotifier
**File:** `test/src/storage/user_prefs_notifier_test.dart`
- [x] Test loading saved preferences
- [x] Test fallback to defaults
- [x] Test each update method
- [x] Test persistence to SharedPreferences
- [x] Test add/remove/reorder operations

### 9. Widget Tests for ConvertScreen Persistence
**File:** `test/src/screens/convert/convert_screen_persistence_test.dart`
- [x] Test restoration of saved preferences on app start
- [x] Test persistence of currency changes
- [x] Test persistence of amount changes
- [x] Test add/remove target currency operations
- [x] Mock API calls using DioAdapter

## Key Considerations

### Error Handling
- Invalid enum names: Fall back to defaults
- Missing keys: Each key independently falls back to default
- Save failures: Log error but continue operation

### Benefits of Separate Keys
- More efficient updates (only write changed data)
- Easier debugging
- Simpler migration if data structure changes
- No JSON encoding/decoding overhead for individual updates

### Riverpod 3.0 Conventions
- Provider name: `userPrefsProvider` (not `userPrefsNotifierProvider`)
- Access state: `ref.watch(userPrefsProvider)`
- Access notifier: `ref.read(userPrefsProvider.notifier)`
- Use `.value` instead of `.valueOrNull`

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
- [x] SharedPreferences mock works correctly in tests