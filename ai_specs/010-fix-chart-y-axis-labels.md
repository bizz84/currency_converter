# Bug report

In some cases, the top or bottom y-axis label is repeated twice, as shown in `img/010-line-chart-bottom-y-label-repeated.png`.

As a result, 4 labels are shown instead of 3 (top, middle, bottom).

Bewow is the code responsible for this in `exchange_rate_chart.dart`:

```dart
FlTitlesData(
  leftTitles: AxisTitles(
    sideTitles: SideTitles(
      showTitles: true,
      reservedSize: 60,
      getTitlesWidget: (value, meta) {
        // Show only high, medium, low labels
        if ((value - yHigh).abs() < padding / 2) {
          return Text(
            yHigh.toStringAsFixed(4),
            style: Theme.of(context).textTheme.bodySmall,
          );
        } else if ((value - yMedium).abs() < padding / 2) {
          return Text(
            yMedium.toStringAsFixed(4),
            style: Theme.of(context).textTheme.bodySmall,
          );
        } else if ((value - yLow).abs() < padding / 2) {
          return Text(
            yLow.toStringAsFixed(4),
            style: Theme.of(context).textTheme.bodySmall,
          );
        }
        return const SizedBox.shrink();
      },
    ),
  ),
  rightTitles: const AxisTitles(
    sideTitles: SideTitles(showTitles: false),
  ),
  topTitles: const AxisTitles(
    sideTitles: SideTitles(showTitles: false),
  ),
  bottomTitles: const AxisTitles(
    sideTitles: SideTitles(showTitles: false),
  ),
),
```

To debug this, I've added the following log in `getTitlesWidget`:

```
log('value: $value, meta min: ${meta.min}, max: ${meta.max}');
```

Here's an example output:

```
[log] value: 1.14127, meta min: 1.14127, max: 1.16323
[log] value: 1.1420000000000001, meta min: 1.14127, max: 1.16323
[log] value: 1.1440000000000001, meta min: 1.14127, max: 1.16323
[log] value: 1.1460000000000001, meta min: 1.14127, max: 1.16323
[log] value: 1.1480000000000001, meta min: 1.14127, max: 1.16323
[log] value: 1.1500000000000001, meta min: 1.14127, max: 1.16323
[log] value: 1.1520000000000001, meta min: 1.14127, max: 1.16323
[log] value: 1.1540000000000001, meta min: 1.14127, max: 1.16323
[log] value: 1.1560000000000001, meta min: 1.14127, max: 1.16323
[log] value: 1.1580000000000001, meta min: 1.14127, max: 1.16323
[log] value: 1.1600000000000001, meta min: 1.14127, max: 1.16323
[log] value: 1.1620000000000001, meta min: 1.14127, max: 1.16323
[log] value: 1.16323, meta min: 1.14127, max: 1.16323
```

Investigate why the labels show as they are in the screenshot, and formulate a plan to resolve this based so that the `getTitlesWidget` callback either returns a `SideTitleWidget` based on some updated (and fixes) conditional logic, as shown below.

```dart
if (/* fixed condition */) {
  return SideTitleWidget(
    meta: meta,
    child: Text(value.toStringAsFixed(4)),
  );
}
return const SizedBox.shrink();
```