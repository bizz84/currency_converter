// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'frankfurter_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(frankfurterClient)
const frankfurterClientProvider = FrankfurterClientProvider._();

final class FrankfurterClientProvider
    extends
        $FunctionalProvider<
          FrankfurterClient,
          FrankfurterClient,
          FrankfurterClient
        >
    with $Provider<FrankfurterClient> {
  const FrankfurterClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'frankfurterClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$frankfurterClientHash();

  @$internal
  @override
  $ProviderElement<FrankfurterClient> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FrankfurterClient create(Ref ref) {
    return frankfurterClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FrankfurterClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FrankfurterClient>(value),
    );
  }
}

String _$frankfurterClientHash() => r'e4965f869f205e2f193ade82bf20044aaa292b68';

@ProviderFor(availableCurrencies)
const availableCurrenciesProvider = AvailableCurrenciesProvider._();

final class AvailableCurrenciesProvider
    extends
        $FunctionalProvider<
          AsyncValue<Currencies>,
          Currencies,
          FutureOr<Currencies>
        >
    with $FutureModifier<Currencies>, $FutureProvider<Currencies> {
  const AvailableCurrenciesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'availableCurrenciesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$availableCurrenciesHash();

  @$internal
  @override
  $FutureProviderElement<Currencies> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Currencies> create(Ref ref) {
    return availableCurrencies(ref);
  }
}

String _$availableCurrenciesHash() =>
    r'7108d6909effefeff040e36bb1937b54e95fdaeb';

@ProviderFor(latestRates)
const latestRatesProvider = LatestRatesFamily._();

final class LatestRatesProvider
    extends
        $FunctionalProvider<
          AsyncValue<CurrencyRates>,
          CurrencyRates,
          FutureOr<CurrencyRates>
        >
    with $FutureModifier<CurrencyRates>, $FutureProvider<CurrencyRates> {
  const LatestRatesProvider._({
    required LatestRatesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'latestRatesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$latestRatesHash();

  @override
  String toString() {
    return r'latestRatesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<CurrencyRates> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<CurrencyRates> create(Ref ref) {
    final argument = this.argument as String;
    return latestRates(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LatestRatesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$latestRatesHash() => r'a838180400718d94731119492f458d69c5f24ae6';

final class LatestRatesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<CurrencyRates>, String> {
  const LatestRatesFamily._()
    : super(
        retry: null,
        name: r'latestRatesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LatestRatesProvider call(String baseCurrency) =>
      LatestRatesProvider._(argument: baseCurrency, from: this);

  @override
  String toString() => r'latestRatesProvider';
}

@ProviderFor(exchangeRate)
const exchangeRateProvider = ExchangeRateFamily._();

final class ExchangeRateProvider
    extends $FunctionalProvider<double, double, double>
    with $Provider<double> {
  const ExchangeRateProvider._({
    required ExchangeRateFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'exchangeRateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$exchangeRateHash();

  @override
  String toString() {
    return r'exchangeRateProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<double> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  double create(Ref ref) {
    final argument = this.argument as (String, String);
    return exchangeRate(ref, argument.$1, argument.$2);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<double>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ExchangeRateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$exchangeRateHash() => r'bac3275d5d70e5093003a8d214addcc2db8768f1';

final class ExchangeRateFamily extends $Family
    with $FunctionalFamilyOverride<double, (String, String)> {
  const ExchangeRateFamily._()
    : super(
        retry: null,
        name: r'exchangeRateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ExchangeRateProvider call(String baseCurrency, String targetCurrency) =>
      ExchangeRateProvider._(
        argument: (baseCurrency, targetCurrency),
        from: this,
      );

  @override
  String toString() => r'exchangeRateProvider';
}
