# Repository Guidelines

## Project Structure & Modules
- `lib/` – app code. Key areas:
  - `lib/main.dart` (entry), `lib/src/app.dart` (root widgets)
  - `lib/src/screens/**` (UI; e.g., `convert/convert_screen.dart`, `charts/charts_screen.dart`)
  - `lib/src/network/**` (API clients; `frankfurter_client.dart` + generated `*.g.dart`)
  - `lib/src/data/**`, `lib/src/utils/**`, `lib/src/common_widgets/**`, `lib/src/constants/**`
- `test/` – unit/widget tests mirroring `lib/` (e.g., `test/src/network/frankfurter_client_test.dart`).
- `rest-api/` – HTTP request samples for manual API checks (VS Code REST Client). Uses `.env` for keys when required.
- Platform folders: `web/`, `android/`, `ios/`, `macos/`.

## Build, Test, and Development
- Install deps: `flutter pub get`
- Codegen (Riverpod, etc.): `dart run build_runner build --delete-conflicting-outputs`
  - For iterative dev: `dart run build_runner watch -d`
- Analyze: `flutter analyze`
- Format: `dart format .`
- Run app: `flutter run` (web: `flutter run -d chrome`)
- Tests: `flutter test`
- Production builds: `flutter build web` | `flutter build apk` | `flutter build ios`

## Coding Style & Naming
- Dart 3 + Flutter lints (`analysis_options.yaml`). Preserve trailing commas.
- Indentation: 2 spaces; no tabs.
- Filenames/dirs: `snake_case.dart` (e.g., `currency_conversion_tile.dart`).
- Types/classes/widgets: `PascalCase`; methods/vars: `lowerCamelCase`; private members: prefix with `_`.
- Do not edit generated files `*.g.dart`.

## Testing Guidelines
- Framework: `flutter_test` with `http_mock_adapter` for network.
- Place tests under `test/` mirroring `lib/` paths; name `*_test.dart`.
- Cover API clients (`src/network`) and pure logic (`src/data`, `src/utils`).
- Run locally with `flutter test` and ensure tests are hermetic (no real HTTP).

## Commit & Pull Requests
- Commits: short imperative subject (≤ 72 chars). Examples: "Add currency selector", "Fix rate parsing". Group related changes.
- PRs must include:
  - Clear description and rationale; link issues when applicable.
  - Screenshots/GIFs for UI changes (mobile + web when relevant).
  - Checklist proof: `flutter analyze`, `dart format .`, tests passing, codegen updated.

## Security & Configuration
- App targets `https://api.frankfurter.dev/v1` (no API key). Keep keys only in `rest-api/.env` for manual calls; do not add secrets to source.
- Network logging via Dio interceptors (`src/utils/logger_dio_interceptor.dart`). Disable verbose logs in production builds.

