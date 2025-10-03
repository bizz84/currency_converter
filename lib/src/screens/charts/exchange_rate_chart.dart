import '/src/data/chart_data_point.dart';
import '/src/data/chart_time_range.dart';
import '/src/screens/charts/chart_data_provider.dart';
import '/src/screens/charts/charts_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExchangeRateChart extends ConsumerWidget {
  const ExchangeRateChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chartDataAsync = ref.watch(chartDataProvider);
    final timeRange = ref.watch(chartsControllerProvider).timeRange;

    return chartDataAsync.when(
      data: (dataPoints) {
        if (dataPoints.isEmpty) {
          return const Center(
            child: Text('No data available'),
          );
        }

        // 1D range doesn't have meaningful data (markets closed on weekends)
        // or need at least 2 data points with different rates
        if (timeRange == ChartTimeRange.oneDay ||
            dataPoints.length < 2 ||
            dataPoints.every((p) => p.rate == dataPoints.first.rate)) {
          return const Center(
            child: Text(
              'Insufficient data for selected time range.\nTry selecting a longer period.',
              textAlign: TextAlign.center,
            ),
          );
        }

        return ExchangeRateChartContent(dataPoints: dataPoints);
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => Center(
        child: Text(
          'Error loading chart data',
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ),
    );
  }
}

class ExchangeRateChartContent extends StatelessWidget {
  const ExchangeRateChartContent({
    super.key,
    required this.dataPoints,
  });

  final List<ChartDataPoint> dataPoints;

  @override
  Widget build(BuildContext context) {
    // Convert ChartDataPoint to FlSpot
    final spots = dataPoints.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.rate);
    }).toList();

    // Calculate min/max for Y-axis
    final rates = dataPoints.map((p) => p.rate).toList();
    final minRate = rates.reduce((a, b) => a < b ? a : b);
    final maxRate = rates.reduce((a, b) => a > b ? a : b);

    // Add some padding to min/max
    final padding = (maxRate - minRate) * 0.1;
    final yMin = minRate - padding;
    final yMax = maxRate + padding;

    // Calculate Y-axis labels (high, medium, low)
    final yHigh = yMax;
    final yMedium = (yMax + yMin) / 2;
    final yLow = yMin;

    return Padding(
      padding: const EdgeInsets.only(right: 16, top: 16),
      child: LineChart(
        LineChartData(
          minY: yMin,
          maxY: yMax,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: false,
              color: Colors.blue,
              barWidth: 2,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
          ],
          titlesData: FlTitlesData(
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
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: (yMax - yMin) / 2 > 0 ? (yMax - yMin) / 2 : 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withValues(alpha: 0.2),
                strokeWidth: 1,
              );
            },
          ),
          borderData: FlBorderData(show: false),
          lineTouchData: LineTouchData(
            enabled: true,
            touchSpotThreshold: 5,
            getTouchLineStart: (_, _) => -double.infinity,
            getTouchLineEnd: (_, _) => double.infinity,
          ),
        ),
      ),
    );
  }
}
