# Charts Data Storage Implementation Plan

## Overview

Extend the existing `UserPrefsNotifier` to persist chart-related user selections (base currency, target currency, time range, and selected tab index) to local storage so they are restored across app restarts, following the same pattern established for the Convert screen.

## Data to Persist

- Chart base currency
- Chart target currency
- Chart time range (1D, 1W, 1M, 3M, 1Y, 5Y, 10Y)
- Selected tab index (Convert = 0, Charts = 1)

## Architecture

### Storage Solution: SharedPreferences (Already Configured)

- Leverages existing SharedPreferences setup from Convert screen persistence
- Same eager initialization pattern in main.dart
- Synchronous access via `UserPrefsNotifier`

### Files to Modify

```
lib/src/
├── storage/
│   └── user_prefs_notifier.dart           # Add chart fields and methods
├── screens/
│   ├── charts/
│   │   └── charts_controller.dart         # Load/save chart preferences
│   └── app.dart                           # Convert to Riverpod for tab persistence
test/src/
├── storage/
│   └── user_prefs_notifier_test.dart      # Add chart preference tests
└── screens/
    └── charts/
        └── charts_screen_persistence_test.dart  # New widget tests
```

## Implementation Tasks

### 1. Extend UserPrefs data model ✅

**File:** `lib/src/storage/user_prefs_notifier.dart`

- [x] Add chart-related fields to `UserPrefs` class:
  - `chartBaseCurrency: Currency`
  - `chartTargetCurrency: Currency`
  - `chartTimeRange: ChartTimeRange`
  - `selectedTabIndex: int`
- [x] Update `UserPrefs.defaults` constant:
  - chartBaseCurrency: `Currency.GBP`
  - chartTargetCurrency: `Currency.EUR`
  - chartTimeRange: `ChartTimeRange.oneYear`
  - selectedTabIndex: `0`
- [x] Keep all fields in same class for simplicity
- [x] **BONUS:** Added `copyWith` method to make state updates more concise and maintainable

### 2. Add storage keys and methods to UserPrefsNotifier ✅

**File:** `lib/src/storage/user_prefs_notifier.dart`

- [x] Add storage keys as static constants (following existing pattern):
  - `chartBaseCurrencyKey = 'user_prefs/chart_base_currency'`
  - `chartTargetCurrencyKey = 'user_prefs/chart_target_currency'`
  - `chartTimeRangeKey = 'user_prefs/chart_time_range'`
  - `selectedTabIndexKey = 'user_prefs/selected_tab_index'`
- [x] Update `build()` method to load chart preferences:
  - Read each key from SharedPreferences
  - Parse enum names for Currency and ChartTimeRange
  - Fall back to defaults for missing/invalid values
- [x] Add update methods:
  - `updateChartBaseCurrency(Currency currency)`
  - `updateChartTargetCurrency(Currency currency)`
  - `updateChartTimeRange(ChartTimeRange range)`
  - `updateSelectedTabIndex(int index)`
- [x] Each update method should:
  - Update state with new value (using `copyWith`)
  - Persist to SharedPreferences
- [x] Refactored all existing update methods to use `copyWith`

### 3. Run build_runner ✅

- [x] Build runner is assumed to be in watch mode (auto-generated)
- [x] Verified `user_prefs_notifier.g.dart` updates correctly
- [x] Verified code compiles with no warnings (`flutter analyze`)

### 4. Update ChartsController to use persisted state ✅

**File:** `lib/src/screens/charts/charts_controller.dart`

- [x] Modify `build()` method to read initial state from `userPrefsProvider`:
  ```dart
  @override
  ChartsState build() {
    final prefs = ref.watch(userPrefsProvider);
    return ChartsState(
      baseCurrency: prefs.chartBaseCurrency,
      targetCurrency: prefs.chartTargetCurrency,
      timeRange: prefs.chartTimeRange,
    );
  }
  ```
- [x] Update `setBaseCurrency()` to persist:
  ```dart
  void setBaseCurrency(Currency currency) {
    state = state.copyWith(baseCurrency: currency);
    ref.read(userPrefsProvider.notifier).updateChartBaseCurrency(currency);
    ref.read(chartSelectedPointProvider.notifier).clearSelectedPoint();
  }
  ```
- [x] Update `setTargetCurrency()` to persist
- [x] Update `setTimeRange()` to persist
- [x] Update `swapCurrencies()` to persist both currencies:
  ```dart
  void swapCurrencies() {
    final newBase = state.targetCurrency;
    final newTarget = state.baseCurrency;
    state = state.copyWith(
      baseCurrency: newBase,
      targetCurrency: newTarget,
    );
    final notifier = ref.read(userPrefsProvider.notifier);
    notifier.updateChartBaseCurrency(newBase);
    notifier.updateChartTargetCurrency(newTarget);
    ref.read(chartSelectedPointProvider.notifier).clearSelectedPoint();
  }
  ```
- [x] Verify app compiles and charts screen functions correctly (`flutter analyze` passed)

### 5. Update MainScreen to persist tab selection ✅

**File:** `lib/src/app.dart`

- [x] Convert `MainScreen` from `StatefulWidget` to `ConsumerWidget`
- [x] Import Riverpod: `import 'package:flutter_riverpod/flutter_riverpod.dart';`
- [x] Import UserPrefsNotifier: `import '/src/storage/user_prefs_notifier.dart';`
- [x] Read `selectedIndex` using a selector to optimize rebuilds:
  ```dart
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(
      userPrefsProvider.select((prefs) => prefs.selectedTabIndex),
    );
    // ...
  }
  ```
- [x] Update `onDestinationSelected` callback to persist selection:
  ```dart
  onDestinationSelected: (index) {
    ref.read(userPrefsProvider.notifier).updateSelectedTabIndex(index);
  }
  ```
- [x] **IMPROVEMENT:** Eliminated redundant local state - provider is now single source of truth
- [x] **OPTIMIZATION:** Used `select()` to only rebuild when `selectedTabIndex` changes, not on other UserPrefs changes
- [x] **OPTIMIZATION:** Applied selector to `ConvertScreen` to only watch convert-related fields (baseCurrency, amount, targetCurrencies)
- [x] Verify app compiles with no warnings (`flutter analyze` passed)

### Performance Optimization Notes

**Selector Usage Pattern:**
- ✅ **MainScreen (widget)** - Uses `select()` for `selectedTabIndex` only
  ```dart
  final selectedIndex = ref.watch(
    userPrefsProvider.select((prefs) => prefs.selectedTabIndex),
  );
  ```
- ✅ **ConvertScreen (widget)** - Uses `select()` with record for convert fields only
  ```dart
  final (baseCurrency, amount, targetCurrencies) = ref.watch(
    userPrefsProvider.select((prefs) => (
      prefs.baseCurrency,
      prefs.amount,
      prefs.targetCurrencies,
    )),
  );
  ```
- ✅ **ChartsController (provider)** - Uses simple `ref.watch()` (correct for providers)
  ```dart
  final prefs = ref.watch(userPrefsProvider);
  ```

**Benefits:**
- MainScreen doesn't rebuild when convert/chart fields change
- ConvertScreen doesn't rebuild when chart/tab fields change
- Charts screen uses ChartsController which rebuilds appropriately
- Provider rebuilds are lightweight; widget rebuilds are what we optimize

### 6. Add unit tests for chart preferences

**File:** `test/src/storage/user_prefs_notifier_test.dart`

- [ ] Add test: 'loads saved chart preferences'
  - Mock SharedPreferences with chart data
  - Verify `UserPrefs` has correct chart values
- [ ] Add test: 'falls back to defaults for missing chart preferences'
  - Mock empty SharedPreferences
  - Verify defaults are used
- [ ] Add test: 'updates and persists chart base currency'
  - Call `updateChartBaseCurrency(Currency.USD)`
  - Verify state updated and saved to SharedPreferences
- [ ] Add test: 'updates and persists chart target currency'
- [ ] Add test: 'updates and persists chart time range'
- [ ] Add test: 'updates and persists selected tab index'
- [ ] Add test: 'handles invalid enum names gracefully'
  - Mock SharedPreferences with invalid enum string
  - Verify falls back to defaults
- [ ] Run tests: `flutter test test/src/storage/user_prefs_notifier_test.dart`

### 7. Add widget tests for charts persistence

**File:** `test/src/screens/charts/charts_screen_persistence_test.dart` (new file)

Follow pattern from `convert_screen_persistence_test.dart`:

- [ ] Add test setup with `DioAdapter` for mocking API calls
- [ ] Add test: 'restores saved chart preferences on app start'
  - Set mock values for chart currencies and time range
  - Launch app and navigate to Charts tab
  - Verify UI shows saved selections
- [ ] Add test: 'uses default chart preferences when none saved'
  - Empty SharedPreferences
  - Verify defaults (GBP, EUR, 1Y)
- [ ] Add test: 'persists chart base currency changes'
  - Change base currency in UI
  - Verify saved to SharedPreferences
- [ ] Add test: 'persists chart target currency changes'
- [ ] Add test: 'persists time range changes'
  - Tap different time range button
  - Verify persisted
- [ ] Add test: 'persists tab selection'
  - Switch between Convert and Charts tabs
  - Verify tab index saved
- [ ] Run tests: `flutter test test/src/screens/charts/charts_screen_persistence_test.dart`

### 8. Final verification

- [ ] Run full test suite: `flutter test`
- [ ] Verify all tests pass
- [ ] Run `flutter analyze`
- [ ] Manual testing:
  - [ ] Set chart currencies and time range
  - [ ] Switch to Charts tab
  - [ ] Restart app (hot restart)
  - [ ] Verify app opens on Charts tab with saved settings
  - [ ] Switch to Convert tab and restart
  - [ ] Verify app opens on Convert tab

## Storage Keys

All keys use the `user_prefs/` prefix for consistency:

- `user_prefs/base_currency` - Convert screen base currency
- `user_prefs/amount` - Convert screen amount
- `user_prefs/target_currencies` - Convert screen target list
- `user_prefs/chart_base_currency` - Charts base currency (new)
- `user_prefs/chart_target_currency` - Charts target currency (new)
- `user_prefs/chart_time_range` - Charts time range (new)
- `user_prefs/selected_tab_index` - Selected tab 0=Convert, 1=Charts (new)

## Key Considerations

### Error Handling

- Invalid enum names: Use try-catch with fallback to defaults
- Missing keys: Each key independently falls back to default
- Invalid tab index: Clamp to valid range (0-1)

### Separation of Concerns

- Convert screen and Charts screen have separate currency selections
- User might want different currencies in each screen
- Tab index is independent preference

### Benefits of Existing Architecture

- Leverages proven SharedPreferences setup
- Same eager initialization pattern
- Consistent with Convert screen persistence
- No additional dependencies needed

### Testing Strategy

- Unit tests verify `UserPrefsNotifier` saves/loads correctly
- Widget tests verify UI integration
- Use same mocking approach as Convert screen tests
- Test both happy path and error cases

## Riverpod 3.0 Conventions

Following established patterns in codebase:

- Provider access: `ref.watch(userPrefsProvider)` for state
- Notifier access: `ref.read(userPrefsProvider.notifier)` for updates
- Use `.requireValue` for synchronous SharedPreferences access
- Keep notifier in same file as data model

## Testing Checklist

After implementation, verify:

- [ ] Unit tests pass for all new UserPrefsNotifier methods
- [ ] Widget tests pass for charts persistence
- [ ] Full test suite passes (`flutter test`)
- [ ] No analyzer warnings (`flutter analyze`)
- [ ] Chart preferences persist after app restart
- [ ] Tab selection persists after app restart
- [ ] Base currency changes save independently
- [ ] Target currency changes save independently
- [ ] Time range changes save independently
- [ ] Handles missing/corrupted keys gracefully
- [ ] Falls back to defaults when no saved data
- [ ] Convert and Charts screens maintain separate currencies

## Future Enhancements (Out of Scope)

- Export/import all preferences as JSON
- Reset to defaults button in settings
- Per-user preferences (if multi-user support added)
- Cloud sync of preferences
- Preference history/undo
