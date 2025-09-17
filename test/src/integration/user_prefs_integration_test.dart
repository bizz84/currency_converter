import 'package:currency_converter/src/screens/convert/convert_screen.dart';
import 'package:currency_converter/src/utils/shared_preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('UserPrefs integration', () {
    testWidgets('loads initial prefs and persists amount on change', (tester) async {
      // Arrange initial stored values
      SharedPreferences.setMockInitialValues({
        'user_prefs/base_currency': 'USD',
        'user_prefs/target_currencies': <String>['GBP', 'EUR'],
        'user_prefs/amount': 123.45,
      });

      // Eagerly initialize shared preferences like main.dart
      final container = ProviderContainer();
      await container.read(sharedPreferencesProvider.future);

      // Pump the screen
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: ConvertScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert base currency code is shown (USD)
      expect(find.text('USD'), findsOneWidget);

      // The amount input should start with 123.45 (formatted to 2 decimals)
      final textFieldFinder = find.byType(TextField);
      expect(textFieldFinder, findsOneWidget);
      final textField = tester.widget<TextField>(textFieldFinder);
      expect(textField.controller?.text, '123.45');

      // Act: change amount to 200 and verify persistence
      await tester.enterText(textFieldFinder, '200');
      await tester.pump();

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getDouble('user_prefs/amount'), 200.0);
    });
  });
}

