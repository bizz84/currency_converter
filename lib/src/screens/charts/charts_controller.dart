import '/src/data/chart_data_point.dart';
import '/src/data/chart_time_range.dart';
import '/src/data/currency.dart';
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
    return const ChartsState(
      baseCurrency: Currency.GBP,
      targetCurrency: Currency.EUR,
      timeRange: ChartTimeRange.oneYear,
    );
  }

  void setBaseCurrency(Currency currency) {
    state = state.copyWith(baseCurrency: currency);
    ref.read(chartSelectedPointProvider.notifier).clearSelectedPoint();
  }

  void setTargetCurrency(Currency currency) {
    state = state.copyWith(targetCurrency: currency);
    ref.read(chartSelectedPointProvider.notifier).clearSelectedPoint();
  }

  void setTimeRange(ChartTimeRange range) {
    state = state.copyWith(timeRange: range);
    ref.read(chartSelectedPointProvider.notifier).clearSelectedPoint();
  }

  void swapCurrencies() {
    state = state.copyWith(
      baseCurrency: state.targetCurrency,
      targetCurrency: state.baseCurrency,
    );
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
