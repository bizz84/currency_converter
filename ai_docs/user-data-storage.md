# User Data Storage

This app persists user selections locally using SharedPreferences on iOS, Android, and Web.

## What We Store
- Base currency: key `user_prefs/base_currency` (String, e.g., "GBP").
- Target currencies: key `user_prefs/target_currencies` (StringList, e.g., ["EUR","USD","JPY"]).
- Amount: key `user_prefs/amount` (double, e.g., 100.0).

Defaults when not set:
- Base: GBP
- Targets: [EUR, USD, JPY]
- Amount: 100.0

Notes:
- Base is allowed in targets. Target list is de-duplicated, order preserved.

## Architecture
- Repository: `lib/src/storage/user_prefs_repository.dart`
  - Sync reads: `loadBase()`, `loadTargets()`, `loadAmount()`
  - Async writes: `saveBase()`, `saveTargets()`, `saveAmount()`
- Notifier: `lib/src/storage/user_prefs_notifier.dart`
  - Provider name (Riverpod 3): `userPrefsProvider`
  - Holds `UserPrefsState` and persists on `setBase`, `setAmount`, `addTarget`, `removeTarget`, `reorderTargets`.
- Eager initialization: `lib/src/utils/shared_preferences_provider.dart` and `lib/main.dart`
  - `sharedPreferencesProvider` is awaited before `runApp` to enable synchronous reads in providers.

## Runtime Behavior
- App startup: Notifier loads state from SharedPreferences; UI reflects stored values.
- On change: UI calls notifier methods; state updates immediately and changes are written to SharedPreferences.
- Rates refresh: Changing base invalidates `latestRatesProvider(base)` to fetch fresh rates. An hourly timer also refreshes.

## Usage Examples
- Read current prefs in a widget:
  - `final prefs = ref.watch(userPrefsProvider);`
- Update amount:
  - `ref.read(userPrefsProvider.notifier).setAmount(200.0);`

## Reset / Troubleshooting
- Clear storage in code (debug):
  - `final p = await SharedPreferences.getInstance(); await p.clear();`
- Mobile: uninstall the app to clear data.
- Web: clear site data in the browser.

## Privacy
- All data is stored locally on the device/browser. No user-identifiable data is transmitted to external services for this feature.

