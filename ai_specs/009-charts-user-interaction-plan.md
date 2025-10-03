# Chart User Interaction Implementation Plan

## Overview

Add interactive touch functionality to the exchange rate chart, enabling users to tap/drag on the chart to display a vertical indicator line with a tooltip showing the exchange rate and date at the touched point, using fl_chart's built-in touch handling.

## Implementation

### Phase 1: Enable LineTouchData Configuration

- [ ] In `ExchangeRateChartContent` (line 148), replace `lineTouchData: const LineTouchData(enabled: false)` with full touch configuration
- [ ] Add `touchSpotThreshold: 5` to detect touches within 5 pixels
- [ ] Configure `getTouchLineStart` and `getTouchLineEnd` to return `-double.infinity` and `double.infinity` for full-height vertical line

### Phase 2: Implement Vertical Line Indicator

- [ ] Add `getTouchedSpotIndicator` callback that returns `TouchedSpotIndicatorData`
- [ ] Configure `FlLine` with appropriate color, strokeWidth (1.5-2), and optional dashArray for dashed line style
- [ ] Configure `FlDotData` to show a circular dot at the touched point with appropriate radius (4-6)

### Phase 3: Implement Tooltip Overlay

- [ ] Add `touchTooltipData` with `LineTouchTooltipData` configuration
- [ ] Implement `getTooltipItems` callback to format tooltip content:
  - Extract the date from `dataPoints[barSpot.x.toInt()].date`
  - Extract the rate from `barSpot.y`
  - Return `LineTooltipItem` with formatted date and rate using `TextSpan` children
- [ ] Configure `getTooltipColor` to set the tooltip background color

### Phase 4: Format Tooltip Content

- [ ] Format date display (e.g., "Aug 22, 2024" or "2024/08/22")
- [ ] Format rate display with appropriate decimal places (e.g., 4 decimal places: "1.1554")
- [ ] Apply appropriate text styles using theme colors instead of hardcoded colors
- [ ] Use multi-line layout with date on first line, rate on second line

## Implementation Notes

- The chart already has `dataPoints` indexed correctly (lines 64-66), so `barSpot.x.toInt()` will directly map to the data point
- Use fl_chart's built-in touch handling - no additional state management needed (do NOT use `selectedPoint` from `ChartsState`)
- Touch interaction is automatic - `fl_chart` handles show/hide/move behavior without additional state management
- Use theme colors (`Theme.of(context).colorScheme`) instead of hardcoded colors for consistency
- Test with different time ranges to ensure tooltip formatting works well for various date ranges
