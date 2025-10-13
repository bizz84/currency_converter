I want to build a currency converter app that supports all the major currencies (USD, EUR, GBP, JPY, etc.)

The app should be built with Flutter and have the following screens:

## Convert Screen

- From and To currency dropdowns, amount input, instant conversion as you type
- Option to add multiple "To" currencies
- Drag & drop so multiple currencies can be reordered
- Currency at the top is always the base currency
- Currencies below should report the conversion rate to the base currency
- Last updated time, time until (auto) refresh

Sample UI design: `img/convert-preview.jpeg`

## Currency Selector Screen

- Used to choose the base and target currencies for the convert and chart screens
- Shows list of all available currencies
- Includes previously used currencies at the top

Sample UI design: `img/select-currency-preview.jpeg`

## Charts Screen

- Side by side dropdown selector for the two currencies
- Chart header:
  - Show the exchange rate (live or historical) (E.g. 1 GBP = 1.156813 EUR)
  - Ranges selector (e.g. 1D, 1W, 1M, 3M, 1Y, 5Y, 10Y)
- Chart body: line chart over the selected range
- Y axis with high, medium, low labels
- On tap and hold: show vertical line and update the exchange rate in the header

Sample UI design: `img/chart-preview.jpeg`


