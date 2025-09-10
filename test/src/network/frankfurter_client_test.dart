import 'package:currency_converter/src/network/frankfurter_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  late Dio dio;
  late DioAdapter dioAdapter;
  late FrankfurterClient client;

  setUp(() {
    dio = Dio();
    dioAdapter = DioAdapter(dio: dio);
    client = FrankfurterClient(dio: dio);
  });

  group('FrankfurterClient', () {
    test('should set correct base URL', () {
      expect(dio.options.baseUrl, 'https://api.frankfurter.dev/v1');
    });

    group('getLatestRates', () {
      test('should fetch latest rates without parameters', () async {
        const path = '/latest';
        final responseData = {
          'amount': 1.0,
          'base': 'EUR',
          'date': '2024-01-15',
          'rates': {
            'USD': 1.0899,
            'GBP': 0.8597,
          },
        };

        dioAdapter.onGet(path, (server) => server.reply(200, responseData));

        final result = await client.getLatestRates();

        expect(result, responseData);
      });

      test('should fetch latest rates with from and to parameters', () async {
        const path = '/latest';
        final responseData = {
          'amount': 1.0,
          'base': 'USD',
          'date': '2024-01-15',
          'rates': {
            'GBP': 0.7888,
          },
        };

        dioAdapter.onGet(
          path,
          (server) => server.reply(200, responseData),
          queryParameters: {'from': 'USD', 'to': 'GBP'},
        );

        final result = await client.getLatestRates(from: 'USD', to: 'GBP');

        expect(result, responseData);
      });

      test('should fetch latest rates with amount conversion', () async {
        const path = '/latest';
        final responseData = {
          'amount': 100.0,
          'base': 'USD',
          'date': '2024-01-15',
          'rates': {
            'GBP': 78.88,
          },
        };

        dioAdapter.onGet(
          path,
          (server) => server.reply(200, responseData),
          queryParameters: {'amount': 100.0, 'from': 'USD', 'to': 'GBP'},
        );

        final result = await client.getLatestRates(
          amount: 100,
          from: 'USD',
          to: 'GBP',
        );

        expect(result, responseData);
      });
    });

    group('getHistoricalRates', () {
      test('should fetch historical rates for specific date', () async {
        const date = '2024-01-01';
        final path = '/$date';
        final responseData = {
          'amount': 1.0,
          'base': 'EUR',
          'date': date,
          'rates': {
            'USD': 1.1043,
            'GBP': 0.8678,
          },
        };

        dioAdapter.onGet(path, (server) => server.reply(200, responseData));

        final result = await client.getHistoricalRates(date);

        expect(result, responseData);
      });

      test('should fetch historical rates with from and to parameters',
          () async {
        const date = '2024-01-01';
        final path = '/$date';
        final responseData = {
          'amount': 1.0,
          'base': 'USD',
          'date': date,
          'rates': {
            'GBP': 0.7859,
            'EUR': 0.9055,
          },
        };

        dioAdapter.onGet(
          path,
          (server) => server.reply(200, responseData),
          queryParameters: {'from': 'USD', 'to': 'GBP,EUR'},
        );

        final result = await client.getHistoricalRates(
          date,
          from: 'USD',
          to: 'GBP,EUR',
        );

        expect(result, responseData);
      });

      test('should fetch historical rates with amount conversion', () async {
        const date = '2024-01-01';
        final path = '/$date';
        final responseData = {
          'amount': 50.0,
          'base': 'USD',
          'date': date,
          'rates': {
            'GBP': 39.295,
          },
        };

        dioAdapter.onGet(
          path,
          (server) => server.reply(200, responseData),
          queryParameters: {'amount': 50.0, 'from': 'USD', 'to': 'GBP'},
        );

        final result = await client.getHistoricalRates(
          date,
          amount: 50,
          from: 'USD',
          to: 'GBP',
        );

        expect(result, responseData);
      });
    });

    group('getTimeSeriesRates', () {
      test('should fetch time series rates for date range', () async {
        const startDate = '2024-01-01';
        const endDate = '2024-01-31';
        final path = '/$startDate..$endDate';
        final responseData = {
          'amount': 1.0,
          'base': 'EUR',
          'start_date': startDate,
          'end_date': endDate,
          'rates': {
            '2024-01-01': {'USD': 1.1043, 'GBP': 0.8678},
            '2024-01-02': {'USD': 1.0950, 'GBP': 0.8634},
            '2024-01-03': {'USD': 1.0893, 'GBP': 0.8592},
          },
        };

        dioAdapter.onGet(path, (server) => server.reply(200, responseData));

        final result = await client.getTimeSeriesRates(startDate, endDate);

        expect(result, responseData);
      });

      test('should fetch time series rates with from and to parameters',
          () async {
        const startDate = '2024-01-01';
        const endDate = '2024-01-07';
        final path = '/$startDate..$endDate';
        final responseData = {
          'amount': 1.0,
          'base': 'USD',
          'start_date': startDate,
          'end_date': endDate,
          'rates': {
            '2024-01-01': {'GBP': 0.7859},
            '2024-01-02': {'GBP': 0.7890},
            '2024-01-03': {'GBP': 0.7883},
          },
        };

        dioAdapter.onGet(
          path,
          (server) => server.reply(200, responseData),
          queryParameters: {'from': 'USD', 'to': 'GBP'},
        );

        final result = await client.getTimeSeriesRates(
          startDate,
          endDate,
          from: 'USD',
          to: 'GBP',
        );

        expect(result, responseData);
      });
    });

    group('getCurrencies', () {
      test('should fetch all available currencies', () async {
        const path = '/currencies';
        final responseData = {
          'AUD': 'Australian Dollar',
          'BGN': 'Bulgarian Lev',
          'BRL': 'Brazilian Real',
          'CAD': 'Canadian Dollar',
          'CHF': 'Swiss Franc',
          'CNY': 'Chinese Renminbi Yuan',
          'CZK': 'Czech Koruna',
          'DKK': 'Danish Krone',
          'EUR': 'Euro',
          'GBP': 'British Pound',
          'HKD': 'Hong Kong Dollar',
          'HUF': 'Hungarian Forint',
          'IDR': 'Indonesian Rupiah',
          'ILS': 'Israeli New Sheqel',
          'INR': 'Indian Rupee',
          'ISK': 'Icelandic Króna',
          'JPY': 'Japanese Yen',
          'KRW': 'South Korean Won',
          'MXN': 'Mexican Peso',
          'MYR': 'Malaysian Ringgit',
          'NOK': 'Norwegian Krone',
          'NZD': 'New Zealand Dollar',
          'PHP': 'Philippine Peso',
          'PLN': 'Polish Złoty',
          'RON': 'Romanian Leu',
          'SEK': 'Swedish Krona',
          'SGD': 'Singapore Dollar',
          'THB': 'Thai Baht',
          'TRY': 'Turkish Lira',
          'USD': 'United States Dollar',
          'ZAR': 'South African Rand',
        };

        dioAdapter.onGet(path, (server) => server.reply(200, responseData));

        final result = await client.getCurrencies();

        expect(result, responseData);
      });
    });

    group('URL construction', () {
      test('should construct correct URL for latest endpoint', () async {
        const path = '/latest';
        final responseData = {'test': 'data'};
        dioAdapter.onGet(path, (server) => server.reply(200, responseData));

        final result = await client.getLatestRates();

        expect(result, responseData);
      });

      test('should construct correct URL for historical endpoint', () async {
        const date = '2024-01-15';
        final path = '/$date';
        final responseData = {'test': 'data'};
        dioAdapter.onGet(path, (server) => server.reply(200, responseData));

        final result = await client.getHistoricalRates(date);

        expect(result, responseData);
      });

      test('should construct correct URL for time series endpoint', () async {
        const startDate = '2024-01-01';
        const endDate = '2024-01-31';
        final path = '/$startDate..$endDate';
        final responseData = {'test': 'data'};
        dioAdapter.onGet(path, (server) => server.reply(200, responseData));

        final result = await client.getTimeSeriesRates(startDate, endDate);

        expect(result, responseData);
      });

      test('should construct correct URL for currencies endpoint', () async {
        const path = '/currencies';
        final responseData = {'USD': 'United States Dollar'};
        dioAdapter.onGet(path, (server) => server.reply(200, responseData));

        final result = await client.getCurrencies();

        expect(result, responseData);
      });
    });
  });
}