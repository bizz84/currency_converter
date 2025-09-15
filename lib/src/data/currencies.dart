import 'currency.dart';

/// Represents the available currencies returned from the API.
/// 
/// This class uses a `Set<Currency>` instead of `Map<String, String>` for several reasons:
/// 
/// 1. **Type Safety**: By using the Currency enum, we ensure only supported currencies
///    are used throughout the app, catching errors at compile-time rather than runtime.
/// 
/// 2. **Single Source of Truth**: The Currency enum already contains all necessary data
///    (name, symbol, flag), eliminating redundancy and potential inconsistencies.
/// 
/// 3. **API Filtering**: The API may return currencies we don't support. By converting
///    to our Currency enum in `fromJson`, we automatically filter to only supported currencies.
/// 
/// 4. **Compile-time Validation**: Using Currency enum values prevents typos and ensures
///    all currency codes are valid, as the compiler validates enum usage.
/// 
/// The trade-off is that adding new currencies requires updating the Currency enum,
/// but this is intentional - it ensures all currencies are properly configured with
/// their symbols and flags before being used in the app.
class Currencies {
  Currencies({required this.currencies});

  final Set<Currency> currencies;

  factory Currencies.fromJson(Map<String, dynamic> json) {
    return Currencies(
      currencies: json.keys
          .map(_tryParseCurrency)
          .whereType<Currency>()
          .toSet(),
    );
  }

  static Currency? _tryParseCurrency(String code) {
    try {
      return Currency.from(code);
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      for (final currency in currencies) currency.name: currency.desc,
    };
  }
}