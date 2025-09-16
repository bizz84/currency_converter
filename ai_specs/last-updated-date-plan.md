# Plan: Update LastUpdatedWidget to Use Server Time

## Overview
Update the LastUpdatedWidget widget to display the actual API response date from CurrencyRates (server time) instead of the client-side refresh timestamp.

## Current Implementation Issues
- `ConvertScreen` tracks `lastUpdated` as local DateTime (line 25)
- Updates `lastUpdated` on client-side refresh actions
- Doesn't reflect actual data freshness from the API
- Timer refreshes every 60 seconds (too frequent)
- `LastUpdatedWidget` widget exists but is not being used in the app

## Implementation Steps

### 1. Update CurrencyRates Model (`lib/src/data/currency_rates.dart`)
- [x] Add a DateTime getter that parses the date string from the API
- [x] The date field is in format `yyyy-mm-dd` from the Frankfurter API
- [x] Keep the existing String date field for backward compatibility
```dart
DateTime get dateTime => DateTime.parse(date);
```

### 2. Update ConvertScreen State Management (`lib/src/screens/convert/convert_screen.dart`)
- [x] **Remove** the local `lastUpdated` DateTime state variable (line 25)
- [x] **Remove** manual updates to `lastUpdated` in:
  - [x] Timer callback (lines 34-36)
  - [x] Refresh callback (lines 65-66)
- [x] Extract the server date from CurrencyRates when data is available

### 3. Integrate LastUpdatedWidget Widget (Future Task)
- [x] Import `last_updated_footer.dart`
- [x] Add the widget to the ConvertScreen layout
- [x] Only display when rates data is successfully loaded
- [x] Pass the server DateTime from CurrencyRates

### 4. Update LastUpdatedWidget Logic (`lib/src/screens/convert/last_updated_footer.dart`)
- [x] Modify `_formatLastUpdated()` method to show server data timestamp
- [x] The DateTime will represent when the exchange rates were last updated on the server
- [x] Updated to show absolute date format: "16 Sep 2025"

### 5. Update Refresh Timer Configuration
- [x] Change timer duration from 60 seconds to hourly (3600 seconds)
- [x] Location: `ConvertScreen` line 32
```dart
Timer.periodic(const Duration(hours: 1), (timer) {
  ref.invalidate(latestRatesProvider(baseCurrency));
});
```

## Benefits
- **Accurate Information**: Users see when exchange rates were actually updated by the API
- **Reduced API Calls**: Hourly refresh is more appropriate for exchange rate data
- **Better UX**: Users understand data freshness relative to market updates
- **Cleaner State Management**: Removes unnecessary local state tracking

## Testing Considerations
- [ ] Verify date parsing from API response works correctly
- [ ] Test that the footer updates when switching base currencies
- [ ] Ensure refresh button properly invalidates the provider
- [ ] Confirm hourly timer works as expected

## Future Enhancements
- Add visual indicator when data is stale (e.g., > 24 hours old)
- Consider caching strategy based on server update times
- Add tooltip explaining data update frequency