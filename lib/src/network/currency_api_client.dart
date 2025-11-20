import '/src/data/currencies.dart';
import '/src/data/currency.dart';
import '/src/data/currency_rates.dart';
import '/src/data/time_series_rates.dart';
import '/src/network/api_client.dart';
import 'package:dio/dio.dart';

class CurrencyApiClient implements ApiClient {
  CurrencyApiClient({required this.dio, required this.apiKey}) {
    dio.options.baseUrl = 'https://api.currencyapi.com/v3';
  }

  final Dio dio;
  final String apiKey;

  String? _currenciesToString(List<Currency>? currencies) {
    if (currencies == null || currencies.isEmpty) return null;
    return currencies.map((c) => c.name).join(',');
  }

  /// Fetch latest rates from CurrencyAPI and adapt to CurrencyRates
  @override
  Future<CurrencyRates> getLatestRates({
    required Currency base,
    List<Currency>? to,
    double? amount,
  }) async {
    final queryParameters = <String, dynamic>{
      'apikey': apiKey,
      'base_currency': base.name,
    };
    final toParam = _currenciesToString(to);
    if (toParam != null) queryParameters['currencies'] = toParam;

    final response = await dio.get<Map<String, dynamic>>(
      '/latest',
      queryParameters: queryParameters,
    );
    final amt = amount ?? 1.0;
    return CurrencyRates.fromCurrencyApi(
      response.data ?? const {},
      base: base,
      amount: amt,
    );
  }

  /// Fetch the list of currencies and adapt to Currencies
  @override
  Future<Currencies> getCurrencies() async {
    final response = await dio.get<Map<String, dynamic>>(
      '/currencies',
      queryParameters: {'apikey': apiKey},
    );
    final data = response.data ?? const {};
    final inner = data['data'] as Map<String, dynamic>? ?? const {};
    return Currencies.fromJson(inner);
  }

  @override
  Future<CurrencyRates> getHistoricalRates(
    String date, {
    required Currency base,
    List<Currency>? to,
    double? amount,
  }) {
    return Future.error(
      UnsupportedError(
        'getHistoricalRates is not supported by CurrencyApiClient',
      ),
    );
  }

  @override
  Future<TimeSeriesRates> getTimeSeriesRates(
    String startDate,
    String endDate, {
    Currency? base,
    List<Currency>? to,
  }) {
    return Future.error(
      UnsupportedError(
        'getTimeSeriesRates is not supported by CurrencyApiClient',
      ),
    );
  }
}

// No providers here; use api_client.dart to choose implementation.
