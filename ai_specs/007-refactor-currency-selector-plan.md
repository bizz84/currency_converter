# Refactor Currency Selector - Implementation Plan

## Overview

Move `adaptive_currency_picker.dart` and `currency_selector.dart` from `lib/src/screens/convert/` to a new `lib/src/screens/selector/` directory, since these components are reusable and not specific to the convert screen.

## Implementation

### Phase 1: Create new directory and move files
- [ ] Create `lib/src/screens/selector/` directory
- [ ] Move `adaptive_currency_picker.dart` to `lib/src/screens/selector/`
- [ ] Move `currency_selector.dart` to `lib/src/screens/selector/`

### Phase 2: Update imports
- [ ] Update import in `convert_screen.dart` (line 12)
- [ ] Update import in `base_currency_widget.dart` (line 4)
- [ ] Update absolute imports within moved files to use `/src/` pattern

### Phase 3: Verification
- [ ] Run `flutter analyze` to check for issues
- [ ] Run `flutter test` to ensure all tests pass

## Implementation Notes

- Both files are reusable components that could be used in other screens (e.g., charts screen)
- The `adaptive_currency_picker.dart` file already imports from `../../data/` and `../../network/`, which will remain valid after the move
- No breaking changes to public APIs, only internal import path updates
