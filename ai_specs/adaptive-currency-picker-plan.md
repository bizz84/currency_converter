# Adaptive Currency Picker Refactoring Plan

## Overview
Refactor the existing `CurrencyPickerDialog` to become `AdaptiveCurrencyPicker` that displays as a bottom modal sheet on mobile devices (width < 600px) and as a dialog on tablets/desktop/web, with drag-to-dismiss gesture support on mobile.

## Requirements
- Mobile devices (width < 600px): Bottom modal sheet with drag-to-dismiss
- Tablets/Desktop/Web (width ≥ 600px): Traditional dialog
- Maintain all existing functionality (search, selection, exclusions)
- Smooth animations and intuitive gestures on mobile

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
- [x] Implement screen size detection:
  - Use `MediaQuery.sizeOf(context).width`
  - Define constant: `const double mobileBreakpoint = 600.0`
  - Return bottom sheet for width < 600px
  - Return dialog for width ≥ 600px

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
- [ ] Coordinate scroll behavior:
  - Connect ListView scrollController with DraggableScrollableSheet
  - Prevent gesture conflicts between list scrolling and sheet dragging
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
lib/src/screens/convert/
├── adaptive_currency_picker.dart
│   ├── AdaptiveCurrencyPicker (main widget)
│   ├── _CurrencyPickerContent (shared content)
│   ├── _AdaptiveCurrencyPickerBottomSheet
│   └── _AdaptiveCurrencyPickerDialog
└── convert_screen.dart (updated to use new picker)
```

## Success Criteria
- ✅ Bottom sheet appears on mobile devices (< 600px width)
- ✅ Dialog appears on tablets/desktop (≥ 600px width)
- ✅ Drag-to-dismiss works smoothly on mobile
- ✅ All existing functionality preserved
- ✅ No UI regressions on any platform
- ✅ Clean code with no duplication between variants
- ✅ Proper state management and disposal