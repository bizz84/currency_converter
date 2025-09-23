## Overview

Introduce a new `CurrencyApiClient` to integrate CurrencyAPI.com alongside the existing `FrankfurterClient`. Reuse existing models (`CurrencyRates`, `Currencies`, `Currency`) by adapting CurrencyAPI responses in the client layer. Add environment configuration for the API key and mirror Riverpod providers so the rest of the app can consume rates and currencies uniformly.

## Implementation

### Phase 1 — Environment setup

- [x] Add `Env.currencyApiKey` to `lib/src/env/env.dart` via `const String.fromEnvironment('CURRENCY_API_KEY')` with empty default.
- [x] Add `Env.validate()` check ensuring `CURRENCY_API_KEY` is non-empty (throw if missing).
- [ ] Document how to pass the key for local runs (e.g., `--dart-define=CURRENCY_API_KEY=...`).

### Phase 2 — Shared ApiClient interface

- [x] Create `lib/src/network/api_client.dart` with an abstract `ApiClient` class.
- [x] Define common methods: `Future<CurrencyRates> getLatestRates({ required Currency base, List<Currency>? to, double? amount })` and `Future<Currencies> getCurrencies()`.
- [x] Optionally document future methods (e.g., time series) as comments for consistency.
- [x] Update `FrankfurterClient` and `CurrencyApiClient` to `implements ApiClient`.
- [x] Add a Riverpod `apiClient` provider in `api_client.dart` that returns either `FrankfurterClient` or `CurrencyApiClient` (toggle by commenting one or the other during testing). Remove `frankfurterClient`/`currencyApiClient` providers and update shared providers (`availableCurrencies`, `latestRates`, `exchangeRate`) to use `apiClient`.

### Phase 3 — Client scaffolding

- [x] Create `lib/src/network/currency_api_client.dart` with injected `Dio` and base URL `https://api.currencyapi.com/v3`.
- [x] Ensure every request includes `apikey` (via query param or a per‑client interceptor).
- [x] Add helper to convert `List<Currency>` to comma string for `currencies` query.

### Phase 4 — Latest rates endpoint

- [x] Implement `Future<CurrencyRates> getLatestRates({ required Currency base, List<Currency>? to, double? amount })`.
- [x] Build query: `base_currency=base.name`, optional `currencies` from `to`.
- [x] Parse response: use `meta.last_updated_at` (trim to `yyyy-MM-dd`) and flatten `data` to `{ code: value }`.
- [x] Set `amount` in result to `amount ?? 1.0`; if `amount` provided, multiply flattened values client‑side.
- [x] Handle `base == target` through existing selector logic (no need to inject base rate).
- [ ] Add basic error handling for missing fields or unexpected response shapes.

### Phase 5 — Currencies endpoint

- [x] Implement `Future<Currencies> getCurrencies()` calling `/currencies`.
- [x] Pass `response.data['data']` (inner map) to `Currencies.fromJson`, which uses only keys and filters unsupported codes.

### Phase 6 — Testing & samples

- [x] Add unit tests under `test/src/network/currency_api_client_test.dart` using `http_mock_adapter`.
- [ ] Cover: latest rates happy path, `amount` multiplication, missing `data`/`meta` fields, currencies mapping/filtering, error codes.
- [ ] Add REST Client samples under `rest-api/` mirroring Frankfurter ones (optional, if repo uses them), referencing `.env` for the key.

## Implementation Notes

- Response shape differences
  - CurrencyAPI `latest`: `{ meta.last_updated_at, data: { CODE: { code, value } } }` vs. Frankfurter’s `{ amount, base, date, rates }`.
  - Adaptation lives in the client; no model changes required.

- Model compatibility
  - `CurrencyRates`: keep as is. Use `base` from the request, `date` from `last_updated_at.substring(0,10)`, and flatten `data` values to doubles.
  - `Currencies`: keep as is. Pass only the inner `data` map; values are ignored, keys are mapped to the `Currency` enum (unsupported codes filtered out).

- Amount handling
  - CurrencyAPI returns per‑unit quotes; multiply client‑side when `amount` is provided to preserve current UI behavior.

- Error handling & edge cases
  - Missing/invalid API key: return a descriptive error; consider checking in `Env.validate()` when using this client.
  - HTTP/network errors: surface meaningful messages via Dio error types.
  - Unexpected payloads: guard for missing `meta`, `data`, or `value` fields; fail fast with clear exceptions for tests.
  - Time zones: `last_updated_at` is ISO; trimming to `yyyy-MM-dd` maintains parity with existing `date` parsing.

- Testing and verification
  - Unit tests with mocked JSON for both endpoints; ensure transformation matches `CurrencyRates`/`Currencies` expectations.
  - Verify providers compile and integrate without affecting existing Frankfurter flows.
  - Optional manual checks using REST samples with a real API key.

- Future enhancements (out of scope)
  - Add time‑series support if needed, aligning with `TimeSeriesRates` or introducing a parallel model.
  - Introduce a repository or feature flag to switch backends at runtime.
  - Cache/stale‑while‑revalidate strategy using Dio interceptors or a data layer.
