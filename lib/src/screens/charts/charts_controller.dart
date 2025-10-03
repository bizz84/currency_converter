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
    this.selectedPoint,
  });

  final Currency baseCurrency;
  final Currency targetCurrency;
  final ChartTimeRange timeRange;
  final ChartDataPoint? selectedPoint;

  ChartsState copyWith({
    Currency? baseCurrency,
    Currency? targetCurrency,
    ChartTimeRange? timeRange,
    ChartDataPoint? selectedPoint,
    bool clearSelectedPoint = false,
  }) {
    return ChartsState(
      baseCurrency: baseCurrency ?? this.baseCurrency,
      targetCurrency: targetCurrency ?? this.targetCurrency,
      timeRange: timeRange ?? this.timeRange,
      selectedPoint:
          clearSelectedPoint ? null : (selectedPoint ?? this.selectedPoint),
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
  }

  void setTargetCurrency(Currency currency) {
    state = state.copyWith(targetCurrency: currency);
  }

  void setTimeRange(ChartTimeRange range) {
    state = state.copyWith(timeRange: range, clearSelectedPoint: true);
  }

  void setSelectedPoint(ChartDataPoint? point) {
    state = state.copyWith(selectedPoint: point);
  }

  void clearSelectedPoint() {
    state = state.copyWith(clearSelectedPoint: true);
  }

  void swapCurrencies() {
    state = state.copyWith(
      baseCurrency: state.targetCurrency,
      targetCurrency: state.baseCurrency,
    );
  }
}
