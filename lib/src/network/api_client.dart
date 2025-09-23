import 'package:currency_converter/src/data/currencies.dart';
import 'package:currency_converter/src/data/currency.dart';
import 'package:currency_converter/src/data/currency_rates.dart';
import 'package:currency_converter/src/data/time_series_rates.dart';
import 'package:currency_converter/src/network/currency_api_client.dart';
import 'package:currency_converter/src/network/frankfurter_client.dart';
import 'package:currency_converter/src/utils/dio_provider.dart';
import 'package:currency_converter/src/env/env.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_client.g.dart';

/// Shared interface for currency API clients.
abstract class ApiClient {
  Future<CurrencyRates> getLatestRates({
    required Currency base,
    List<Currency>? to,
    double? amount,
  });

  Future<Currencies> getCurrencies();

  /// Optional: Historical rates for a given date (yyyy-MM-dd).
  Future<CurrencyRates> getHistoricalRates(
    String date, {
    required Currency base,
    List<Currency>? to,
    double? amount,
  });

  /// Optional: Time series rates for a date range.
  Future<TimeSeriesRates> getTimeSeriesRates(
    String startDate,
    String endDate, {
    Currency? base,
    List<Currency>? to,
  });
}

// Shared providers using the selected ApiClient implementation.

@riverpod
ApiClient apiClient(Ref ref) {
  // Choose backend via Env.converterApi (from CONVERTER_API define)
  switch (Env.converterApi) {
    case ConverterApi.currencyApi:
      Env.validate();
      return CurrencyApiClient(
        dio: ref.read(dioProvider),
        apiKey: Env.currencyApiKey,
      );
    case ConverterApi.frankfurter:
      return FrankfurterClient(dio: ref.read(dioProvider));
  }
}

@riverpod
Future<Currencies> availableCurrencies(Ref ref) async {
  final client = ref.watch(apiClientProvider);
  return client.getCurrencies();
}

@riverpod
Future<CurrencyRates> latestRates(Ref ref, Currency baseCurrency) async {
  final client = ref.watch(apiClientProvider);
  return client.getLatestRates(base: baseCurrency);
}

@riverpod
double exchangeRate(Ref ref, Currency baseCurrency, Currency targetCurrency) {
  final ratesAsync = ref.watch(latestRatesProvider(baseCurrency));

  return ratesAsync.when(
    data: (rates) {
      if (baseCurrency == targetCurrency) return 1.0;
      return rates.rates[targetCurrency.name] ?? 1.0;
    },
    loading: () => 1.0,
    error: (_, _) => 1.0,
  );
}
