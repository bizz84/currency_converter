# Refactor Currency Selector - Implementation Plan

## Overview

Move `adaptive_currency_picker.dart` and `currency_selector.dart` from `lib/src/screens/convert/` to a new `lib/src/screens/selector/` directory, since these components are reusable and not specific to the convert screen.

## Implementation

### Phase 1: Create new directory and move files
- [x] Create `lib/src/screens/selector/` directory
- [x] Move `adaptive_currency_picker.dart` to `lib/src/screens/selector/`
- [x] Move `currency_selector.dart` to `lib/src/screens/selector/`

### Phase 2: Update imports
- [x] Update import in `convert_screen.dart` (line 12)
- [x] Update import in `base_currency_widget.dart` (line 4)
- [x] Update absolute imports within moved files to use `/src/` pattern

### Phase 3: Code organization improvements
- [x] Extract data callback into separate `_CurrencyPickerData` widget
- [x] Move `CurrencyPickerContent` to separate `currency_picker_content.dart` file
- [x] Make `CurrencyPickerContent` public for reusability

### Phase 4: Verification
- [x] Run `flutter analyze` to check for issues
- [x] Run `flutter test` to ensure all tests pass

## Implementation Notes

- Both files are reusable components that could be used in other screens (e.g., charts screen)
- Converted all imports to absolute imports (`/src/...`) for consistency
- Extracted `_CurrencyPickerContent` into separate file for better code organization
- Made `CurrencyPickerContent` public to allow reuse across the app
- No breaking changes to public APIs
- All 36 tests passing
