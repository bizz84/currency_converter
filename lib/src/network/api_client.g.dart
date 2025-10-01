// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(apiClient)
const apiClientProvider = ApiClientProvider._();

final class ApiClientProvider
    extends $FunctionalProvider<ApiClient, ApiClient, ApiClient>
    with $Provider<ApiClient> {
  const ApiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiClientHash();

  @$internal
  @override
  $ProviderElement<ApiClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ApiClient create(Ref ref) {
    return apiClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ApiClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ApiClient>(value),
    );
  }
}

String _$apiClientHash() => r'89bf72bf50edb59aee26d6b8665a94eea54e0810';

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
    r'398cb0c12b43905cd6d041405431ee60a0e58217';

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
    required Currency super.argument,
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
    final argument = this.argument as Currency;
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

String _$latestRatesHash() => r'6efc2e0fdcc9555c2dc7f23f7cdc11a08e838eb8';

final class LatestRatesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<CurrencyRates>, Currency> {
  const LatestRatesFamily._()
    : super(
        retry: null,
        name: r'latestRatesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LatestRatesProvider call(Currency baseCurrency) =>
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
    required (Currency, Currency) super.argument,
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
    final argument = this.argument as (Currency, Currency);
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

String _$exchangeRateHash() => r'14a38a425c7db9ad29d8000e544e0a97ebda8936';

final class ExchangeRateFamily extends $Family
    with $FunctionalFamilyOverride<double, (Currency, Currency)> {
  const ExchangeRateFamily._()
    : super(
        retry: null,
        name: r'exchangeRateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ExchangeRateProvider call(Currency baseCurrency, Currency targetCurrency) =>
      ExchangeRateProvider._(
        argument: (baseCurrency, targetCurrency),
        from: this,
      );

  @override
  String toString() => r'exchangeRateProvider';
}
