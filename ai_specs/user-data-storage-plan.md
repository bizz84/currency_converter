[ ] Add dependency: add `shared_preferences` to `pubspec.yaml` under `dependencies`, then run `flutter pub get`.
[ ] Define storage keys and defaults: `user_prefs/base_currency`, `user_prefs/target_currencies`, `user_prefs/amount`; defaults: `GBP`, `[EUR, USD, JPY]`, `100.0`.
[ ] Implement repository: create `lib/src/storage/user_prefs_repository.dart` with `UserPrefsRepository` using `SharedPreferences` to load/save base, targets (JSON array of codes), and amount.
[ ] Add (de)serialization helpers: map `Currency` ⇄ `String` via `Currency.from(code)`; ignore unknown codes; dedupe targets and exclude base from targets.
[ ] Introduce Riverpod providers: `userPrefsRepositoryProvider` (singleton) and `@riverpod class UserPrefs extends _$UserPrefs` state with `base`, `targets`, `amount` + methods to update and persist.
[ ] Generate code: run `dart run build_runner build --delete-conflicting-outputs` to create provider `.g.dart` files.
[ ] Load on startup: initialize `UserPrefs` by reading from repository in `build()`/`init` of the notifier so first read returns stored values or defaults.
[ ] Refactor `ConvertScreen`: replace local `baseCurrency`, `amount`, `targetCurrencies` with `ref.watch(userPrefsProvider)`; update UI callbacks to call notifier methods.
[ ] Persist on changes: wire base change, amount change, add/remove/reorder targets to repository via notifier; invalidate `latestRatesProvider(base)` on base change.
[ ] Debounce amount writes: add 300ms debounce inside notifier to avoid frequent SharedPreferences writes while typing.
[ ] Error handling: fall back to defaults when prefs missing/corrupt; guard against empty targets; ensure base rate displays as 1.0.
[ ] Tests (unit): add `test/src/storage/user_prefs_repository_test.dart` using `SharedPreferences.setMockInitialValues({})` to verify read/write and validation.
[ ] Tests (integration/widget): minimal test that `ConvertScreen` reflects stored prefs and updates persist after interactions.
[ ] Quality checks: run `flutter analyze`, `dart format .`, and `flutter test` locally; fix issues.
[ ] Documentation: add a short "User Data Persistence" note to `README.md` describing what is stored and how to reset (clear app storage).
