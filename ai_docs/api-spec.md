## API Access

This project uses the following currency APIs:

- **https://frankfurter.dev/** - Primary free API (currently in use)
- **https://currencyapi.com/** - Paid API for more frequent rate updates (currently in use)
- **https://exchangeratesapi.io/** - Backup option (not currently used)

Here's a documentation-focused report for the three APIs. I've pulled out how to use them, the request/response payloads, auth, and notes relevant to a Flutter/mobile app.

## Executive snapshot

- **Frankfurter.dev** (Primary - Free): No API key required. Very simple latest, convert, and timeseries endpoints. Great for MVP and charting with minimal friction. Currently used in the project.
- **CurrencyAPI.com** (Secondary - Paid): API key-based. Modern, flexible pricing, good for larger projects with lots of currencies. Provides more frequent rate updates. Currently used in the project.
- **Exchangeratesapi.io** (Backup): API-key-based. Solid, widely used, good docs. Listed as a backup option but not currently integrated.
- **Current implementation**: Using Frankfurter.dev as primary free API, supplemented with CurrencyAPI.com for more frequent rate updates and broader currency coverage.

## Methodology (what I searched and checked)

- Read official docs for each service (endpoints, parameters, payload formats, auth requirements).
- Collected example requests and typical responses for:
    - Latest/live rates
    - Time series/historical data
    - Convert endpoints (if available)
- Noted auth requirements, rate limits, pricing, and any caveats relevant to mobile apps (latency, CORS, offline fallback).
- Assessed ease of use and integration in a Flutter/Dart context.

### Frankfurter.dev (https://frankfurter.dev/)

- Auth: none (no API key)
- See `rest-api/frankfurter.http`

## CurrencyAPI.com (https://currencyapi.com/pricing/)

- Auth: API key
- See `rest-api/currencyapi.http`

## Exchangeratesapi.io (https://exchangeratesapi.io/)

- Auth: API key
- See `rest-api/exchangeratesapi.http`

## Limitations and gaps (relevant to these three)

- Frankfurter.dev: No auth, great for MVP but no formal SLA; data sources are community-maintained.
- CurrencyAPI.com: Pricing tiers may influence scale; ensure your plan aligns with expected currency coverage and historical depth.
- Exchangeratesapi.io: Key-based; plan limits can impact MVP if you hit rate ceilings; ensure key management in the app.
- Coverage differences: Some providers have stronger historical depth for certain currencies; if you rely heavily on a particular pair, verify historical availability in your target window.

## Recommendations (actionable)

- **Current implementation**:
    - Primary: Frankfurter.dev for live + timeseries (no key) - currently active
    - Secondary: CurrencyAPI.com for more frequent rate updates and broader currency coverage - currently active
    - Backup: Exchangeratesapi.io documented as fallback option but not currently integrated
- **Future scaling**:
    - Consider implementing a lightweight backend to fetch from multiple providers, cache results, and present a unified payload to the mobile app
    - Monitor rate limits and update frequencies to optimize between free and paid API usage
- **Architecture note**:
    - Current approach uses dual API strategy for reliability and performance
    - Keep a simple data model for rates: baseCurrency, targetCurrency, timestamp, rate, sourceProvider

## Sources (docs you’ll want to consult)

- Frankfurter.dev docs: https://frankfurter.dev/
- Exchangeratesapi.io docs: https://exchangeratesapi.io/docs
- CurrencyAPI pricing/docs: https://currencyapi.com/pricing/ and https://currencyapi.com/docs
