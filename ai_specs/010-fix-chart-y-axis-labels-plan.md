# Plan: Fix Y-Axis Label Duplication in Exchange Rate Chart

## Overview

The chart y-axis currently shows duplicate labels (bottom label "1.1413" appears twice) because the tolerance-based conditional logic matches multiple consecutive values from fl_chart's grid generation. The fix will replace the tolerance-based approach with exact position matching using the `meta` object to ensure only three labels are shown: top, middle, and bottom.

## Root Cause Analysis

From the debug logs, `fl_chart` calls `getTitlesWidget` for each grid value:
```
[log] value: 1.14127, meta min: 1.14127, max: 1.16323
[log] value: 1.1420000000000001, meta min: 1.14127, max: 1.16323
[log] value: 1.1440000000000001, meta min: 1.14127, max: 1.16323
...
[log] value: 1.16323, meta min: 1.14127, max: 1.16323
```

The current code uses tolerance-based matching:
```dart
if ((value - yLow).abs() < padding / 2) { ... }
```

**Problem:** Multiple consecutive values (1.14127 and 1.1420000000000001) both fall within the tolerance range of `yLow`, causing duplicate labels.

**Solution:** Use exact position matching with `meta.min`, `meta.max`, and the calculated midpoint instead of tolerance-based checks.

## Implementation

### Phase 1: Update getTitlesWidget Logic

File: `lib/src/screens/charts/exchange_rate_chart.dart`

- [ ] Replace the tolerance-based conditional checks with exact position matching
- [ ] Check if `value == meta.min` for the bottom label
- [ ] Check if `value == meta.max` for the top label
- [ ] Check if `value == (meta.min + meta.max) / 2` for the middle label
- [ ] Return `SideTitleWidget` with `meta` parameter as specified in the bug report
- [ ] Keep the same label formatting (4 decimal places using `toStringAsFixed(4)`)
- [ ] Remove the debug log statement on line 107

Updated code structure:
```dart
getTitlesWidget: (value, meta) {
  // Show only high, medium, low labels
  if (value == meta.max) {
    return SideTitleWidget(
      meta: meta,
      child: Text(
        value.toStringAsFixed(4),
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  } else if (value == (meta.min + meta.max) / 2) {
    return SideTitleWidget(
      meta: meta,
      child: Text(
        value.toStringAsFixed(4),
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  } else if (value == meta.min) {
    return SideTitleWidget(
      meta: meta,
      child: Text(
        value.toStringAsFixed(4),
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
  return const SizedBox.shrink();
}
```

### Phase 2: Testing & Verification

- [ ] Run the app with `flutter run`
- [ ] Navigate to the Charts screen
- [ ] Verify only 3 labels are shown (top, middle, bottom) with no duplicates
- [ ] Test with different time ranges to ensure consistency:
  - [ ] 1W (1 Week)
  - [ ] 1M (1 Month)
  - [ ] 3M (3 Months)
  - [ ] 1Y (1 Year)
  - [ ] 5Y (5 Years)
  - [ ] 10Y (10 Years)
- [ ] Test with different currency pairs (e.g., USD/EUR, GBP/USD, JPY/EUR)
- [ ] Verify labels align correctly with grid lines
- [ ] Run `flutter analyze` to ensure no code issues
- [ ] Run existing tests with `flutter test` to ensure no regressions

## Implementation Notes

**Key Considerations:**
- The `meta` object provides the actual min/max that fl_chart uses for the axis, which may differ slightly from our calculated `yMin`/`yMax` due to internal rounding or padding
- Using exact equality checks (`value == meta.min`, `value == meta.max`) is more reliable than tolerance-based matching because fl_chart generates these grid values internally
- The middle position should be calculated as `(meta.min + meta.max) / 2` to ensure it aligns with fl_chart's grid generation

**Floating-Point Precision:**
- Exact equality should work since fl_chart generates these values internally with consistent precision
- If exact equality fails in testing, we may need to add a very small epsilon tolerance (e.g., `(value - meta.min).abs() < 0.0001`), but this should not be necessary

**Why SideTitleWidget:**
- The bug report specifies using `SideTitleWidget` instead of plain `Text`
- `SideTitleWidget` properly handles axis positioning and alignment
- It requires the `meta` parameter for proper rendering

**Alternative Approaches (if needed):**
- Could use the `interval` parameter in `SideTitles` to control automatic label frequency
- Could add a `getTitles` callback to have more control over which values are used
- Could track which labels have been shown to prevent duplicates

**Future Enhancements (Out of Scope):**
- Dynamic decimal places based on value range (e.g., show 2 decimals for large values, 6 for very small values)
- Currency-specific formatting with appropriate symbols
- Adaptive grid intervals for very small or very large value ranges
- Accessibility improvements for label reading
