import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:currency_converter/src/utils/shared_preferences_provider.dart';

/// Creates a test ProviderContainer with mock SharedPreferences and optional overrides.
///
/// This helper simplifies test setup by:
/// - Setting up mock SharedPreferences with the provided values
/// - Creating a ProviderContainer with the given overrides
/// - Eagerly initializing the SharedPreferences provider
///
/// Example:
/// ```dart
/// final container = await createTestContainer(
///   mockPreferences: {
///     UserPrefsNotifier.baseCurrencyKey: 'EUR',
///     UserPrefsNotifier.amountKey: 250.0,
///   },
///   overrides: [dioProvider.overrideWithValue(dio)],
/// );
/// ```
Future<ProviderContainer> createTestContainer({
  Map<String, Object> mockPreferences = const {},
  List<Override> overrides = const [],
}) async {
  // Set up mock SharedPreferences with the provided values
  SharedPreferences.setMockInitialValues(mockPreferences);

  // Create the container with any additional overrides
  final container = ProviderContainer(overrides: overrides);

  // Eagerly initialize SharedPreferences to ensure it's ready for use
  await container.read(sharedPreferencesProvider.future);

  return container;
}
