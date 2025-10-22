# Feature: Save chart-related user data to local storage

The app should save all user-selected data in the charts page to local storage so it is persisted across app restarts.

Data to save:

- Source currency
- Target currency
- Range selection (1W, 1M, 3M, 1Y, 5Y, 10Y)

The currently selected tab (convert / charts) should also be saved so the user gets back to the same screen after a restart.

Notes:

- This is a follow up story to `003-user-data-storage-plan.md`

Acceptance criteria:

- Additional keys and methods are added to the `UserPrefsNotifier` to store the chart-related data.
- Unit/widget tests are added to ensure the data is stored and retrieved correctly, similar to how it's done in `convert_screen_persistence_test.dart`.

