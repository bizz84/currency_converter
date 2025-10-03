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

String _$chartsControllerHash() => r'5e5ed7fc38028db9b57bac432202853f9ad0839a';

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
