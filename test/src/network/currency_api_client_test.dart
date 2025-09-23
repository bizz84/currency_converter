import 'package:currency_converter/src/data/currencies.dart';
import 'package:currency_converter/src/data/currency.dart';
import 'package:currency_converter/src/network/currency_api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  late Dio dio;
  late DioAdapter dioAdapter;
  late CurrencyApiClient client;

  setUp(() {
    dio = Dio();
    dioAdapter = DioAdapter(dio: dio);
    client = CurrencyApiClient(dio: dio, apiKey: 'test_key');
  });

  group('CurrencyApiClient', () {
    test('should set correct base URL', () {
      expect(dio.options.baseUrl, 'https://api.currencyapi.com/v3');
    });

    group('getLatestRates', () {
      test('fetches latest rates and flattens data', () async {
        const path = '/latest';
        final responseData = {
          'meta': {'last_updated_at': '2025-09-22T23:59:59Z'},
          'data': {
            'EUR': {'code': 'EUR', 'value': 0.8469301097},
            'GBP': {'code': 'GBP', 'value': 0.739850138},
            'JPY': {'code': 'JPY', 'value': 147.7094472344},
          },
        };

        dioAdapter.onGet(
          path,
          (server) => server.reply(200, responseData),
          queryParameters: {
            'apikey': 'test_key',
            'base_currency': 'USD',
          },
        );

        final result = await client.getLatestRates(base: Currency.USD);

        expect(result.amount, 1.0);
        expect(result.base, 'USD');
        expect(result.date, '2025-09-22');
        expect(result.rates['EUR'], closeTo(0.8469301097, 1e-12));
        expect(result.rates['GBP'], closeTo(0.739850138, 1e-12));
        expect(result.rates['JPY'], closeTo(147.7094472344, 1e-12));
      });

      test('respects currencies filter and amount multiplication', () async {
        const path = '/latest';
        final responseData = {
          'meta': {'last_updated_at': '2025-09-22T12:00:00Z'},
          'data': {
            'GBP': {'code': 'GBP', 'value': 0.75},
          },
        };

        dioAdapter.onGet(
          path,
          (server) => server.reply(200, responseData),
          queryParameters: {
            'apikey': 'test_key',
            'base_currency': 'USD',
            'currencies': 'GBP',
          },
        );

        final result = await client.getLatestRates(
          base: Currency.USD,
          to: const [Currency.GBP],
          amount: 100,
        );

        expect(result.amount, 100);
        expect(result.base, 'USD');
        expect(result.date, '2025-09-22');
        expect(result.rates['GBP'], 75.0);
      });
    });

    group('getCurrencies', () {
      test('maps inner data keys to Currencies, filtering unsupported', () async {
        const path = '/currencies';
        final responseData = {
          'data': {
            'USD': {
              'symbol': '\$','name': 'US Dollar','code': 'USD','type': 'fiat'
            },
            'EUR': {
              'symbol': '€','name': 'Euro','code': 'EUR','type': 'fiat'
            },
            'ZZZ': {
              'symbol': 'Z','name': 'Test','code': 'ZZZ','type': 'fiat'
            },
          }
        };

        dioAdapter.onGet(
          path,
          (server) => server.reply(200, responseData),
          queryParameters: {'apikey': 'test_key'},
        );

        final result = await client.getCurrencies();

        expect(result, isA<Currencies>());
        // USD and EUR are supported by the app enum; ZZZ should be filtered out
        expect(result.currencies.contains(Currency.USD), isTrue);
        expect(result.currencies.contains(Currency.EUR), isTrue);
      });
    });

    group('unsupported endpoints', () {
      test('getHistoricalRates throws UnsupportedError', () async {
        expect(
          () => client.getHistoricalRates(
            '2025-01-01',
            base: Currency.USD,
          ),
          throwsA(isA<UnsupportedError>()),
        );
      });

      test('getTimeSeriesRates throws UnsupportedError', () async {
        expect(
          () => client.getTimeSeriesRates('2025-01-01', '2025-01-31'),
          throwsA(isA<UnsupportedError>()),
        );
      });
    });
  });
}

