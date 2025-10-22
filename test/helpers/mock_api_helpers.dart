import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:currency_converter/src/data/currency.dart';

/// Sets up mock API responses for the latest exchange rates endpoint.
///
/// This mocks the `/latest` endpoint with rates for common currencies.
/// You can optionally specify which base currency to mock.
///
/// Example:
/// ```dart
/// setupMockLatestRates(dioAdapter, Currency.GBP);
/// setupMockLatestRates(dioAdapter, Currency.EUR);
/// ```
void setupMockLatestRates(DioAdapter adapter, Currency baseCurrency) {
  final responseData = _getLatestRatesResponse(baseCurrency);

  adapter.onGet(
    '/latest',
    (server) => server.reply(200, responseData),
    queryParameters: {'from': baseCurrency.name},
  );
}

/// Sets up mock API responses for the time series endpoint.
///
/// This mocks the `/{startDate}..{endDate}` endpoint with rates over a date range.
/// The response includes data for each day in the range.
///
/// Example:
/// ```dart
/// setupMockTimeSeriesRates(
///   dioAdapter,
///   Currency.GBP,
///   Currency.EUR,
///   '2024-01-01',
///   '2024-01-07',
/// );
/// ```
void setupMockTimeSeriesRates(
  DioAdapter adapter,
  Currency baseCurrency,
  Currency targetCurrency,
  String startDate,
  String endDate,
) {
  final responseData = _getTimeSeriesResponse(
    baseCurrency,
    targetCurrency,
    startDate,
    endDate,
  );

  adapter.onGet(
    '/$startDate..$endDate',
    (server) => server.reply(200, responseData),
    queryParameters: {
      'from': baseCurrency.name,
      'to': targetCurrency.name,
    },
  );
}

/// Sets up mock API responses for the currencies list endpoint.
///
/// This mocks the `/currencies` endpoint with a list of supported currencies.
///
/// Example:
/// ```dart
/// setupMockCurrencies(dioAdapter);
/// ```
void setupMockCurrencies(DioAdapter adapter) {
  adapter.onGet(
    '/currencies',
    (server) => server.reply(200, {
      'EUR': 'Euro',
      'USD': 'United States Dollar',
      'GBP': 'British Pound',
      'JPY': 'Japanese Yen',
      'CAD': 'Canadian Dollar',
      'AUD': 'Australian Dollar',
      'CHF': 'Swiss Franc',
      'SEK': 'Swedish Krona',
      'NZD': 'New Zealand Dollar',
    }),
  );
}

// Private helper to generate latest rates response for a given base currency
Map<String, dynamic> _getLatestRatesResponse(Currency baseCurrency) {
  // Default rates relative to each base currency
  final ratesMap = {
    Currency.GBP: {
      'EUR': 1.17,
      'USD': 1.27,
      'JPY': 180.5,
      'CAD': 1.68,
      'AUD': 1.87,
      'CHF': 1.09,
    },
    Currency.EUR: {
      'GBP': 0.85,
      'USD': 1.08,
      'JPY': 154.2,
      'CAD': 1.44,
      'AUD': 1.60,
      'CHF': 0.93,
    },
    Currency.USD: {
      'GBP': 0.79,
      'EUR': 0.93,
      'JPY': 142.5,
      'CAD': 1.33,
      'AUD': 1.48,
      'CHF': 0.86,
    },
    Currency.JPY: {
      'GBP': 0.0055,
      'EUR': 0.0065,
      'USD': 0.0070,
      'CAD': 0.0093,
      'AUD': 0.0104,
      'CHF': 0.0060,
    },
  };

  return {
    'amount': 1.0,
    'base': baseCurrency.name,
    'date': '2024-01-01',
    'rates': ratesMap[baseCurrency] ?? {},
  };
}

// Private helper to generate time series response
Map<String, dynamic> _getTimeSeriesResponse(
  Currency baseCurrency,
  Currency targetCurrency,
  String startDate,
  String endDate,
) {
  // Generate mock rates for the date range
  // For simplicity, we'll create a few data points
  // In real tests, this could be more sophisticated
  final rates = <String, Map<String, double>>{};

  // Parse dates and generate data points
  final start = DateTime.parse(startDate);
  final end = DateTime.parse(endDate);

  var currentDate = start;
  var baseRate = 1.25; // Starting rate

  while (currentDate.isBefore(end) || currentDate.isAtSameMomentAs(end)) {
    final dateStr = _formatDate(currentDate);
    // Vary the rate slightly for each day
    rates[dateStr] = {targetCurrency.name: baseRate};
    baseRate += 0.01; // Small increment each day
    currentDate = currentDate.add(const Duration(days: 1));
  }

  return {
    'amount': 1.0,
    'base': baseCurrency.name,
    'start_date': startDate,
    'end_date': endDate,
    'rates': rates,
  };
}

// Format date as YYYY-MM-DD
String _formatDate(DateTime date) {
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
