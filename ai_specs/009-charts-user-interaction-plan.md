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

### Phase 3: Wire Touch Events to State Management

- [ ] In `ExchangeRateChartContent`, pass `dataPoints` as parameter (needed to map touch index to ChartDataPoint)
- [ ] Convert `ExchangeRateChartContent` to `ConsumerWidget` to access `ref`
- [ ] Add `touchCallback` to `LineTouchData` configuration
- [ ] In `touchCallback`, when `touchResponse.lineBarSpots` is not empty:
  - Get the touched point: `dataPoints[touchedSpot.x.toInt()]`
  - Call `ref.read(chartsControllerProvider.notifier).setSelectedPoint(touchedPoint)`
- [ ] In `touchCallback`, when `touchResponse.lineBarSpots` is empty (user stopped touching):
  - Call `ref.read(chartsControllerProvider.notifier).clearSelectedPoint()`

## Implementation Notes

### Architecture (Already in Place)

- **ExchangeRateHeader** (line 22-23) already watches `chartsControllerProvider` and `chartDataProvider`
- **ExchangeRateHeader** (line 32) already uses `chartsState.selectedPoint ?? dataPoints.last` to display either selected or latest point
- **ChartsController** already has `setSelectedPoint()` and `clearSelectedPoint()` methods
- When touch events update `selectedPoint`, ExchangeRateHeader automatically rebuilds with the new data

### Touch Event Flow

1. User taps/drags on chart → `touchCallback` fires
2. Extract touched `ChartDataPoint` from `dataPoints[touchedSpot.x.toInt()]`
3. Call `setSelectedPoint(touchedPoint)` → updates `ChartsState`
4. ExchangeRateHeader watches state → rebuilds showing selected point
5. User stops touching → `touchCallback` fires with empty spots
6. Call `clearSelectedPoint()` → `selectedPoint` becomes null
7. ExchangeRateHeader rebuilds showing latest point again

### Technical Details

- The chart has `dataPoints` indexed correctly (lines 64-66), so `barSpot.x.toInt()` directly maps to the data point
- No tooltip overlay needed - ExchangeRateHeader serves as the data display
- Use theme colors (`Theme.of(context).colorScheme`) instead of hardcoded colors for consistency
- Test with different time ranges to ensure interaction works correctly
