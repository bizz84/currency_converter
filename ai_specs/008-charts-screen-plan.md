# Charts Screen Implementation Plan

## Overview

Implement an interactive charts screen that displays exchange rate history between two currencies with time range selection (1D, 1W, 1M, 3M, 1Y, 5Y, 10Y) using the FL Chart library and the existing Frankfurter API time series endpoint.

## Implementation

### Phase 1: Dependencies and Data Layer
- [x] Add `fl_chart` package to `pubspec.yaml` dependencies
- [x] Run `flutter pub get` to install the new dependency
- [x] Create `ChartTimeRange` enum with values (oneDay, oneWeek, oneMonth, threeMonths, oneYear, fiveYears, tenYears) in `/src/data/chart_time_range.dart`
- [x] Create extension on `ChartTimeRange` for label strings and date calculations (implemented as enhanced enum with members)
- [x] Create `ChartDataPoint` model class in `/src/data/chart_data_point.dart` to represent (date, rate) pairs

### Phase 2: State Management
- [x] Create `ChartsController` (Riverpod notifier) in `/src/screens/charts/charts_controller.dart` to manage:
  - Selected base currency (default: GBP)
  - Selected target currency (default: EUR)
  - Selected time range (default: oneYear)
  - Optional selected data point (for tap interaction)
- [x] Create `chartDataProvider` (Riverpod provider) to fetch and transform time series data into chart points
- [x] Handle loading, error, and success states for chart data (delegated to Riverpod AsyncValue)

### Phase 3: UI Widgets and Initial Integration
- [x] Create `CurrencySelectorRow` widget in `/src/screens/charts/currency_selector_row.dart`
  - Side-by-side currency selectors with swap icon in the middle
  - Reuse existing `CurrencySelector` widget
  - Integrate with `AdaptiveCurrencyPicker` for selection
- [x] Create `ExchangeRateHeader` widget in `/src/screens/charts/exchange_rate_header.dart`
  - Display current/selected exchange rate (e.g., "1 GBP = 1.156813 EUR")
  - Show change indicator with percentage (red dot + text like "-0.0301 (-2.537%) Past year")
  - Handle both live (latest) and historical (on tap) rate display
  - Add Skeletonizer for loading state to prevent layout shifts
  - Use `ExchangeRateHeaderContent` reusable widget class instead of build helper
- [x] Create `TimeRangeSelector` widget in `/src/screens/charts/time_range_selector.dart`
  - Horizontal row of chips/buttons for time ranges (1D, 1W, 1M, 3M, 1Y, 5Y, 10Y)
  - Use `ChoiceChip` with `showCheckmark: false` and `StadiumBorder` shape
  - Highlight selected range
  - Update controller state on selection
- [x] Update `ChartsScreen` with header widgets (without chart):
  - Replace placeholder with basic layout using Padding/Column
  - Add `CurrencySelectorRow` at top
  - Add `ExchangeRateHeader` below selectors
  - Add `TimeRangeSelector` below header
  - Add placeholder for chart area
  - Use constants from `app_sizes.dart` for spacing

### Phase 4: Chart Implementation and Final Integration
- [ ] Create `ExchangeRateChart` widget in `/src/screens/charts/exchange_rate_chart.dart`
  - Configure `LineChart` from fl_chart with proper styling
  - Map `ChartDataPoint` data to `FlSpot` points
  - Implement Y-axis labels (high, medium, low values)
  - Add horizontal grid lines at Y-axis label positions
  - Style line with appropriate color and thickness
- [ ] Implement touch interaction to show vertical line and selected point
  - Use `LineTouchData` configuration
  - Update controller with selected data point on tap/hold
  - Clear selected point when touch ends
  - Show indicator dot at touched position
- [ ] Integrate `ExchangeRateChart` into `ChartsScreen`:
  - Replace placeholder with actual chart widget
  - Handle loading states with CircularProgressIndicator
  - Handle error states with error message display
  - Ensure responsive layout works on different screen sizes

### Phase 5: Testing and Refinement
- [ ] Manual test: Currency selection works and updates chart
- [ ] Manual test: Time range selection fetches correct data
- [ ] Manual test: Touch interaction shows vertical line and updates header
- [ ] Manual test: Chart displays correctly with proper scaling
- [ ] Manual test: Error handling when API fails
- [ ] Manual test: Loading states display properly
- [ ] Run `flutter analyze` to ensure no issues
- [ ] Verify UI matches design preview

## Implementation Notes

**Key Considerations:**
- Reuse existing `CurrencySelector` and `AdaptiveCurrencyPicker` widgets
- Use absolute imports pattern (`/src/...`)
- Follow existing patterns for Riverpod state management
- Use constants from `app_sizes.dart` for spacing
- Avoid hardcoding font sizes/weights - use theme properties
- Create small reusable widgets instead of `_buildX` helper methods
- Build runner is assumed to be running in watch mode

**Date Calculation:**
- For time ranges, calculate start and end dates relative to today
- API expects dates in YYYY-MM-DD format
- Handle edge cases (e.g., 1D may need special handling vs time series)

**Chart Interaction:**
- Touch callback updates selected point in controller
- Header reactively displays selected point's rate or falls back to latest
- Vertical line indicator should be subtle but visible

**Future Enhancements (out of scope):**
- Export chart as image
- Add more chart types (candlestick, bar)
- Compare multiple currencies on same chart
- Zoom/pan gestures for detailed exploration
