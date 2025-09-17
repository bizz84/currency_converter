import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/src/app.dart';
import '/src/utils/shared_preferences_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();
  // Eagerly initialize SharedPreferences
  await container.read(sharedPreferencesProvider.future);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const CurrencyConverterApp(),
    ),
  );
}
