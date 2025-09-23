class Env {
  // Add environment variables as needed for the currency converter app
  // Example:
  // static String get apiKey => const String.fromEnvironment('API_KEY');

  // TODO: Add environment variables when needed (e.g., for analytics, crash reporting)

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
    // TODO: Validate environment variables when added
    // Example:
    // if (apiKey.isEmpty) {
    //   throw Exception('API_KEY not defined');
    // }
  }
}
