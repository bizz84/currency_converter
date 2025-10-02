# Currency Selector Improvements Plan

## Overview

Enhance the currency picker to show two sections: RECENT (currencies already in use and previously selected) and ALL (complete list of available currencies), improving user experience by surfacing frequently used currencies.

## Implementation

### Phase 1: MRU Storage Layer

- [x] Create `RecentCurrenciesStorage` class in `lib/src/storage/recent_currencies_storage.dart`
- [x] Add SharedPreferences key constant for storing recent currencies (`recentCurrenciesKey`)
- [x] Implement methods to save/load currency codes as ordered list
- [x] Add method to update MRU list (`addCurrency` - moves to front or adds new)
- [x] Create Riverpod provider for recent currencies storage (`recentCurrenciesStorageProvider`)
- [x] Verify code compiles: `flutter analyze && flutter test`

### Phase 2: In-Use Currencies Detection

- [x] Pass in-use currencies to `AdaptiveCurrencyPicker.show()` via `inUseCurrencies` parameter
- [x] Update picker to track both in-use and MRU currencies
- [x] Combine in-use + MRU into single RECENT section (preserve order: in-use first, then MRU)
- [x] Remove duplicates when a currency appears in both lists
- [x] Verify code compiles: `flutter analyze && flutter test`

### Phase 3: UI Updates - Sectioned List

- [x] Update `_CurrencyPickerContent` to display sectioned list
- [x] Add "RECENT" section header widget
- [x] Display recent currencies (in-use + MRU, deduplicated)
- [x] Add "ALL" section header widget
- [x] Display all available currencies
- [x] Maintain checkmark for selected currency in both sections
- [x] Ensure search filters across both sections
- [x] Verify code compiles: `flutter analyze`

### Phase 4: MRU Updates on Selection

- [x] Update currency selection handler to save to MRU storage (convert_screen.dart:184)
- [x] Ensure MRU persists across app restarts (via SharedPreferences)
- [x] Verify code compiles: `flutter analyze && flutter test`

## Implementation Notes

### Key Decisions Made
- Removed `excludedCurrencies` parameter in favor of `inUseCurrencies` for better semantic clarity
- `inUseCurrencies` serves dual purpose: defines RECENT section AND excludes from selection
- Recent currencies can appear in both RECENT and ALL sections (per spec)
- Selected currency shows checkmark in both sections
- Search filters currencies across both sections
- MRU list limited to 10 most recent currencies (configurable via `maxRecentCurrencies`)
- Invalid currency names in SharedPreferences are silently skipped during load

### Implementation Details
- **Storage**: `RecentCurrenciesStorage` (lib/src/storage/recent_currencies_storage.dart)
  - Uses Riverpod `@riverpod` class with state management
  - Persists to SharedPreferences at key `recent_currencies/mru_list`
  - `addCurrency()` method moves existing to front or adds new, enforces max limit
  - `clear()` method for testing/reset

- **UI Changes**: `AdaptiveCurrencyPicker` (lib/src/screens/convert/adaptive_currency_picker.dart)
  - New `inUseCurrencies` parameter replaces `excludedCurrencies`
  - RECENT section: in-use currencies first, then MRU (deduplicated)
  - ALL section: all available currencies except those in-use
  - Both sections use consistent ListTile styling with flag, name, description, checkmark

- **Integration**: `ConvertScreen` (lib/src/screens/convert/convert_screen.dart)
  - Passes `[baseCurrency, ...targetCurrencies]` as `inUseCurrencies`
  - Calls `recentCurrenciesStorageProvider.notifier.addCurrency()` on selection

### Migration Strategy
- No migration needed - new feature, no existing data
- App works normally if SharedPreferences fails (RECENT section empty, shows only ALL)

### Future Enhancements (Out of Scope)
- Add favorites/pinned currencies separate from MRU
- Allow manual reordering of recent currencies
- Show usage frequency counts
- Sync recent currencies across devices
- Unit tests for `RecentCurrenciesStorage` and currency merging logic
