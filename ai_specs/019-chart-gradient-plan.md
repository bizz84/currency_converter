# Chart Gradient Implementation Plan

## Overview

Add a gradient fill underneath the line chart in the charts screen to enhance visual appeal and make the data area more prominent. The gradient will fade from the chart line color at the top to transparent at the bottom.

## Implementation

### Phase 1: Add gradient configuration to LineChartBarData
- [x] Read the current chart line color from theme (already using `Theme.of(context).appColors.chartLine`)
- [x] Update the `belowBarData` property in `LineChartBarData` to enable gradient fill
- [x] Configure `BarAreaData` with `show: true` and a gradient that fades from chart line color to transparent
- [x] Test the visual appearance matches the mockup
- [x] Add left and right border lines to complete the chart frame (uses same color and thickness as top/bottom borders)

### Phase 2: Testing and refinement
- [x] Run the app and navigate to the charts screen
- [x] Verify gradient appears correctly for different time ranges
- [x] Test with different currency pairs to ensure consistency
- [x] Verify the gradient doesn't interfere with touch interactions
- [x] Check that the gradient looks good in both light and dark themes (if applicable)

## Implementation Notes

**Key considerations:**
- The fl_chart library's `BarAreaData` supports gradient fills through the `gradient` property
- The gradient should use the existing `chartLine` color from the theme for consistency
- The gradient opacity should fade from ~20-30% at the top to 0% at the bottom for a subtle effect
- No changes needed to data providers, controllers, or other chart components

**Migration strategy:**
- This is a pure visual enhancement with no breaking changes
- Modified `exchange_rate_chart.dart:85` to add gradient below the chart line
- Modified `exchange_rate_chart.dart:133` to add complete border frame (all four sides)

**Future enhancements (out of scope):**
- Different gradient colors for positive/negative trends
- Customizable gradient opacity in user settings
- Animated gradient transitions
