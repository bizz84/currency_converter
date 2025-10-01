## Overview

Integrate CurrencyAPI.com via a new `CurrencyApiClient` alongside the existing `FrankfurterClient`, while reusing existing models (`CurrencyRates`, `Currencies`, `Currency`). Adapt CurrencyAPI responses in the client layer only. Backend selection is controlled by `Env.converterApi` using the `CONVERTER_API` define. CurrencyAPI requires an API key passed via `CURRENCYAPI_KEY`.

## Implementation

### Phase 1 — Environment setup

- [x] Add `Env.currencyApiKey` to `lib/src/env/env.dart` via `const String.fromEnvironment('CURRENCYAPI_KEY')` with empty default.
- [x] Add `Env.converterApi` switch using `CONVERTER_API` define (values: `frankfurter`, `currencyapi`).
- [x] Add `Env.validate()` check ensuring `CURRENCYAPI_KEY` is non-empty when `converterApi == currencyApi`.
- [x] Document how to pass defines for local runs:
  - `flutter run --dart-define=CONVERTER_API=currencyapi --dart-define=CURRENCYAPI_KEY=YOUR_KEY`
  - `flutter test` uses mocks; no key required.

### Phase 2 — Shared ApiClient interface

- [x] Create `lib/src/network/api_client.dart` with an abstract `ApiClient` class.
- [x] Define methods:
  - [x] `Future<CurrencyRates> getLatestRates({ required Currency base, List<Currency>? to, double? amount })`
  - [x] `Future<Currencies> getCurrencies()`
  - [x] `Future<CurrencyRates> getHistoricalRates(String date, { ... })`
  - [x] `Future<TimeSeriesRates> getTimeSeriesRates(String start, String end, { ... })`
- [x] Implement in `FrankfurterClient` (all methods) and `CurrencyApiClient` (latest/currencies; others throw `UnsupportedError`).
- [x] Add Riverpod `apiClient` provider in `api_client.dart` selecting backend via `Env.converterApi`; consolidate shared providers (`availableCurrencies`, `latestRates`, `exchangeRate`).

### Phase 3 — Client scaffolding

- [x] Add `lib/src/network/currency_api_client.dart` with injected `Dio` and base URL `https://api.currencyapi.com/v3`.
- [x] Include `apikey` on each request as a query parameter.
- [x] Add helper to convert `List<Currency>` to `currencies` CSV query.

### Phase 4 — Latest rates endpoint

- [x] Implement `getLatestRates` with `base_currency`, optional `currencies`.
- [x] Parse `meta.last_updated_at` as ISO DateTime and flatten `data` to `{ code: value }` via `CurrencyRates.fromCurrencyApi`.
- [x] Set `amount` to `amount ?? 1.0`; multiply values client‑side when `amount` provided.
- [x] `base == target` handled by selector logic; no injected base rate.
- [ ] TODO: Add explicit error handling for missing/invalid `meta`/`data` shapes (currently defaults applied).

### Phase 5 — Currencies endpoint

- [x] Implement `getCurrencies()` calling `/currencies`.
- [x] Pass inner `data` map to `Currencies.fromJson` (keys -> `Currency` enum; unsupported filtered out).

### Phase 6 — Testing & samples

- [x] Add unit tests under `test/src/network/currency_api_client_test.dart` using `http_mock_adapter`.
- [x] Cover: latest rates happy path, `amount` multiplication, currencies mapping/filtering, unsupported endpoints.
- [ ] TODO: Add tests for missing `data`/`meta` fields and error codes.
- [x] REST Client samples under `rest-api/currencyapi.http` using `.env` variable `CURRENCYAPI_KEY`.

## Implementation Notes

- Backend selection
  - Controlled by `Env.converterApi` (`CONVERTER_API` define). `api_client.dart` chooses between `FrankfurterClient` and `CurrencyApiClient`.

- Response shape differences
  - CurrencyAPI `latest`: `{ meta.last_updated_at, data: { CODE: { code, value } } }` vs. Frankfurter `{ amount, base, date, rates }`.
  - Adaptation handled by `CurrencyRates.fromCurrencyApi`; models unchanged.

- Model compatibility
  - `CurrencyRates`: use request `base`, parse ISO `last_updated_at` to `DateTime`. `toJson()` formats `yyyy-MM-dd`.
  - `Currencies`: pass inner `data` map; keys map to `Currency` enum; unsupported filtered.

- Amount handling
  - CurrencyAPI returns per‑unit quotes; multiply client‑side when `amount` is provided to match UI behavior.

- Error handling & edge cases
  - Missing/invalid API key: `Env.validate()` throws when `converterApi == currencyApi` and key is empty.
  - HTTP/network errors: surfaced via Dio errors.
  - Unexpected payloads: current implementation applies safe defaults; consider explicit guards and exceptions (see TODOs).

- Testing and verification
  - Unit tests cover happy paths, amount multiplication, filtering, and unsupported endpoints.
  - Providers compile and integrate without affecting Frankfurter flows.
  - Manual checks available via `rest-api/currencyapi.http` with `.env`.

- Future enhancements (out of scope)
  - Add CurrencyAPI historical/time‑series support or map to existing models when needed.
  - Optional runtime backend switch UI/flag.
  - Caching/SWR via Dio interceptors or data layer.

## Run & Config

- Select backend and pass key (when needed):
  - `flutter run -d chrome --dart-define=CONVERTER_API=currencyapi --dart-define=CURRENCYAPI_KEY=YOUR_KEY`
  - `flutter run -d chrome --dart-define=CONVERTER_API=frankfurter`
- Build runner and tests:
  - `dart run build_runner build --delete-conflicting-outputs`
  - `flutter test`
