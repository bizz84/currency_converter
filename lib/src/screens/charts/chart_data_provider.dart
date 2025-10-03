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
  final dataPoints = <ChartDataPoint>[];

  timeSeriesRates.rates.forEach((dateStr, rates) {
    final rate = rates[chartsState.targetCurrency.name];
    if (rate != null) {
      final date = DateTime.parse(dateStr);
      dataPoints.add(ChartDataPoint(date: date, rate: rate));
    }
  });

  // Sort by date to ensure proper chart rendering
  dataPoints.sort((a, b) => a.date.compareTo(b.date));

  return dataPoints;
}
