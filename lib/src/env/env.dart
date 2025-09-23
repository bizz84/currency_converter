class Env {
  // Add environment variables as needed for the currency converter app
  // Example:
  // static String get apiKey => const String.fromEnvironment('API_KEY');

  // TODO: Add environment variables when needed (e.g., for analytics, crash reporting)

  // iOS App Store ID for force update functionality
  static String get appStoreId => const String.fromEnvironment(
        'APP_STORE_ID',
        defaultValue: '1234567890', // TODO: Replace with actual App Store ID
      );

  static void validate() {
    // TODO: Validate environment variables when added
    // Example:
    // if (apiKey.isEmpty) {
    //   throw Exception('API_KEY not defined');
    // }
  }
}