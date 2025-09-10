# Network Layer Implementation Plan

## Setup
- [x] Add Dio package to pubspec.yaml
- [x] Add http_mock_adapter package for testing to dev_dependencies
- [x] Create lib/src/network directory

## FrankfurterClient Implementation
- [x] Create lib/src/network/frankfurter_client.dart file
- [x] Define FrankfurterClient class with Dio dependency injection
- [x] Set base URL to https://api.frankfurter.dev/v1

## API Methods Implementation
- [x] Implement `getLatestRates({String? from, String? to, double? amount})` method
- [x] Implement `getHistoricalRates(String date, {String? from, String? to, double? amount})` method
- [x] Implement `getTimeSeriesRates(String startDate, String endDate, {String? from, String? to})` method
- [x] Implement `getCurrencies()` method

## Response Models
- [x] Create lib/src/data directory
- [x] Create CurrencyRates model for latest/historical rates response
- [x] Create TimeSeriesRates model for time series response
- [x] Create Currencies model for currencies list response
- [x] Add JSON serialization/deserialization to all models

## Unit Tests
- [x] Create test/src/network/frankfurter_client_test.dart file
- [x] Set up DioAdapter for mocking HTTP responses
- [x] Create test fixtures with sample JSON responses
- [x] Test getLatestRates with various parameter combinations
- [x] Test getHistoricalRates with valid date
- [x] Test getTimeSeriesRates with date range
- [x] Test getCurrencies method
- [x] Test response parsing for all models
- [x] Verify correct URL construction for each endpoint
- [x] Verify query parameters are properly attached