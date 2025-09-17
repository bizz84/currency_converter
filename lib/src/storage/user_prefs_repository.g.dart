// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_prefs_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(userPrefsRepository)
const userPrefsRepositoryProvider = UserPrefsRepositoryProvider._();

final class UserPrefsRepositoryProvider
    extends
        $FunctionalProvider<
          UserPrefsRepository,
          UserPrefsRepository,
          UserPrefsRepository
        >
    with $Provider<UserPrefsRepository> {
  const UserPrefsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userPrefsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userPrefsRepositoryHash();

  @$internal
  @override
  $ProviderElement<UserPrefsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UserPrefsRepository create(Ref ref) {
    return userPrefsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserPrefsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserPrefsRepository>(value),
    );
  }
}

String _$userPrefsRepositoryHash() =>
    r'75e21e34ddd3a266fd7d1556712e4cd3a5b43b82';
