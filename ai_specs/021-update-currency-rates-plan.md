# Plan: Update Currency Rates to Use Currency Enum

## Overview

Update the `CurrencyRates` and `TimeSeriesRates` models to use the type-safe `Currency` enum instead of `String` for the `base` field and map keys in the `rates` field. This change will improve type safety, prevent invalid currency codes, and make the API more consistent with the rest of the codebase.

## Implementation

### Phase 1: Update CurrencyRates Model

- [x] Change `base` field from `String` to `Currency` in `lib/src/data/currency_rates.dart`
- [x] Change `rates` map from `Map<String, double>` to `Map<Currency, double>`
- [x] Update `fromFrankfurterApi` factory to parse base as `Currency` and convert rate keys to `Currency` enum values
- [x] Update `fromCurrencyApi` factory to parse base parameter as `Currency` and convert rate keys to `Currency` enum values
- [x] Verify code compiles

### Phase 2: Update TimeSeriesRates Model

- [ ] Change `base` field from `String` to `Currency` in `lib/src/data/time_series_rates.dart`
- [ ] Change `rates` map from `Map<String, Map<String, double>>` to `Map<String, Map<Currency, double>>`
- [ ] Update `fromJson` factory to parse base as `Currency` and convert currency keys to `Currency` enum values
- [ ] Update `toJson` method to convert `Currency` enum values back to strings
- [ ] Verify code compiles

### Phase 3: Update Test Extension

- [x] Update `toJson()` method in `test/src/network/currency_rates_test_ext.dart` to convert `Currency` enum values to strings
- [x] Verify test extension compiles

### Phase 4: Update API Client Usage

- [x] Update `lib/src/network/api_client.dart` - change `rates.rates[targetCurrency.name]` to `rates.rates[targetCurrency]`
- [x] Update `lib/src/screens/convert/convert_screen.dart` - change `rates.rates[currency.name]` to `rates.rates[currency]`
- [x] Verify all usages compile

### Phase 5: Update All Tests

- [x] Update `test/src/network/frankfurter_client_test.dart`:
  - Change all `result.rates['USD']` to `result.rates[Currency.USD]`
  - Change all `result.rates['GBP']` to `result.rates[Currency.GBP]`
  - Change all `result.rates['EUR']` to `result.rates[Currency.EUR]`
  - Update time series tests to use `Currency` enum for base field (inner map keys will be updated in Phase 2)
- [x] Update `test/src/network/currency_api_client_test.dart`:
  - Change all `result.rates['EUR']` to `result.rates[Currency.EUR]`
  - Change all `result.rates['GBP']` to `result.rates[Currency.GBP]`
  - Change all `result.rates['JPY']` to `result.rates[Currency.JPY]`
- [x] Verify all tests compile

### Phase 6: Run Tests and Fix Issues

- [ ] Run `flutter test` to execute all tests
- [ ] Fix any test failures related to the currency changes
- [ ] Ensure all tests pass

## Implementation Notes

**Key Considerations:**
- The `Currency.from(String)` method already exists and returns `Currency?`, which will be useful for parsing API responses
- Need to handle cases where the API returns currency codes that don't exist in our `Currency` enum (skip those entries or log a warning)
- The change maintains backward compatibility for JSON serialization in tests via the test extension

**Migration Strategy:**
- This is an internal API change that doesn't affect stored data or external APIs
- Changes are confined to the data models and their usage within the app
- All factory methods already handle parsing, so we just need to add `Currency.from()` calls
- Tests will need updates but the overall structure remains the same

**Edge Cases:**
- API returns unknown currency codes: Filter them out during parsing (only include currencies that exist in our enum)
- Null safety: `Currency.from()` returns `Currency?`, so we need to handle null cases gracefully

**Future Enhancements (Out of Scope):**
- Add logging when unknown currencies are encountered from the API
- Consider adding a fallback mechanism or error reporting for unsupported currencies
- Could extend the `Currency` enum dynamically if needed, though this would require architectural changes
