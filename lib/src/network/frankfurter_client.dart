import '/src/data/currencies.dart';
import '/src/data/currency.dart';
import '/src/data/currency_rates.dart';
import '/src/data/time_series_rates.dart';
import '/src/network/api_client.dart';
import 'package:dio/dio.dart';

class FrankfurterClient implements ApiClient {
  FrankfurterClient({required Dio dio}) : _dio = dio {
    _dio.options.baseUrl = 'https://api.frankfurter.dev/v1';
  }

  final Dio _dio;

  String? _currenciesToString(List<Currency>? currencies) {
    if (currencies == null || currencies.isEmpty) return null;
    return currencies.map((c) => c.name).join(',');
  }

  @override
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
    // return CurrencyRates.fromFrankfurterApi(data);
    return CurrencyRates.fromFrankfurterApi(response.data!);
  }

  @override
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
    return CurrencyRates.fromFrankfurterApi(response.data!);
  }

  @override
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

  @override
  Future<Currencies> getCurrencies() async {
    final response = await _dio.get<Map<String, dynamic>>('/currencies');
    return Currencies.fromJson(response.data!);
  }
}

// Providers moved to api_client.dart to allow backend selection.
