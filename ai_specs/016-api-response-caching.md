If the app is in offline mode or there's a poor connection, the convert and charts screens will show loading spinners and eventually lead to a loading error (see `img/016-charts-loading.jpeg` and `img/016-converter-error.jpeg`).

By caching the relevant API responses, we can improve offline performance and reduce API calls.

Devise a plan for storing responses to the following endpoints (based on the `ApiClient` interface):

- `getLatestRates`
- `getCurrencies`
- `getTimeSeriesRates`

### Encoding considerations

The app supports different API clients with different response formats. When caching data locally, we should use an encoding/decoding format that works with the data types returned by the `ApiClient`, and is likely different from the decoders used by the API clients. Therefore, such data types should defined separate `toCache` and `fromCache` methods.

### Storage considerations

Decide if the encoded data should be stored with SharedPreferences, or with a separate storage system (e.g. sqflite or Drift). Evaluate and present the pros and cons of each option.

### UI Updates

For improved UX, always show the cached data first (if available), then update the cache and UI when successful API responses are received.







