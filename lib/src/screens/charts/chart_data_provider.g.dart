// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_data_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(chartData)
const chartDataProvider = ChartDataProvider._();

final class ChartDataProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ChartDataPoint>>,
          List<ChartDataPoint>,
          FutureOr<List<ChartDataPoint>>
        >
    with
        $FutureModifier<List<ChartDataPoint>>,
        $FutureProvider<List<ChartDataPoint>> {
  const ChartDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chartDataProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chartDataHash();

  @$internal
  @override
  $FutureProviderElement<List<ChartDataPoint>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ChartDataPoint>> create(Ref ref) {
    return chartData(ref);
  }
}

String _$chartDataHash() => r'886d2da9ef1c210b13329f5ec6c130ed1e51ae34';
