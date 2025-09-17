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
    extends $NotifierProvider<UserPrefsNotifier, UserPrefs> {
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
  Override overrideWithValue(UserPrefs value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserPrefs>(value),
    );
  }
}

String _$userPrefsNotifierHash() => r'0d0ce4137c812e0c357b2f4b9023846a93b76a2b';

abstract class _$UserPrefsNotifier extends $Notifier<UserPrefs> {
  UserPrefs build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<UserPrefs, UserPrefs>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<UserPrefs, UserPrefs>,
              UserPrefs,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
