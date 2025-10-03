Implement the charts screen based on these requirements:

- Side by side dropdown selector for the two currencies
- Chart header:
  - Show the exchange rate (live or historical) (E.g. 1 GBP = 1.156813 EUR)
  - Ranges selector (e.g. 1D, 1W, 1M, 3M, 1Y, 5Y, 10Y)
- Chart body: line chart over the selected range
- Y axis with high, medium, low labels
- On tap and hold: show vertical line and update the exchange rate in the header

Sample UI design: `img/chart-preview.jpeg`

## Chart implementation notes

Use the [line chart API](https://github.com/imaNNeo/fl_chart/blob/main/repo_files/documentations/line_chart.md) from the [FL Chart](https://github.com/imaNNeo/fl_chart) library.




