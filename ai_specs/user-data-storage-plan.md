[x] Add dependency: add `shared_preferences` to `pubspec.yaml` under `dependencies`, then run `flutter pub get`.
[x] Add eager SharedPreferences provider: create `lib/src/utils/shared_preferences_provider.dart` with `@Riverpod(keepAlive: true) Future<SharedPreferences> sharedPreferences(...)` and generate `shared_preferences_provider.g.dart`.
[x] Eagerly initialize in `main.dart`: create a `ProviderContainer`, `await container.read(sharedPreferencesProvider.future)`, then wrap app in `UncontrolledProviderScope(container: container, ...)`.
[x] Define storage keys and defaults: `user_prefs/base_currency`, `user_prefs/target_currencies`, `user_prefs/amount`; defaults: `GBP`, `[EUR, USD, JPY]`, `100.0`.
[x] Implement repository: create `lib/src/storage/user_prefs_repository.dart` with `UserPrefsRepository(SharedPreferences)`; reads are synchronous (`loadBase`, `loadTargets`, `loadAmount`) and writes async.
[x] Add (de)serialization helpers: map `Currency` ⇄ `String` via `Currency.from(code)`; ignore unknown codes; dedupe targets (do not remove base if present).
[x] Introduce Riverpod providers: `userPrefsRepositoryProvider` (reads `sharedPreferencesProvider.requireValue`) and `@riverpod class UserPrefsNotifier extends _$UserPrefsNotifier` state with `base`, `targets`, `amount` + methods to update and persist. Provider name (Riverpod 3): `userPrefsProvider`.
[x] Generate code: run `dart run build_runner build --delete-conflicting-outputs` to create provider `.g.dart` files.
[x] Load on startup: initialize `UserPrefsNotifier` by reading from repository in `build()` so first read returns stored values or defaults.
[x] Refactor `ConvertScreen`: replace local `baseCurrency`, `amount`, `targetCurrencies` with `ref.watch(userPrefsProvider)`; update UI callbacks to call notifier methods.
[x] Persist on changes: wire base change, amount change, add/remove/reorder targets to repository via notifier; invalidate `latestRatesProvider(base)` on base change.
[x] Persist amount immediately on change (no debounce for now).
[x] Error handling: fall back to defaults when prefs missing/corrupt; guard against empty targets; ensure base rate displays as 1.0.
[x] Tests (unit): add `test/src/storage/user_prefs_repository_test.dart` using `SharedPreferences.setMockInitialValues({})` to verify read/write and validation.
[x] Tests (integration/widget): minimal test that `ConvertScreen` reflects stored prefs and updates persist after interactions.
[x] Quality checks: run `flutter analyze`, `dart format .`, and `flutter test` locally; fix issues.
[x] Documentation: add `ai_docs/user-storage.md` explaining keys, defaults, eager init, providers, behavior, and how to reset/clear data.
