## Exchangerate.host

API docs: https://exchangerate.host/documentation
Pricing: https://exchangerate.host/

Pricing tiers and features
- Free Plan
  - price: free
  - no API key required
  - supports latest rates, historical rates (date-specific), and time series
  - convert endpoint available
  - list of currencies available
- Notes
  - No published paid tiers on the site; the service is commonly used as a free, no-auth option with broad coverage

---

## Frankfurter

API docs: https://frankfurter.dev/
Pricing: Free (ECB-based feed)

Pricing tiers and features
- Free Plan
  - price: free
  - no API key required
  - latest rates
  - historical rates (by date)
  - time-series data support
  - currencies list supported via ECB data
- Notes
  - ECB-based data; simple to use; ideal as a transparent reference feed

---

## Twelve Data

API docs: https://twelvedata.com/docs
Pricing: https://twelvedata.com/pricing

Pricing tiers and features
- Free Plan
  - price: free
  - 8 API calls per minute; ~800 calls per day
  - forex/time-series endpoints available with limited quotas
  - currency list/metadata access
- Grow Plan
  - price: around $29/month (typical figure on public pricing pages)
  - higher rate limits (e.g., more calls per minute)
  - access to more endpoints and higher quotas
- Pro Plan
  - price: higher tier (often in the hundreds per month in public pricing)
  - maximum rate limits and expanded feature set
- Enterprise
  - price: custom
  - bespoke SLAs, higher quotas, potential dedicated support
- Notes
  - Strong option for time-series and FX data with scalable paid tiers

---

## Open Exchange Rates

API docs: https://openexchangerates.org/documentation
Pricing: https://openexchangerates.org/signup

Pricing tiers and features
- Free Trial / Starter
  - price: varies (trial or starter tier)
  - latest rates for many currencies
  - historical/time-series access typically limited by plan
  - currencies list available
- Developer / Growth / Scale (tiers vary by date and region)
  - price: varies by tier
  - more daily/hourly updates, higher quotas
  - broader currency coverage and additional endpoints (e.g., time-series)
- Enterprise
  - price: custom
  - SLA-backed, high quotas, dedicated support
- Notes
  - Established provider with strong ecosystem; pricing frequently updated

---

## Fixer

API docs: https://fixer.io/documentation
Pricing: https://fixer.io/

Pricing tiers and features
- Free Plan
  - price: free
  - limited currencies and rate coverage
  - historical data and some endpoints may be restricted
- Standard / Pro Plans
  - price: varies by plan (commonly in the range of a few to tens of dollars per month)
  - full access to latest, historical, and time-series endpoints
  - broader currency coverage and higher rate limits
  - conversion endpoints and symbol listings
- Enterprise / Custom
  - price: custom
  - higher quotas, SLAs, and priority support
- Notes
  - APILayer-backed; well-documented; straightforward integration

---

## CurrencyLayer

API docs: https://currencylayer.com/documentation
Pricing: https://currencylayer.com/pricing

Pricing tiers and features
- Free Plan
  - price: free
  - limited requests per month
  - hourly updates
  - USD as base currency (typical behavior in free tier)
  - limited currencies
- Starter / Basic / Pro Plans
  - price: varies by tier (commonly starting around $10–$20/month and up)
  - higher monthly quotas
  - more frequent updates and broader currency coverage
  - additional endpoints (e.g., historical, timeseries) depending on plan
- Enterprise
  - price: custom
  - SLA, dedicated support, and very high quotas
- Notes
  - Popular for simple integration; easy to use with a clear pricing ladder

---

## ExchangeRate-API

API docs: https://www.exchangerate-api.com/docs/free
Pricing: https://www.exchangerate-api.com/

Pricing tiers and features
- Free / Open Access
  - price: free
  - open-access endpoint exists (some endpoints may require API key)
  - latest rates available
  - currencies list may be accessible
  - historical/time-series endpoints may require a paid plan
- Paid Plans (various tiers)
  - price: varies by tier
  - higher quotas (monthly requests)
  - broader endpoint access (historical/time-series)
  - potentially more currencies and higher-rate limits
- Enterprise / Custom
  - price: custom
  - SLA and bespoke features
- Notes
  - One of the long-standing free options; official docs emphasize free/open access on at least some endpoints

---

## CurrencyBeacon / CurrencyScoop family

API docs: https://currencybeacon.com/api-documentation
Pricing: https://currencybeacon.com/pricing

Pricing tiers and features
- Free / Trial (if offered)
  - price: varies by plan
  - real-time and historical FX data
  - time-series endpoints
  - currencies list
- Paid Plans
  - price: tiers typically scale with monthly quotas and features
  - higher rate limits, additional data sources, and enterprise options
- Enterprise / Custom
  - price: custom
  - SLAs and priority support
- Notes
  - Clear developer-focused endpoints; widely used for real-time and historical FX data

---

## Alpha Vantage (FX)

API docs: https://www.alphavantage.co/documentation/
Pricing: https://www.alphavantage.co/premium/

Pricing tiers and features
- Free Plan
  - price: free
  - FX data endpoints with rate limits (commonly up to 5 requests per minute, ~500 requests per day)
  - latest FX rates and some time-series data
- Premium Plans
  - price: varies (tiered)
  - higher rate limits
  - broader FX data coverage and additional data types
- Enterprise / Custom
  - price: custom
  - dedicated support and higher SLAs
- Notes
  - Widely used in developer communities; strong docs; rate limits can be constraining for high-traffic apps

---

## TraderMade (Forex REST API)

API docs: https://tradermade.com/docs/restful-api
Pricing: https://tradermade.com/pricing

Pricing tiers and features
- Free Trial / Starter
  - price: varies; typically a free or low-cost initial access
  - live FX quotes
  - historical OHLC time-series data
  - basic currency conversion
- Paid Plans
  - price: tiered (starting at modest monthly fees for higher quotas)
  - higher request limits
  - streaming data (where offered)
  - broader FX instruments and data coverage
- Enterprise
  - price: custom
  - SLA and dedicated support
- Notes
  - Known for FX data quality and flexible time-series functionality

---

## ECB data feed (ECB euro foreign exchange reference rates)

API docs: ECB Data Portal (and ECB eurofxref)
Pricing: Free

Pricing tiers and features
- Free Plan
  - price: free
  - daily reference rates published by ECB
  - no API key required for the ECB feed itself
  - often available in XML (with JSON wrappers possible)
- Time-series / historical
  - time-series access is available via ECB portal or wrappers; some JSON wrappers exist
- Currency list
  - ECB coverage includes major currencies; broader lists may be available via ECB or wrappers
- Notes
  - Gold-standard, transparent data source; ideal for ECB-aligned rates and EUR-centric applications

---

Notes and guidance
- The APIs above cover a spectrum from completely free, no-auth options (exchangerate.host, Frankfurter, ECB-based feeds) to paid plans with higher quotas, faster updates, and broader currency coverage.
- For an MVP currency converter, starting with a free option (exchangerate.host) plus an ECB-based fallback (Frankfurter or ECB eurofxref wrappers) is a strong, low-cost approach.
- If you anticipate higher traffic or need broader base currencies and guaranteed SLAs, consider a paid plan from one or more providers (e.g., Twelve Data, CurrencyLayer, Fixer, Alpha Vantage, TraderMade) and design a simple multi-source strategy with fallbacks.
- Always verify current pricing and plan details on the official pricing pages before making a procurement decision, as tier names, quotas, and update frequencies frequently change.

If you’d like, I can convert this into a downloadable table (CSV/JSON) with endpoints, sample requests, authentication requirements, and pricing tier details for quick comparison.