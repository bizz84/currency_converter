# Chart Y-Axis Labels Fix - Summary

## Problem

The chart y-axis was showing duplicate labels in some cases. For example, the bottom label "1.1413" appeared twice, resulting in 4 labels instead of 3 (top, middle, bottom).

![Original issue showing duplicate bottom label](img/010-line-chart-bottom-y-label-repeated.png)

## Root Cause

The original implementation used a **tolerance-based approach** to determine which labels to show:

```dart
// Original problematic code
final padding = (maxRate - minRate) * 0.1;
final yMin = minRate - padding;
final yMax = maxRate + padding;

getTitlesWidget: (value, meta) {
  if ((value - yHigh).abs() < padding / 2) {
    return Text(yHigh.toStringAsFixed(4), ...);
  } else if ((value - yMedium).abs() < padding / 2) {
    return Text(yMedium.toStringAsFixed(4), ...);
  } else if ((value - yLow).abs() < padding / 2) {
    return Text(yLow.toStringAsFixed(4), ...);
  }
  return const SizedBox.shrink();
}
```

### Why This Failed

From debug logs, we discovered that fl_chart calls `getTitlesWidget` for each grid value it generates:

```
[log] value: 1.14127, meta min: 1.14127, max: 1.16323
[log] value: 1.1420000000000001, meta min: 1.14127, max: 1.16323
[log] value: 1.1440000000000001, meta min: 1.14127, max: 1.16323
...
```

**The problem**: Multiple consecutive callback values (1.14127 and 1.1420000000000001) both fell within the tolerance range of `yLow`, causing duplicate labels.

## Key Learnings

### 1. Understanding fl_chart's Callback Mechanism

The `getTitlesWidget` callback is invoked by fl_chart for **each grid value** it generates internally. We cannot control which values fl_chart passes to this callback.

### 2. The meta Object

The `meta` parameter provides crucial information:
- `meta.min` - The actual minimum value fl_chart uses for the axis
- `meta.max` - The actual maximum value fl_chart uses for the axis

These values are guaranteed to be included in the callback sequence and can be matched with exact equality.

### 3. Tolerance-Based Matching is Unreliable

Any tolerance-based approach (e.g., `(value - target).abs() < threshold`) can match multiple consecutive grid values, leading to duplicate labels. Even sophisticated approaches like tracking "closest to midpoint" add unnecessary complexity.

## The Solution

### Simple and Deterministic Approach

The updated implementation uses **exact equality checks** against `meta.min` and `meta.max`:

```dart
// Calculate min/max directly from data (no padding)
final rates = dataPoints.map((p) => p.rate).toList();
final yMin = rates.reduce((a, b) => a < b ? a : b);
final yMax = rates.reduce((a, b) => a > b ? a : b);

getTitlesWidget: (value, meta) {
  if (value == meta.min) {
    return SideTitleWidget(
      meta: meta,
      child: Text(
        value.toStringAsFixed(4),
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  } else if (value == meta.max) {
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

### Key Changes

1. **No padding**: Removed the 10% padding calculation. Using exact min/max from data shows the actual data range.

2. **Exact equality**: Checking `value == meta.min` and `value == meta.max` ensures only two labels are shown.

3. **SideTitleWidget**: Using `SideTitleWidget` instead of plain `Text` for proper axis positioning and alignment.

4. **No middle label**: Simplified to show only top and bottom labels.

### Visual Separation with BorderData

Instead of using grid lines (which require careful interval calculation), we now use `BorderData` to draw horizontal lines at the top and bottom:

```dart
gridData: FlGridData(show: false),
borderData: FlBorderData(
  show: true,
  border: Border.symmetric(
    horizontal: BorderSide(
      color: Colors.grey.withValues(alpha: 0.8),
      width: 1,
    ),
  ),
),
```

This approach:
- Provides clear visual boundaries for the chart
- Aligns perfectly with the min/max labels
- Avoids the complexity of drawing a middle grid line
- Creates a clean, professional appearance

## Why We Removed the Middle Label

Initial attempts to show a middle label included:

1. **Median from data points**: Using `sortedRates[sortedRates.length ~/ 2]`, but this value might not be in fl_chart's callback sequence.

2. **Sentinel-based approach**: Tracking the first callback value above the midpoint, but this added unnecessary complexity.

3. **Closest to midpoint**: Calculating distances to find the closest value, but this was overcomplicated.

**Final decision**: Show only top and bottom labels with horizontal borders. This:
- Guarantees exactly 2 labels (no duplicates possible)
- Provides clear min/max information
- Simplifies the implementation significantly
- Creates a cleaner, more professional appearance

## Implementation Files

- Chart widget: `lib/src/screens/charts/exchange_rate_chart.dart:94-116`
- Border configuration: `lib/src/screens/charts/exchange_rate_chart.dart:140-148`

## Future Enhancements (Out of Scope)

If a middle label is needed in the future:
- Could use `interval` parameter in `SideTitles` to control automatic label frequency
- Could use `FlGridData` with `horizontalInterval` to draw a middle grid line with corresponding label
- Would need careful calculation to ensure the middle value is included in fl_chart's grid generation

## Conclusion

The key insight is that **fl_chart controls which values appear in getTitlesWidget**, so we must work with the values it provides (`meta.min` and `meta.max`) rather than trying to match arbitrary target values with tolerance checks.

The solution is simple, deterministic, and guarantees no duplicate labels while providing a clean visual presentation with BorderData.
