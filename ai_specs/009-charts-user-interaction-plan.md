# Chart User Interaction Implementation Plan

## Overview

Add interactive touch functionality to the exchange rate chart, enabling users to tap/drag on the chart to display a vertical indicator line. When the vertical line is visible, the ExchangeRateHeader updates to show the exchange rate and date for the selected point (instead of showing a tooltip overlay on the chart).

## Implementation

### Phase 1: Enable LineTouchData Configuration ✓

- [x] In `ExchangeRateChartContent` (line 148), replace `lineTouchData: const LineTouchData(enabled: false)` with full touch configuration
- [x] Add `touchSpotThreshold: 5` to detect touches within 5 pixels
- [x] Configure `getTouchLineStart` and `getTouchLineEnd` to return `-double.infinity` and `double.infinity` for full-height vertical line

### Phase 2: Implement Vertical Line Indicator ✓

- [x] Add `getTouchedSpotIndicator` callback that returns `TouchedSpotIndicatorData`
- [x] Configure `FlLine` with appropriate color and strokeWidth: 1
- [x] Configure `FlDotData` to show a circular dot at the touched point with radius: 4

### Phase 3: Wire Touch Events to State Management ✓

- [x] In `ExchangeRateChartContent`, pass `dataPoints` as parameter (needed to map touch index to ChartDataPoint)
- [x] Convert `ExchangeRateChartContent` to `ConsumerWidget` to access `ref`
- [x] Add `touchCallback` to `LineTouchData` configuration
- [x] In `touchCallback`, when `touchResponse.lineBarSpots` is not empty:
  - Get the touched point: `dataPoints[touchedSpot.x.toInt()]`
  - Call `ref.read(chartSelectedPointProvider.notifier).setSelectedPoint(touchedPoint)`
- [x] In `touchCallback`, when `touchResponse.lineBarSpots` is empty (user stopped touching):
  - Call `ref.read(chartSelectedPointProvider.notifier).clearSelectedPoint()`

### Phase 4: Fix Unnecessary Rebuilds ✓

- [x] Create separate `ChartSelectedPointProvider` in `charts_controller.dart`
- [x] Remove `selectedPoint` from `ChartsState` (to prevent triggering data refetch)
- [x] Update `ExchangeRateHeader` to watch `chartSelectedPointProvider` instead
- [x] Update touch callbacks to use `chartSelectedPointProvider`
- [x] Add `clearSelectedPoint()` calls to all `ChartsController` methods (setBaseCurrency, setTargetCurrency, setTimeRange, swapCurrencies)

### Phase 5: UI Tweaks for Selected State ✓

- [x] In `ExchangeRateHeader`, add `_formatDate()` method using `intl` package (format: "16 Aug 2025")
- [x] In `ExchangeRateHeader`, update dot color logic:
  - When `selectedPoint` is null: show green/red dot based on positive/negative change
  - When `selectedPoint` is present: show blue dot
- [x] In `ExchangeRateHeader`, update time range display:
  - When `selectedPoint` is null: show time range description (e.g., "Past year")
  - When `selectedPoint` is present: show formatted date of selected point
- [x] In `ExchangeRateHeaderContent`, split text styling using `Text.rich`:
  - Change amount (e.g., "+0.0204 (+1.72%)") in green/red color
  - Date/time range text in standard text color
- [x] In `ExchangeRateChart`, hide tooltip overlay with `touchTooltipData: LineTouchTooltipData(getTooltipItems: (spots) => [])`

## Implementation Notes

### Final Architecture

- **ChartSelectedPointProvider** - Separate notifier for selected point state (prevents unnecessary rebuilds)
- **ExchangeRateHeader** - Watches `chartSelectedPointProvider` to display selected or latest point
- **ExchangeRateChartContent** - `ConsumerWidget` that updates selected point via touch callbacks
- **ChartsController** - Clears selected point when currency/time range changes
- When touch events update `chartSelectedPointProvider`, only ExchangeRateHeader rebuilds (not the chart)

### Touch Event Flow

1. User taps/drags on chart → `touchCallback` fires
2. Extract touched `ChartDataPoint` from `dataPoints[touchedSpot.x.toInt()]`
3. Call `chartSelectedPointProvider.notifier.setSelectedPoint(touchedPoint)`
4. Only ExchangeRateHeader rebuilds (watches `chartSelectedPointProvider`) showing selected point
5. User stops touching → `touchCallback` fires with empty spots
6. Call `chartSelectedPointProvider.notifier.clearSelectedPoint()`
7. ExchangeRateHeader rebuilds showing latest point again
8. User changes currency/time range → `ChartsController` methods automatically clear selected point

### Technical Details

- The chart has `dataPoints` indexed correctly (lines 64-66), so `barSpot.x.toInt()` directly maps to the data point
- No tooltip overlay needed - ExchangeRateHeader serves as the data display
- Use theme colors (`Theme.of(context).colorScheme`) instead of hardcoded colors for consistency
- Test with different time ranges to ensure interaction works correctly
