// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_prefs_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UserPrefsNotifier)
const userPrefsProvider = UserPrefsNotifierProvider._();

final class UserPrefsNotifierProvider
    extends $NotifierProvider<UserPrefsNotifier, UserPrefsState> {
  const UserPrefsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userPrefsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userPrefsNotifierHash();

  @$internal
  @override
  UserPrefsNotifier create() => UserPrefsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserPrefsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserPrefsState>(value),
    );
  }
}

String _$userPrefsNotifierHash() => r'97b0c08fa558d4dba479e77f9c2d934c8b5dde46';

abstract class _$UserPrefsNotifier extends $Notifier<UserPrefsState> {
  UserPrefsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<UserPrefsState, UserPrefsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<UserPrefsState, UserPrefsState>,
              UserPrefsState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
