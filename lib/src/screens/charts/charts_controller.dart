import '/src/data/chart_data_point.dart';
import '/src/data/chart_time_range.dart';
import '/src/data/currency.dart';
import '/src/storage/user_prefs_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'charts_controller.g.dart';

class ChartsState {
  const ChartsState({
    required this.baseCurrency,
    required this.targetCurrency,
    required this.timeRange,
  });

  final Currency baseCurrency;
  final Currency targetCurrency;
  final ChartTimeRange timeRange;

  ChartsState copyWith({
    Currency? baseCurrency,
    Currency? targetCurrency,
    ChartTimeRange? timeRange,
  }) {
    return ChartsState(
      baseCurrency: baseCurrency ?? this.baseCurrency,
      targetCurrency: targetCurrency ?? this.targetCurrency,
      timeRange: timeRange ?? this.timeRange,
    );
  }
}

@riverpod
class ChartsController extends _$ChartsController {
  @override
  ChartsState build() {
    final prefs = ref.watch(userPrefsProvider);
    return ChartsState(
      baseCurrency: prefs.chartBaseCurrency,
      targetCurrency: prefs.chartTargetCurrency,
      timeRange: prefs.chartTimeRange,
    );
  }

  void setBaseCurrency(Currency currency) {
    state = state.copyWith(baseCurrency: currency);
    ref.read(userPrefsProvider.notifier).updateChartBaseCurrency(currency);
    ref.read(chartSelectedPointProvider.notifier).clearSelectedPoint();
  }

  void setTargetCurrency(Currency currency) {
    state = state.copyWith(targetCurrency: currency);
    ref.read(userPrefsProvider.notifier).updateChartTargetCurrency(currency);
    ref.read(chartSelectedPointProvider.notifier).clearSelectedPoint();
  }

  void setTimeRange(ChartTimeRange range) {
    state = state.copyWith(timeRange: range);
    ref.read(userPrefsProvider.notifier).updateChartTimeRange(range);
    ref.read(chartSelectedPointProvider.notifier).clearSelectedPoint();
  }

  void swapCurrencies() {
    final newBase = state.targetCurrency;
    final newTarget = state.baseCurrency;
    state = state.copyWith(
      baseCurrency: newBase,
      targetCurrency: newTarget,
    );
    final notifier = ref.read(userPrefsProvider.notifier);
    notifier.updateChartBaseCurrency(newBase);
    notifier.updateChartTargetCurrency(newTarget);
    ref.read(chartSelectedPointProvider.notifier).clearSelectedPoint();
  }
}

@riverpod
class ChartSelectedPoint extends _$ChartSelectedPoint {
  @override
  ChartDataPoint? build() {
    return null;
  }

  void setSelectedPoint(ChartDataPoint? point) {
    state = point;
  }

  void clearSelectedPoint() {
    state = null;
  }
}
