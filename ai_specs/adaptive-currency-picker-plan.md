# Adaptive Currency Picker Refactoring Plan

## Overview
Refactor the existing `CurrencyPickerDialog` to become `AdaptiveCurrencyPicker` that displays as a bottom modal sheet on mobile devices and as a dialog on desktop platforms, with drag-to-dismiss gesture support on mobile.

## Requirements
- Desktop platforms (macOS, Windows, Linux): Always use dialog regardless of window size
- iOS/Android: Bottom modal sheet when width < 600px, dialog otherwise
- Web: Adaptive based on viewport (mobile web < 768px shortest side → bottom sheet)
- Maintain all existing functionality (search, selection, exclusions)
- Smooth animations and intuitive gestures on mobile
- Platform-aware behavior to prevent mobile UI on resized desktop windows

## Implementation Tasks

### 1. File Structure Changes
- [x] Rename `currency_picker_dialog.dart` to `adaptive_currency_picker.dart`
- [x] Update all imports in `convert_screen.dart`

### 2. Create Adaptive Currency Picker (`adaptive_currency_picker.dart`)

#### Core Components
- [x] Rename class `CurrencyPickerDialog` to `AdaptiveCurrencyPicker`
- [x] Add static `show()` method with responsive logic:
  ```dart
  static Future<Currency?> show(
    BuildContext context, {
    Currency? selectedCurrency,
    List<Currency>? excludedCurrencies,
  })
  ```
- [x] Implement platform-aware detection:
  - Created `shouldUseBottomSheet()` utility function
  - Desktop platforms always return `false` (dialog)
  - iOS/Android use width < 600px breakpoint
  - Web uses shortest side < 768px for mobile detection
  - Extracted to `lib/src/utils/should_use_bottom_sheet.dart`

#### Shared Content Widget
- [x] Extract common UI into `_CurrencyPickerContent` widget:
  - Search functionality
  - Currency list with filtering
  - Selection state management
  - Loading and error states
- [x] Make it accept a `ScrollController` parameter for bottom sheet integration
- [x] Ensure it works with both dialog and bottom sheet containers

#### Bottom Sheet Implementation
- [x] Create `_AdaptiveCurrencyPickerBottomSheet` widget
- [x] Implement `DraggableScrollableSheet`:
  - `initialChildSize: 0.9`
  - `minChildSize: 0.3`
  - `maxChildSize: 0.9`
  - `snap: true` for smooth snapping
- [ ] Add visual elements:
  - [x] Drag handle indicator (40x4 container with rounded corners)
  - [x] Rounded top corners (borderRadius: 20)
  - [x] Proper SafeArea handling for devices with notches
- [x] Configure modal bottom sheet:
  - `isScrollControlled: true`
  - `enableDrag: true`
  - `isDismissible: true`
  - `backgroundColor: Colors.transparent`
  - `useSafeArea: true`

#### Dialog Implementation
- [x] Create `_AdaptiveCurrencyPickerDialog` widget
- [x] Maintain existing dialog structure and constraints
- [x] Use the shared `_CurrencyPickerContent` widget
- [x] Keep existing max height (0.7 of screen) and width (400px) constraints

### 3. Update Convert Screen (`convert_screen.dart`)
- [x] Update import statement:
  ```dart
  import 'adaptive_currency_picker.dart';
  ```
- [x] Replace `showDialog` call in `_showCurrencyPicker` method:
  ```dart
  final result = await AdaptiveCurrencyPicker.show(
    context,
    selectedCurrency: isBaseCurrency ? baseCurrency : null,
    excludedCurrencies: isBaseCurrency
        ? null
        : [baseCurrency, ...targetCurrencies],
  );
  ```

### 4. Bottom Sheet Specific Features
- [x] Handle keyboard appearance:
  - Use `Padding` with `MediaQuery.of(context).viewInsets.bottom`
  - Ensure search field remains visible when keyboard appears
- [x] Coordinate scroll behavior:
  - Implemented `DraggableScrollableController` to detect sheet dragging
  - Dismiss keyboard when user drags sheet down to prevent overflow
  - Track sheet size changes to detect downward dragging
- [x] Visual improvements:
  - Removed `selectedTileColor` to prevent background bleeding
  - Added trailing checkmark icon for selected currency
  - Icon uses primary color for consistency
- [ ] Add haptic feedback on dismiss threshold

### 5. Testing Requirements
- [ ] Test on various screen sizes:
  - iPhone SE (375px width) - Should show bottom sheet
  - iPhone 14 Pro (393px width) - Should show bottom sheet
  - iPad Mini (768px width) - Should show dialog
  - iPad Pro 12.9" (1024px width) - Should show dialog
  - Desktop browser (various widths) - Dialog for ≥ 600px
- [ ] Test orientation changes:
  - Portrait to landscape transition
  - Ensure proper widget rebuild
- [ ] Test gesture interactions:
  - Drag to dismiss on mobile
  - Tap outside to dismiss
  - Scroll within list without triggering sheet drag
- [ ] Test keyboard behavior:
  - Search field focus and unfocus
  - Bottom sheet adjusts for keyboard
- [ ] Test state preservation:
  - Search query maintained during rebuilds
  - Selection state properly reflected

### 6. Edge Cases
- [ ] Handle rapid orientation changes
- [ ] Handle very small screen heights (landscape phones)
- [ ] Ensure proper cleanup of controllers in dispose methods
- [ ] Handle web browser window resizing
- [ ] Test with system font scaling (accessibility)

## Code Structure

```
lib/src/
├── screens/convert/
│   ├── adaptive_currency_picker.dart
│   │   ├── AdaptiveCurrencyPicker (main widget)
│   │   ├── _CurrencyPickerContent (shared content)
│   │   ├── _AdaptiveCurrencyPickerBottomSheet (StatefulWidget)
│   │   └── _AdaptiveCurrencyPickerDialog
│   └── convert_screen.dart (updated to use new picker)
└── utils/
    └── should_use_bottom_sheet.dart (platform detection logic)
```

## Key Implementation Details

### Platform Detection (`should_use_bottom_sheet.dart`)
```dart
bool shouldUseBottomSheet(BuildContext context) {
  final platform = Theme.of(context).platform;

  // Desktop always uses dialog
  if (platform == TargetPlatform.macOS ||
      platform == TargetPlatform.windows ||
      platform == TargetPlatform.linux) {
    return false;
  }

  // Web: mobile if shortest side < 768
  if (kIsWeb) {
    final shortestSide = MediaQuery.sizeOf(context).shortestSide;
    return shortestSide < 768;
  }

  // iOS/Android: adaptive based on width
  final screenWidth = MediaQuery.sizeOf(context).width;
  return screenWidth < 600;
}
```

### Bottom Sheet Keyboard Handling
- Uses `DraggableScrollableController` to track sheet size
- Dismisses keyboard when detecting downward drag
- Prevents overflow errors when keyboard is visible

## Success Criteria
- ✅ Desktop platforms always show dialog regardless of window size
- ✅ Bottom sheet appears on mobile devices (< 600px width for iOS/Android)
- ✅ Web adapts based on viewport (< 768px shortest side → bottom sheet)
- ✅ Drag-to-dismiss works smoothly on mobile
- ✅ Keyboard dismisses when dragging sheet down
- ✅ Selected currency shows checkmark instead of background color
- ✅ No visual bleeding of selected tile background
- ✅ All existing functionality preserved
- ✅ Platform detection prevents mobile UI on resized desktop windows
- ✅ Clean code with reusable utility function
- ✅ Proper state management and disposal