RESEARCH ROLE: You are a software researcher with expertise in backend, APIs, mobile apps.
RESEARCH QUESTION: Compare and contrast APIs for currency exchange rates

RESEARCH CONTEXT:
- Purpose: Research currency exchange APIs for a currency converter app
- Scope: Live conversion for primary currencies (USD, GBP, EUR, etc.), historical rates, time series range
- Audience: Software developers that will build this app
- Constraints: Find APIs that are easy to setup/use, not too expensive (prefer pay per use to monthly subscriptions)

METHODOLOGY:
Literature scan 
Get all relevant APIs from this list:
https://github.com/public-apis/public-apis?tab=readme-ov-file#finance
Other APIs previously considered:
https://www.exchangerate-api.com/
https://currencybeacon.com/
Also do a web search for other popular APIs, aiming to gather ~10 suitable APIs

ANALYSIS REQUIREMENTS:
- Compare/contrast different APIs
- Figure out what features they offer
- Gather information about their request/response payloads (from the documentation)
- Assess ease of setup/use
- Find our which API offers a time series range endpoint at the lowest price

REQUIRED ENDPOINTS:
- Latest rates
- Historical rates for specific date
- Time series range
- Get list of available currencies

OUTPUT STRUCTURE:
- Executive summary [key findings, implications]
- Methodology overview [how research was conducted]
- Evidence report [comparison of all APIs regarding cost, features, supported endpoints, authentication type, request and response format, and an overall qualitative assessment]
- Limitations and gaps
- Recommendations for action/further research

EVIDENCE REPORT:

Make a report with a H2 heading for each API, including:
- API name (in the heading)
- API docs URL
- Pricing URL
- Pricing tiers and features

Example:

## OpenExchangeRates

API docs: https://docs.openexchangerates.org/reference/api-introduction
Pricing: https://openexchangerates.org/signup

### Free Plan
- price: free
- hourly updates
- base currency USD
- 1,000 monthly API requests
### Developer Plan
- price: $12/month
- hourly updates
- 10,000 monthly API requests
+ All base currencies available
### Enterprise Plan
- price: $47/month
- 30-minute updates
- 100,000 monthly API requests
+ Time-series requests
### Unlimited Plan
- price: $97/month
- 5-minute updates
- Unlimited API requests
+ Currency conversion requests


STOP CONDITIONS: Complete when research question is thoroughly addressed with multiple perspectives considered.
