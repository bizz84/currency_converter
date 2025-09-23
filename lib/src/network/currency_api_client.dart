import 'package:currency_converter/src/data/currencies.dart';
import 'package:currency_converter/src/data/currency.dart';
import 'package:currency_converter/src/data/currency_rates.dart';
import 'package:currency_converter/src/data/time_series_rates.dart';
import 'package:currency_converter/src/network/api_client.dart';
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

    final data = response.data ?? const {};
    final meta = data['meta'] as Map<String, dynamic>?;
    final lastUpdatedAt = meta != null
        ? meta['last_updated_at'] as String?
        : null;
    final date = (lastUpdatedAt != null && lastUpdatedAt.length >= 10)
        ? lastUpdatedAt.substring(0, 10)
        : DateTime.now().toIso8601String().substring(0, 10);

    final rawData = data['data'] as Map<String, dynamic>? ?? const {};
    final Map<String, double> flattenedRates = {
      for (final entry in rawData.entries)
        entry.key: ((entry.value as Map<String, dynamic>)['value'] as num)
            .toDouble(),
    };

    final amt = amount ?? 1.0;
    final Map<String, double> adjustedRates = {
      for (final e in flattenedRates.entries) e.key: e.value * amt,
    };

    return CurrencyRates(
      amount: amt,
      base: base.name,
      date: date,
      rates: adjustedRates,
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
