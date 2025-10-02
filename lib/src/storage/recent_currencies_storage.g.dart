// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_currencies_storage.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RecentCurrenciesStorage)
const recentCurrenciesStorageProvider = RecentCurrenciesStorageProvider._();

final class RecentCurrenciesStorageProvider
    extends $NotifierProvider<RecentCurrenciesStorage, List<Currency>> {
  const RecentCurrenciesStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentCurrenciesStorageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentCurrenciesStorageHash();

  @$internal
  @override
  RecentCurrenciesStorage create() => RecentCurrenciesStorage();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Currency> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Currency>>(value),
    );
  }
}

String _$recentCurrenciesStorageHash() =>
    r'bcd19cc92718dcc3d2f5f3f40aa205cf864906ab';

abstract class _$RecentCurrenciesStorage extends $Notifier<List<Currency>> {
  List<Currency> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<Currency>, List<Currency>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<Currency>, List<Currency>>,
              List<Currency>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
