# Convert Screen Implementation Plan

## Phase 1: App Structure & Navigation
- [ ] Replace default Flutter demo app with currency converter app
- [ ] Set up bottom navigation bar with Convert and Charts tabs
- [ ] Create placeholder screens for both tabs
- [ ] Configure Material 3 theme with appropriate color scheme
- [ ] Set up basic routing between screens

## Phase 2: Convert Screen Layout
- [ ] Create `ConvertScreen` stateful widget
- [ ] Add app bar with title "Currency Converter"
- [ ] Create main container with padding and scroll view
- [ ] Set up basic column layout for screen sections

## Phase 3: Base Currency Section
- [ ] Create base currency dropdown selector
- [ ] Add amount input field with numeric keyboard
- [ ] Implement thousand separator formatting
- [ ] Add currency flag/icon display
- [ ] Style with card or elevated container

## Phase 4: Currency Selector Component
- [ ] Create reusable `CurrencySelector` widget
- [ ] Implement dropdown with search functionality
- [ ] Display currency code, name, and flag
- [ ] Add recently used currencies section
- [ ] Implement currency filtering/search

## Phase 5: Target Currencies List
- [ ] Create `CurrencyConversionTile` widget
- [ ] Display currency info (flag, code, name)
- [ ] Show exchange rate relative to base
- [ ] Display converted amount
- [ ] Add remove/delete button or swipe action

## Phase 6: Multiple Currencies Feature
- [ ] Implement "Add Currency" button (FAB or inline)
- [ ] Create currency picker dialog/modal
- [ ] Prevent duplicate currency selection
- [ ] Limit maximum number of currencies (e.g., 10)
- [ ] Store selected currencies in state

## Phase 7: Drag & Drop Reordering
- [ ] Wrap currency list in `ReorderableListView`
- [ ] Add drag handle to each tile
- [ ] Implement reorder callback
- [ ] Add haptic feedback on drag
- [ ] Animate reordering transitions

## Phase 8: Live Conversion Updates
- [ ] Implement real-time conversion as user types
- [ ] Add debouncing for performance
- [ ] Update all target currencies simultaneously
- [ ] Handle edge cases (empty input, zero, invalid)
- [ ] Format output numbers appropriately

## Phase 9: Fake Data Provider
- [ ] Create `FakeDataProvider` class
- [ ] Add comprehensive currency list (30+ currencies)
- [ ] Generate realistic exchange rates
- [ ] Implement rate calculation logic
- [ ] Add method to simulate rate updates

## Phase 10: Visual Polish
- [ ] Add loading states and shimmer effects
- [ ] Implement smooth animations for add/remove
- [ ] Add empty state when no target currencies
- [ ] Style with consistent spacing and typography
- [ ] Ensure responsive layout for different screen sizes

## Phase 11: Additional Features
- [ ] Add "Last updated" timestamp
- [ ] Implement pull-to-refresh gesture
- [ ] Add refresh countdown timer
- [ ] Show update animation when rates change
- [ ] Add swap button between base and target currency

## Phase 12: Testing & Refinement
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