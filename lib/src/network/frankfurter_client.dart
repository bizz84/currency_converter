import 'package:currency_converter/src/data/currencies.dart';
import 'package:currency_converter/src/data/currency.dart';
import 'package:currency_converter/src/data/currency_rates.dart';
import 'package:currency_converter/src/data/time_series_rates.dart';
import 'package:currency_converter/src/utils/dio_provider.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'frankfurter_client.g.dart';

class FrankfurterClient {
  FrankfurterClient({required Dio dio}) : _dio = dio {
    _dio.options.baseUrl = 'https://api.frankfurter.dev/v1';
  }

  final Dio _dio;

  String? _currenciesToString(List<Currency>? currencies) {
    if (currencies == null || currencies.isEmpty) return null;
    return currencies.map((c) => c.name).join(',');
  }

  Future<CurrencyRates> getLatestRates({
    required Currency base,
    List<Currency>? to,
    double? amount,
  }) async {
    final queryParameters = <String, dynamic>{};
    queryParameters['from'] = base.name;
    final toParam = _currenciesToString(to);
    if (toParam != null) queryParameters['to'] = toParam;
    if (amount != null) queryParameters['amount'] = amount;

    final response = await _dio.get<Map<String, dynamic>>(
      '/latest',
      queryParameters: queryParameters,
    );
    // Include base rate with value 1.0 in the response
    // final data = response.data!;
    // final rates = Map<String, dynamic>.from(data['rates'] as Map);
    // rates[base] = 1.0;
    // data['rates'] = rates;
    // return CurrencyRates.fromJson(data);
    return CurrencyRates.fromJson(response.data!);
  }

  Future<CurrencyRates> getHistoricalRates(
    String date, {
    required Currency base,
    List<Currency>? to,
    double? amount,
  }) async {
    final queryParameters = <String, dynamic>{};
    queryParameters['from'] = base.name;
    final toParam = _currenciesToString(to);
    if (toParam != null) queryParameters['to'] = toParam;
    if (amount != null) queryParameters['amount'] = amount;

    final response = await _dio.get<Map<String, dynamic>>(
      '/$date',
      queryParameters: queryParameters,
    );
    return CurrencyRates.fromJson(response.data!);
  }

  Future<TimeSeriesRates> getTimeSeriesRates(
    String startDate,
    String endDate, {
    Currency? base,
    List<Currency>? to,
  }) async {
    final queryParameters = <String, dynamic>{};
    if (base != null) queryParameters['from'] = base.name;
    final toParam = _currenciesToString(to);
    if (toParam != null) queryParameters['to'] = toParam;

    final response = await _dio.get<Map<String, dynamic>>(
      '/$startDate..$endDate',
      queryParameters: queryParameters,
    );
    return TimeSeriesRates.fromJson(response.data!);
  }

  Future<Currencies> getCurrencies() async {
    final response = await _dio.get<Map<String, dynamic>>('/currencies');
    return Currencies.fromJson(response.data!);
  }
}

@riverpod
FrankfurterClient frankfurterClient(Ref ref) {
  return FrankfurterClient(dio: ref.read(dioProvider));
}

@riverpod
Future<Currencies> availableCurrencies(Ref ref) async {
  final client = ref.watch(frankfurterClientProvider);
  return client.getCurrencies();
}

@riverpod
Future<CurrencyRates> latestRates(Ref ref, Currency baseCurrency) async {
  final client = ref.watch(frankfurterClientProvider);
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
