import 'dart:developer';

import '/src/data/chart_data_point.dart';
import '/src/data/chart_time_range.dart';
import '/src/network/api_client.dart';
import '/src/screens/charts/charts_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chart_data_provider.g.dart';

@riverpod
Future<List<ChartDataPoint>> chartData(Ref ref) async {
  final chartsState = ref.watch(chartsControllerProvider);
  final apiClient = ref.watch(apiClientProvider);

  final today = DateTime.now();
  final startDate = chartsState.timeRange.getStartDate(today);

  final startDateStr = ChartTimeRange.formatDate(startDate);
  final endDateStr = ChartTimeRange.formatDate(today);

  final timeSeriesRates = await apiClient.getTimeSeriesRates(
    startDateStr,
    endDateStr,
    base: chartsState.baseCurrency,
    to: [chartsState.targetCurrency],
  );

  // Transform the time series data into chart data points
  final apiDataPoints = <ChartDataPoint>[];

  timeSeriesRates.rates.forEach((dateStr, rates) {
    final rate = rates[chartsState.targetCurrency];
    if (rate != null) {
      final date = DateTime.parse(dateStr);
      apiDataPoints.add(ChartDataPoint(date: date, rate: rate));
    }
  });

  // Sort by date to ensure proper chart rendering
  apiDataPoints.sort((a, b) => a.date.compareTo(b.date));

  // Fill in missing weekend data with Friday's rate
  if (apiDataPoints.isEmpty) {
    return apiDataPoints;
  }

  final filledDataPoints = <ChartDataPoint>[];
  var currentDate = startDate;
  var lastRate = apiDataPoints.first.rate;

  while (currentDate.isBefore(today) || currentDate.isAtSameMomentAs(today)) {
    // Find data point for current date
    final matchingPoint = apiDataPoints.firstWhere(
      (point) =>
          point.date.year == currentDate.year &&
          point.date.month == currentDate.month &&
          point.date.day == currentDate.day,
      orElse: () => ChartDataPoint(date: currentDate, rate: lastRate),
    );

    // Update last rate if we found actual data
    if (apiDataPoints.any(
      (point) =>
          point.date.year == currentDate.year &&
          point.date.month == currentDate.month &&
          point.date.day == currentDate.day,
    )) {
      lastRate = matchingPoint.rate;
    }

    filledDataPoints.add(ChartDataPoint(date: currentDate, rate: lastRate));
    currentDate = currentDate.add(const Duration(days: 1));
  }

  log(
    'API dataPoints: ${apiDataPoints.length}, filled dataPoints: ${filledDataPoints.length}',
  );

  return filledDataPoints;
}
