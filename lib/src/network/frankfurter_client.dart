import 'package:currency_converter/src/data/currencies.dart';
import 'package:currency_converter/src/data/currency_rates.dart';
import 'package:currency_converter/src/data/time_series_rates.dart';
import 'package:dio/dio.dart';

class FrankfurterClient {
  FrankfurterClient({required Dio dio}) : _dio = dio {
    _dio.options.baseUrl = 'https://api.frankfurter.dev/v1';
  }

  final Dio _dio;

  Future<CurrencyRates> getLatestRates({
    String? from,
    String? to,
    double? amount,
  }) async {
    final queryParameters = <String, dynamic>{};
    if (from != null) queryParameters['from'] = from;
    if (to != null) queryParameters['to'] = to;
    if (amount != null) queryParameters['amount'] = amount;

    final response = await _dio.get<Map<String, dynamic>>(
      '/latest',
      queryParameters: queryParameters,
    );
    return CurrencyRates.fromJson(response.data!);
  }

  Future<CurrencyRates> getHistoricalRates(
    String date, {
    String? from,
    String? to,
    double? amount,
  }) async {
    final queryParameters = <String, dynamic>{};
    if (from != null) queryParameters['from'] = from;
    if (to != null) queryParameters['to'] = to;
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
    String? from,
    String? to,
  }) async {
    final queryParameters = <String, dynamic>{};
    if (from != null) queryParameters['from'] = from;
    if (to != null) queryParameters['to'] = to;

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