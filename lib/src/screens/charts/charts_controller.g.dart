// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'charts_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ChartsController)
const chartsControllerProvider = ChartsControllerProvider._();

final class ChartsControllerProvider
    extends $NotifierProvider<ChartsController, ChartsState> {
  const ChartsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chartsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chartsControllerHash();

  @$internal
  @override
  ChartsController create() => ChartsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChartsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChartsState>(value),
    );
  }
}

String _$chartsControllerHash() => r'0abcc11d4e4a0f29c342ef5799d1664e5f46403c';

abstract class _$ChartsController extends $Notifier<ChartsState> {
  ChartsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ChartsState, ChartsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ChartsState, ChartsState>,
              ChartsState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ChartSelectedPoint)
const chartSelectedPointProvider = ChartSelectedPointProvider._();

final class ChartSelectedPointProvider
    extends $NotifierProvider<ChartSelectedPoint, ChartDataPoint?> {
  const ChartSelectedPointProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chartSelectedPointProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chartSelectedPointHash();

  @$internal
  @override
  ChartSelectedPoint create() => ChartSelectedPoint();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChartDataPoint? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChartDataPoint?>(value),
    );
  }
}

String _$chartSelectedPointHash() =>
    r'abe178c233e496072d95e77b70f7e4e94a6162de';

abstract class _$ChartSelectedPoint extends $Notifier<ChartDataPoint?> {
  ChartDataPoint? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ChartDataPoint?, ChartDataPoint?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ChartDataPoint?, ChartDataPoint?>,
              ChartDataPoint?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
