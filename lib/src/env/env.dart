class Env {
  // Add environment variables as needed for the currency converter app
  // Example:
  // static String get apiKey => const String.fromEnvironment('API_KEY');

  // TODO: Add environment variables when needed (e.g., for analytics, crash reporting)

  // API key for CurrencyAPI.com
  static String get currencyApiKey => const String.fromEnvironment(
    'CURRENCYAPI_KEY',
    defaultValue: '',
  );

  // Select which converter API backend to use
  // Accepted values (case-insensitive): 'frankfurter', 'currencyapi'
  static ConverterApi get converterApi {
    final raw = const String.fromEnvironment(
      'CONVERTER_API',
      defaultValue: 'frankfurter',
    );
    switch (raw.toLowerCase().trim()) {
      case 'currencyapi':
        return ConverterApi.currencyApi;
      case 'frankfurter':
        return ConverterApi.frankfurter;
      default:
        return ConverterApi.frankfurter;
    }
  }

  // iOS App Store ID for force update functionality
  static String get appStoreId => const String.fromEnvironment(
    'APP_STORE_ID',
    defaultValue: '', // TODO: Replace with actual App Store ID
  );

  // Sentry DSN for error tracking
  static String get sentryDsn => const String.fromEnvironment(
    'SENTRY_DSN',
    defaultValue: '', // TODO: Replace with actual Sentry DSN
  );

  static void validate() {
    if (converterApi == ConverterApi.currencyApi) {
      if (currencyApiKey.trim().isEmpty) {
        throw Exception('CURRENCYAPI_KEY not defined');
      }
    }
  }
}

enum ConverterApi { frankfurter, currencyApi }
