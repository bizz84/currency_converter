---
name: run-app
description: Build-check and launch this Flutter app on the iOS simulator or macOS. Use when asked to run, start, or screenshot the app, or to verify native builds after a dependency change.
---

## Setup

The app reads API keys via `String.fromEnvironment` (`lib/src/env/env.dart`), so every build and run passes `--dart-define-from-file rest-api/.env`. That file is gitignored: if it is missing, ask the user for it before building.

## Steps

1. **Build-check** each target with a command that exits on its own:
   - iOS: `flutter build ios --simulator --debug --dart-define-from-file rest-api/.env`
   - macOS: `flutter build macos --debug --dart-define-from-file rest-api/.env`

   Done when it prints `✓ Built`. Swift Package Manager and Xcode errors surface here within a minute or two.
2. **Launch** only after the build-check passes. Find the device id with `xcrun simctl list devices available`, then run `flutter run -d <id> --dart-define-from-file rest-api/.env` in the background, redirecting output to a log in the scratchpad. Read the log within 60s and again at each check-in. Any `Error`, `Exception`, `command not found`, or an exited process is a failure: stop and diagnose. Done when the log shows `Flutter run key commands`.

macOS ships without GNU `timeout`; bound waits with a counted loop instead.

## Swift Package Manager gotchas

Native dependencies come from Swift Package Manager; the app has no CocoaPods. Each platform pins remote packages (e.g. `sentry-cocoa`) in `Runner.xcworkspace/xcshareddata/swiftpm/Package.resolved`. After a pubspec upgrade a plugin can need a newer package version, and the build updates `Package.resolved` on its own. Review and commit that diff.

If resolution fails or a package seems stale, reset per platform:

```sh
flutter clean && flutter pub get
xcodebuild -resolvePackageDependencies -workspace ios/Runner.xcworkspace -scheme Runner   # or macos/
```
