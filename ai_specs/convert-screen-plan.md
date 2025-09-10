# Convert Screen Implementation Plan

## Phase 1: App Structure & Navigation
- [x] Replace default Flutter demo app with currency converter app
- [x] Set up bottom navigation bar with Convert and Charts tabs
- [x] Create placeholder screens for both tabs
- [x] Configure Material 3 theme with appropriate color scheme
- [x] Set up basic routing between screens

## Phase 2: Convert Screen Layout
- [x] Create `ConvertScreen` stateful widget
- [x] Add app bar with title "Currency Converter"
- [x] Create main container with padding and scroll view
- [x] Set up basic column layout for screen sections

## Phase 3: Base Currency Section
- [x] Create base currency dropdown selector
- [x] Add amount input field with numeric keyboard
- [x] Implement thousand separator formatting
- [x] Add currency flag/icon display
- [x] Style with card or elevated container

## Phase 4: Currency Selector Component
- [x] Create reusable `CurrencySelector` widget
- [x] Implement dropdown with search functionality
- [x] Display currency code, name, and flag
- [ ] Add recently used currencies section
- [x] Implement currency filtering/search

## Phase 5: Target Currencies List
- [x] Create `CurrencyConversionTile` widget
- [x] Display currency info (flag, code, name)
- [x] Show exchange rate relative to base
- [x] Display converted amount
- [x] Add remove/delete button or swipe action

## Phase 6: Multiple Currencies Feature
- [x] Implement "Add Currency" button (FAB or inline)
- [x] Create currency picker dialog/modal
- [x] Prevent duplicate currency selection
- [ ] Limit maximum number of currencies (e.g., 10)
- [x] Store selected currencies in state

## Phase 7: Network Integration with FrankfurterClient
- [ ] Create `frankfurter_client_provider.dart` using `@riverpod` annotation
- [ ] Create providers for:
  - [ ] FrankfurterClient instance (using existing Dio provider from `dio_provider.dart`)
  - [ ] Available currencies (`@riverpod` FutureProvider)
  - [ ] Latest exchange rates (`@riverpod` FutureProvider with family for base currency)
  - [ ] Exchange rate for currency pair (computed provider)
- [ ] Run `dart run build_runner build` to generate provider code
- [ ] Wrap app with `ProviderScope` in main.dart
- [ ] Convert `ConvertScreen` to `ConsumerStatefulWidget`
- [ ] Replace FakeDataProvider with provider watches:
  - [ ] Currency list from currencies provider
  - [ ] Exchange rates from rates provider
  - [ ] Currency flags can remain in FakeDataProvider or move to a map
- [ ] Implement AsyncValue handling for loading/error/data states
- [ ] Add RefreshIndicator for pull-to-refresh
- [ ] Use `ref.invalidate()` to refresh rates
- [ ] Add periodic refresh using Timer
- [ ] Show CircularProgressIndicator during initial load
- [ ] Display SnackBar or error widget on API failures
- [ ] Cache rates using provider's built-in caching

## Phase 8: Drag & Drop Reordering
- [ ] Wrap currency list in `ReorderableListView`
- [ ] Add drag handle to each tile
- [ ] Implement reorder callback
- [ ] Add haptic feedback on drag
- [ ] Animate reordering transitions

## Phase 9: Live Conversion Updates
- [x] Implement real-time conversion as user types
- [ ] Add debouncing for performance
- [x] Update all target currencies simultaneously
- [x] Handle edge cases (empty input, zero, invalid)
- [x] Format output numbers appropriately

## Phase 10: Fake Data Provider
- [x] Create `FakeDataProvider` class
- [x] Add comprehensive currency list (30+ currencies)
- [x] Generate realistic exchange rates
- [x] Implement rate calculation logic
- [ ] Add method to simulate rate updates

## Phase 11: Visual Polish
- [ ] Add loading states and shimmer effects
- [ ] Implement smooth animations for add/remove
- [ ] Add empty state when no target currencies
- [ ] Style with consistent spacing and typography
- [ ] Ensure responsive layout for different screen sizes

## Phase 12: Additional Features
- [x] Add "Last updated" timestamp
- [x] Implement pull-to-refresh gesture
- [ ] Add refresh countdown timer
- [ ] Show update animation when rates change
- [ ] Add swap button between base and target currency

## Phase 13: Testing & Refinement
- [ ] Test with various amounts (large, small, decimals)
- [ ] Verify all currency conversions calculate correctly
- [ ] Test reordering with different list sizes
- [ ] Ensure keyboard behavior is correct
- [ ] Test on different screen sizes and orientations

## Code Structure

### Files to Create:
```
lib/
├── main.dart (update)
├── src/
│   ├── app.dart
│   ├── screens/
│   │   ├── convert_screen.dart
│   │   └── charts_screen.dart
│   ├── widgets/
│   │   ├── currency_selector.dart
│   │   ├── currency_conversion_tile.dart
│   │   ├── amount_input_field.dart
│   │   └── last_updated_footer.dart
│   └── providers/
│       └── fake_data_provider.dart
```

### Key State Variables:
- `String baseCurrency` - Currently selected base currency
- `double amount` - Amount to convert
- `List<String> targetCurrencies` - List of selected target currencies
- `Map<String, Map<String, double>> exchangeRates` - Fake exchange rates
- `DateTime lastUpdated` - Timestamp of last update

### Dependencies to Consider:
- `intl` - For number formatting
- `flutter_svg` or `country_flags` - For currency flags
- `provider` or `riverpod` - For state management (optional for now)

## Success Criteria:
- ✅ User can select base currency from dropdown
- ✅ User can input amount with proper formatting
- ✅ User can add multiple target currencies
- ✅ Conversions update in real-time as amount changes
- ✅ User can reorder currencies via drag & drop
- ✅ User can remove currencies
- ✅ App shows last updated time
- ✅ UI is responsive and follows Material Design
- ✅ All interactions feel smooth and intuitive