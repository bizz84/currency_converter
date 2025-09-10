// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'frankfurter_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$frankfurterClientHash() => r'e4965f869f205e2f193ade82bf20044aaa292b68';

/// See also [frankfurterClient].
@ProviderFor(frankfurterClient)
final frankfurterClientProvider =
    AutoDisposeProvider<FrankfurterClient>.internal(
      frankfurterClient,
      name: r'frankfurterClientProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$frankfurterClientHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FrankfurterClientRef = AutoDisposeProviderRef<FrankfurterClient>;
String _$availableCurrenciesHash() =>
    r'7108d6909effefeff040e36bb1937b54e95fdaeb';

/// See also [availableCurrencies].
@ProviderFor(availableCurrencies)
final availableCurrenciesProvider =
    AutoDisposeFutureProvider<Currencies>.internal(
      availableCurrencies,
      name: r'availableCurrenciesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$availableCurrenciesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AvailableCurrenciesRef = AutoDisposeFutureProviderRef<Currencies>;
String _$latestRatesHash() => r'a838180400718d94731119492f458d69c5f24ae6';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [latestRates].
@ProviderFor(latestRates)
const latestRatesProvider = LatestRatesFamily();

/// See also [latestRates].
class LatestRatesFamily extends Family<AsyncValue<CurrencyRates>> {
  /// See also [latestRates].
  const LatestRatesFamily();

  /// See also [latestRates].
  LatestRatesProvider call(String baseCurrency) {
    return LatestRatesProvider(baseCurrency);
  }

  @override
  LatestRatesProvider getProviderOverride(
    covariant LatestRatesProvider provider,
  ) {
    return call(provider.baseCurrency);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'latestRatesProvider';
}

/// See also [latestRates].
class LatestRatesProvider extends AutoDisposeFutureProvider<CurrencyRates> {
  /// See also [latestRates].
  LatestRatesProvider(String baseCurrency)
    : this._internal(
        (ref) => latestRates(ref as LatestRatesRef, baseCurrency),
        from: latestRatesProvider,
        name: r'latestRatesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$latestRatesHash,
        dependencies: LatestRatesFamily._dependencies,
        allTransitiveDependencies: LatestRatesFamily._allTransitiveDependencies,
        baseCurrency: baseCurrency,
      );

  LatestRatesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.baseCurrency,
  }) : super.internal();

  final String baseCurrency;

  @override
  Override overrideWith(
    FutureOr<CurrencyRates> Function(LatestRatesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LatestRatesProvider._internal(
        (ref) => create(ref as LatestRatesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        baseCurrency: baseCurrency,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<CurrencyRates> createElement() {
    return _LatestRatesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LatestRatesProvider && other.baseCurrency == baseCurrency;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, baseCurrency.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LatestRatesRef on AutoDisposeFutureProviderRef<CurrencyRates> {
  /// The parameter `baseCurrency` of this provider.
  String get baseCurrency;
}

class _LatestRatesProviderElement
    extends AutoDisposeFutureProviderElement<CurrencyRates>
    with LatestRatesRef {
  _LatestRatesProviderElement(super.provider);

  @override
  String get baseCurrency => (origin as LatestRatesProvider).baseCurrency;
}

String _$exchangeRateHash() => r'bac3275d5d70e5093003a8d214addcc2db8768f1';

/// See also [exchangeRate].
@ProviderFor(exchangeRate)
const exchangeRateProvider = ExchangeRateFamily();

/// See also [exchangeRate].
class ExchangeRateFamily extends Family<double> {
  /// See also [exchangeRate].
  const ExchangeRateFamily();

  /// See also [exchangeRate].
  ExchangeRateProvider call(String baseCurrency, String targetCurrency) {
    return ExchangeRateProvider(baseCurrency, targetCurrency);
  }

  @override
  ExchangeRateProvider getProviderOverride(
    covariant ExchangeRateProvider provider,
  ) {
    return call(provider.baseCurrency, provider.targetCurrency);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'exchangeRateProvider';
}

/// See also [exchangeRate].
class ExchangeRateProvider extends AutoDisposeProvider<double> {
  /// See also [exchangeRate].
  ExchangeRateProvider(String baseCurrency, String targetCurrency)
    : this._internal(
        (ref) =>
            exchangeRate(ref as ExchangeRateRef, baseCurrency, targetCurrency),
        from: exchangeRateProvider,
        name: r'exchangeRateProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$exchangeRateHash,
        dependencies: ExchangeRateFamily._dependencies,
        allTransitiveDependencies:
            ExchangeRateFamily._allTransitiveDependencies,
        baseCurrency: baseCurrency,
        targetCurrency: targetCurrency,
      );

  ExchangeRateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.baseCurrency,
    required this.targetCurrency,
  }) : super.internal();

  final String baseCurrency;
  final String targetCurrency;

  @override
  Override overrideWith(double Function(ExchangeRateRef provider) create) {
    return ProviderOverride(
      origin: this,
      override: ExchangeRateProvider._internal(
        (ref) => create(ref as ExchangeRateRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        baseCurrency: baseCurrency,
        targetCurrency: targetCurrency,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<double> createElement() {
    return _ExchangeRateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExchangeRateProvider &&
        other.baseCurrency == baseCurrency &&
        other.targetCurrency == targetCurrency;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, baseCurrency.hashCode);
    hash = _SystemHash.combine(hash, targetCurrency.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ExchangeRateRef on AutoDisposeProviderRef<double> {
  /// The parameter `baseCurrency` of this provider.
  String get baseCurrency;

  /// The parameter `targetCurrency` of this provider.
  String get targetCurrency;
}

class _ExchangeRateProviderElement extends AutoDisposeProviderElement<double>
    with ExchangeRateRef {
  _ExchangeRateProviderElement(super.provider);

  @override
  String get baseCurrency => (origin as ExchangeRateProvider).baseCurrency;
  @override
  String get targetCurrency => (origin as ExchangeRateProvider).targetCurrency;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
