import 'package:dio/dio.dart';

class FrankfurterClient {
  FrankfurterClient({required Dio dio}) : _dio = dio {
    _dio.options.baseUrl = 'https://api.frankfurter.dev/v1';
  }

  final Dio _dio;

  Future<Map<String, dynamic>> getLatestRates({
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
    return response.data!;
  }

  Future<Map<String, dynamic>> getHistoricalRates(
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
    return response.data!;
  }

  Future<Map<String, dynamic>> getTimeSeriesRates(
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
    return response.data!;
  }

  Future<Map<String, dynamic>> getCurrencies() async {
    final response = await _dio.get<Map<String, dynamic>>('/currencies');
    return response.data!;
  }
}