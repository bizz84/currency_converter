# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Currency converter Flutter app that displays real-time exchange rates and historical charts. The app uses the Frankfurter.dev API (no API key required) for fetching currency data.

## Key Commands

```bash
# Run tests
flutter test

# Run specific test file
flutter test test/src/network/frankfurter_client_test.dart

# Analyze code for issues
flutter analyze

# Run the app
flutter run
```

## Architecture

### Network Layer (`lib/src/network/`)
- **FrankfurterClient**: HTTP client using Dio for API communication
  - Returns typed model objects (CurrencyRates, TimeSeriesRates, Currencies)
  - Base URL: `https://api.frankfurter.dev/v1`
  - No authentication required

### Data Models (`lib/src/data/`)
- **CurrencyRates**: Model for latest/historical exchange rates
- **TimeSeriesRates**: Model for date range exchange rates  
- **Currencies**: Model for available currency list

### API Endpoints Used
- `/latest` - Get latest exchange rates
- `/{date}` - Get historical rates for specific date
- `/{start_date}..{end_date}` - Get time series data
- `/currencies` - Get list of all available currencies

## App Requirements

### Convert Screen
- Currency selector dropdowns (from/to)
- Live conversion as user types
- Support for multiple target currencies
- Drag & drop reordering
- Display conversion rates relative to base currency
- Show last updated time

### Charts Screen  
- Side-by-side currency selectors
- Time range selector (1D, 1W, 1M, 3M, 1Y, 5Y, 10Y)
- Interactive line chart
- Display exchange rate on tap/hold

## Testing

All network requests are mocked using `http_mock_adapter`. Tests verify:
- Correct API endpoint construction
- Query parameter handling
- Response parsing to typed models
- All HTTP methods (latest, historical, time series, currencies)

## AI Specifications

See `ai_specs/` directory for detailed requirements:
- `ui-spec.md` - UI/UX requirements with mockups
- `api-spec.md` - API provider comparison and implementation notes
- `network-layer.md` - Network client requirements
- `network-layer-plan.md` - Implementation checklist
- Create small reusable widgets rather than _buildWidgetX helper methods
- Assume build runner is running in watch mode
- Don't hardcode fontSize and fontWeight in the widgets, use theme properties instead.