## API Access

Currency API data can be pulled from one of these APIs:

- https://frankfurter.dev/
- https://exchangeratesapi.io/
- https://currencyapi.com/

Here’s a documentation-focused report for the three APIs you flagged: Frankfurter.dev, Exchangeratesapi.io, and CurrencyAPI.com. I’ve pulled out how to use them, the request/response payloads, auth, and notes relevant to a Flutter/mobile app.

## Executive snapshot

- Frankfurter.dev: No API key required. Very simple latest, convert, and timeseries endpoints. Great for MVP and charting with minimal friction.
- Exchangeratesapi.io: API-key-based. Solid, widely used, good docs. Pays off as you scale or need more bases/credits.
- CurrencyAPI.com: API key-based. Modern, flexible pricing, good for larger projects with lots of currencies. Clear docs and useful historical endpoints.
- Practical stance: Use Frankfurter.dev for MVP + redundancy, supplement with Exchangeratesapi.io or CurrencyAPI.com as you scale and need SLAs, broader base currencies, or higher quotas.

## Methodology (what I searched and checked)

- Read official docs for each service (endpoints, parameters, payload formats, auth requirements).
- Collected example requests and typical responses for:
    - Latest/live rates
    - Time series/historical data
    - Convert endpoints (if available)
- Noted auth requirements, rate limits, pricing, and any caveats relevant to mobile apps (latency, CORS, offline fallback).
- Assessed ease of use and integration in a Flutter/Dart context.

### Frankfurter.dev ([**https://frankfurter.dev/**](https://frankfurter.dev/))

### How to use

- Auth: none (no API key)
- Base URL: [**https://frankfurter.app**](https://frankfurter.app/)
- Endpoints
    - Latest rates
        - GET /latest?from=USD&to=GBP
        - Optional: &amount=1
    - Time series
        - GET /<start>..<end>?from=USD&to=GBP
    - Convert helper (simple use)
        - GET /latest?amount=1&from=USD&to=GBP
- Request examples
    - Latest: [**https://frankfurter.app/latest?from=USD&to=GBP**](https://frankfurter.app/latest?from=USD&to=GBP)
    - Timeseries: [**https://frankfurter.app/2023-01-01..2023-01-31?from=USD&to=GBP**](https://frankfurter.app/2023-01-01..2023-01-31?from=USD&to=GBP)
- Response payloads (typical shapes)
    - Latest
        - {"amount": 1,"base": "USD","date": "YYYY-MM-DD","rates": { "GBP": 0.75, "EUR": 0.92, ... }}
    - Timeseries (simplified)
        - {"base": "USD","start_date": "YYYY-MM-DD","end_date": "YYYY-MM-DD","rates": {"2023-01-01": { "GBP": 0.75, "EUR": 0.92 },"2023-01-02": { "GBP": 0.76, "EUR": 0.93 },...}}
- Pros/cons
    - Pros: No keys, ultra-simple, good for MVP and charts.
    - Cons: Data sources can vary; uptime is good but not backed by a formal SLA.

### Documentation notes

- Simple, human-friendly docs; endpoints are intuitive; JSON payloads are straightforward.
- Great fit for a lightweight converter and historical charts in a mobile app.

## Exchangeratesapi.io ([**https://exchangeratesapi.io/**](https://exchangeratesapi.io/))

### What it is

- A well-known FX API that typically requires an API key (pricing tiers vary).
- Often used via the API Layer ecosystem; current docs emphasize standard REST endpoints with base currency and symbol filtering.

### How to use

- Auth: API key (query param or header; check your plan)
- Base URL: [**https://api.exchangeratesapi.io**](https://api.exchangeratesapi.io/) (or apilayer variants; verify your plan’s base URL)
- Endpoints (typical)
    - Latest rates
        - GET /latest?base=USD&symbols=GBP,EUR
    - Historical / timeseries
        - GET /YYYY-MM-DD?base=USD&symbols=GBP,EUR
        - Or: /timeseries?start_date=YYYY-MM-DD&end_date=YYYY-MM-DD&base=USD&symbols=GBP,EUR
    - Convert (if supported by plan)
        - GET /convert?from=USD&to=GBP&amount=1
- Request examples (typical)
    - Latest: [**https://api.exchangeratesapi.io/latest?base=USD&symbols=GBP,EUR**](https://api.exchangeratesapi.io/latest?base=USD&symbols=GBP,EUR)
    - Timeseries: [**https://api.exchangeratesapi.io/2023-01-01?base=USD&symbols=GBP,EUR**](https://api.exchangeratesapi.io/2023-01-01?base=USD&symbols=GBP,EUR)
- Response payloads (typical)
    - Latest
        - {"rates": { "GBP": 0.75, "EUR": 0.92 },"base": "USD","date": "YYYY-MM-DD"}
    - Timeseries
        - {"rates": {"2023-01-01": { "GBP": 0.75, "EUR": 0.92 },"2023-01-02": { "GBP": 0.76, "EUR": 0.93 },...},"base": "USD","start_date": "2023-01-01","end_date": "2023-01-31"}
- Authentication, pricing, and limits
    - Requires API key on most plans.
    - Free tier exists on some plans with limited quotas; higher tiers unlock more currencies and higher rate limits.
- Pros/cons
    - Pros: Widely used, good historical coverage, solid docs.
    - Cons: Requires API key; some plan tiers can throttle during peak times; ensure your mobile app handles API key securely.

Documentation notes

- Expect standard REST patterns, clear parameters for base and symbols, and well-structured date-based history.
- Useful if you need reliable quotas and SLAs as you scale.

## CurrencyAPI.com ([**https://currencyapi.com/pricing/**](https://currencyapi.com/pricing/)) / docs reference

### What it is

- Modern currency API with explicit pricing pages and a documented v3 API.
- Endpoints are designed for live, historical, and convert data with a clear pay-as-you-go model.

### Key docs and usage

- Auth: API key
- Base URL (typical)
    - [**https://api.currencyapi.com/v3/latest**](https://api.currencyapi.com/v3/latest)
    - [**https://api.currencyapi.com/v3/historical**](https://api.currencyapi.com/v3/historical)
    - [**https://api.currencyapi.com/v3/convert**](https://api.currencyapi.com/v3/convert) (if supported by their docs; usage varies by version)
- Typical request patterns (latest)
    - GET [**https://api.currencyapi.com/v3/latest?apikey=YOUR_API_KEY&base_currency=USD&symbols=GBP,EUR**](https://api.currencyapi.com/v3/latest?apikey=YOUR_API_KEY&base_currency=USD&symbols=GBP,EUR)
- Historical
    - GET [**https://api.currencyapi.com/v3/historical?apikey=YOUR_API_KEY&base_currency=USD&symbols=GBP,EUR&date=2023-01-31**](https://api.currencyapi.com/v3/historical?apikey=YOUR_API_KEY&base_currency=USD&symbols=GBP,EUR&date=2023-01-31)
- Convert (if supported)
    - GET [**https://api.currencyapi.com/v3/convert?apikey=YOUR_API_KEY&from_currency=USD&to_currency=GBP&amount=1**](https://api.currencyapi.com/v3/convert?apikey=YOUR_API_KEY&from_currency=USD&to_currency=GBP&amount=1)
- Response payloads (typical shapes)
    - Latest
        - {"data": {"USD": { "code": "USD", "value": 1 },"GBP": { "code": "GBP", "value": 0.75 },"EUR": { "code": "EUR", "value": 0.92 }},"meta": { "timestamp": "2024-09-10T12:34:56Z" }}
    - Historical
        - {"data": {"USD": { "code": "USD", "value": 1 },"GBP": { "code": "GBP", "value": 0.75 },"EUR": { "code": "EUR", "value": 0.92 }},"meta": { "date": "2023-01-31", "timestamp": 169xxxxx }}
- Pricing and tiers
    - CurrencyAPI has a pay-as-you-go model and monthly plans; pricing page lists quotas per tier and included currencies.
    - Their docs emphasize ease of use with a single API key and consistent data shapes across endpoints.

### Documentation notes

- Clear, modern docs with explicit examples for latest/historical/convert.
- Pricing is explicit on the pricing page; good for budgeting in a production app.

## Concrete payload examples (quick-glance)

- Frankfurter.dev
    - Latest request:
        - GET [**https://frankfurter.app/latest?from=USD&to=GBP**](https://frankfurter.app/latest?from=USD&to=GBP)
    - Response:
        - { "base": "USD", "date": "YYYY-MM-DD", "rates": { "GBP": 0.75, "EUR": 0.92 } }
    
    Check Domain
    
- Exchangeratesapi.io
    - Latest request (example with key):
        - GET [**https://api.exchangeratesapi.io/latest?base=USD&symbols=GBP,EUR&access_key=YOUR_KEY**](https://api.exchangeratesapi.io/latest?base=USD&symbols=GBP,EUR&access_key=YOUR_KEY)
    - Response:
        - { "rates": { "GBP": 0.75, "EUR": 0.92 }, "base": "USD", "date": "YYYY-MM-DD" }
    
    Check Domain
    
- CurrencyAPI.com
    - Latest request:
        - GET [**https://api.currencyapi.com/v3/latest?apikey=YOUR_API_KEY&base_currency=USD&symbols=GBP,EUR**](https://api.currencyapi.com/v3/latest?apikey=YOUR_API_KEY&base_currency=USD&symbols=GBP,EUR)
    - Response:
        - {"data": {"USD": { "code": "USD", "value": 1 },"GBP": { "code": "GBP", "value": 0.75 },"EUR": { "code": "EUR", "value": 0.92 }},"meta": { "timestamp": "..." }}
    
    Check Domain
    

## Implementation notes for Flutter apps (concise)

- Use the http package. Build a tiny wrapper per API to normalize payloads into a common Dart model:
    - class RateResponse { final String base; final DateTime date; final Map<String, double> rates; }
    - class TimeSeriesPoint { final DateTime date; final Map<String, double> rates; }
- For each API, map the JSON to RateResponse (or a common DTO) and handle:
    - Missing currencies
    - Different date formats (YYYY-MM-DD)
    - Fallback: queue a retry, switch to a backup provider if a rate is missing
- Caching strategy: cache last 5–15 minutes of live rates; prefetch daily series for charts.
- Security: store API keys securely (e.g., in Flutter options via secure storage or backend proxy).

## Limitations and gaps (relevant to these three)

- Frankfurter.dev: No auth, great for MVP but no formal SLA; data sources are community-maintained.
- Exchangeratesapi.io: Key-based; plan limits can impact MVP if you hit rate ceilings; ensure key management in the app.
- CurrencyAPI.com: Pricing tiers may influence scale; ensure your plan aligns with expected currency coverage and historical depth.
- Coverage differences: Some providers have stronger historical depth for certain currencies; if you rely heavily on a particular pair, verify historical availability in your target window.

## Recommendations (actionable)

- MVP setup:
    - Primary: Frankfurter.dev for live + timeseries (no key).
    - Secondary: Exchangeratesapi.io for redundancy and broader plan-based capabilities.
- Production scaling:
    - Add CurrencyAPI.com or CurrencyLayer for higher quotas and stable SLAs; use a backend aggregator to unify data from two sources.
- Architecture note:
    - Implement a lightweight backend (Node/Go) to fetch from 2 providers, cache results, and present a unified payload to the mobile app.
- UI/UX note:
    - Keep a simple data model for rates: baseCurrency, targetCurrency, timestamp, rate, sourceProvider.

## Sources (docs you’ll want to consult)

- Frankfurter.dev docs: [**https://frankfurter.dev/**](https://frankfurter.dev/)
- Exchangeratesapi.io docs: [**https://exchangeratesapi.io/docs**](https://exchangeratesapi.io/docs)
- CurrencyAPI pricing/docs: [**https://currencyapi.com/pricing/**](https://currencyapi.com/pricing/) and [**https://www.currencyapi.net/docs**](https://www.currencyapi.net/docs)

If you want, I can draft concrete Dart models and a tiny Dart/Flutter HTTP wrapper for these three APIs (with a simple retry/backoff and a small in-app cache) to accelerate your MVP.