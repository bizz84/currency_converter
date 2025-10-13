# Feature: Save user-selected data to local storage

The app should save all user-selected data (base currencies, target currencies list) to local storage so they are persisted across app restarts.

Consider:

- Which local storage solution to use (this should work on iOS, Android, and web)
- Format of the data to store
- How to load the data on app startup
- How to persist the data when the user makes changes (change base currency, add/remove/reorder target currencies)

Make a plan for implementing this feature, outlining various options and their tradeoffs. Keep it simple.