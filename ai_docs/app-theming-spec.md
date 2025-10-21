# App Theming System Specification

## Overview

This app uses a comprehensive theming system built on Material Design 3 with custom theme extensions. The system provides consistent colors, text styles, and component themes across all screens while enabling easy app rebranding through a single seed color.

**Implementation Date:** October 2025
**Status:** Complete and production-ready

## Core Architecture

### Single Seed Color Approach

The entire color scheme is generated from one seed color using Material Design 3's `ColorScheme.fromSeed()`:

```dart
// lib/src/theme/app_theme.dart
static const seedColor = Color(0xFF1976D2); // Blue

final colorScheme = ColorScheme.fromSeed(
  seedColor: seedColor,
  brightness: Brightness.light,
);
```

**Why this approach:**
- **Easy rebranding:** Change one hex value to rebrand the entire app
- **Automatic harmony:** Material Design generates harmonious color variations
- **No manual shade definitions:** No need to define shade100, shade200, etc.

### Theme Files Structure

```
lib/src/theme/
├── app_theme.dart              # Main theme configuration
└── app_theme_extensions.dart   # Custom color and text style extensions
```

## Custom Theme Extensions

### AppColorExtension

Defines semantic colors for app-specific use cases:

```dart
class AppColorExtension extends ThemeExtension<AppColorExtension> {
  final Color chartLine;        // Chart line color
  final Color chartDot;         // Chart touch indicator dot
  final Color positive;         // Positive rate changes (green)
  final Color negative;         // Negative rate changes (red)
  final Color positiveLight;    // Semi-transparent positive (for backgrounds)
  final Color negativeLight;    // Semi-transparent negative (for backgrounds)
}
```

**Usage:**
```dart
Theme.of(context).appColors.chartLine
Theme.of(context).appColors.positive
Theme.of(context).appColors.negativeLight
```

### AppTextStyleExtension

Defines text styles with specific formatting requirements:

```dart
class AppTextStyleExtension extends ThemeExtension<AppTextStyleExtension> {
  final TextStyle flagEmojiStyle;           // Currency flag emojis (24px)
  final TextStyle conversionAmountStyle;    // Conversion amounts with tabular figures
  final TextStyle exchangeRateHeaderStyle;  // Exchange rate headers with tabular figures
}
```

**Usage:**
```dart
Theme.of(context).appTextStyles.conversionAmountStyle
Theme.of(context).appTextStyles.exchangeRateHeaderStyle
```

**Important:** `conversionAmountStyle` includes explicit `color: colorScheme.onSurface` for darker text. Other styles may inherit default colors.

### Tabular Figures

Both `conversionAmountStyle` and `exchangeRateHeaderStyle` use tabular figures for proper number alignment:

```dart
fontFeatures: const [FontFeature.tabularFigures()]
```

This ensures numbers in columns align vertically regardless of digit width.

## Material Component Themes

### ChipTheme (Time Range Selector)

**Critical discoveries:**
- Material 3's ChipTheme doesn't automatically infer text colors from colorScheme
- Must explicitly set both `labelStyle` and `secondaryLabelStyle`
- Padding must be carefully balanced to prevent overflow

```dart
chipTheme: ChipThemeData(
  backgroundColor: Colors.transparent,
  selectedColor: colorScheme.primary,
  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6), // Reduced from 12x8
  labelStyle: TextStyle(fontSize: 14, color: colorScheme.onSurface),      // Unselected
  secondaryLabelStyle: TextStyle(fontSize: 14, color: colorScheme.onPrimary), // Selected
  side: BorderSide(color: colorScheme.outline),
),
```

**Issues solved:**
1. **White text on white background:** Fixed by adding explicit `color: colorScheme.onSurface` to labelStyle
2. **Chip overflow:** Fixed by reducing padding from `(12, 8)` to `(8, 6)`

### InputDecorationTheme (TextFields)

**Key decision:** Use `outlineVariant` (lighter) instead of `outline` (darker) to match currency selector borders.

```dart
inputDecorationTheme: InputDecorationTheme(
  filled: false,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: colorScheme.outlineVariant), // Lighter border
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: colorScheme.outlineVariant),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: colorScheme.primary, width: 2),
  ),
  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
),
```

## Reusable Theme-Based Widgets

### ErrorStateWidget

Replaces duplicated error UI patterns (3 instances eliminated):

```dart
ErrorStateWidget(message: 'Failed to load currencies')
```

**Features:**
- Uses `colorScheme.error` for icon color
- Uses `Sizes.p48` for icon size
- Consistent padding and layout
- Located in `lib/src/common_widgets/error_state_widget.dart`

### DragHandleWidget

Consistent drag handle for bottom sheets (2 instances eliminated):

```dart
const DragHandleWidget()
```

**Features:**
- Uses `colorScheme.outline` for color
- Standard dimensions: 40x4 with 12px vertical margin
- Located in `lib/src/common_widgets/drag_handle_widget.dart`

### CurrencyFlagText

Consistent flag emoji display (9 instances eliminated):

```dart
CurrencyFlagText(flag: currency.flag)
```

**Features:**
- Uses `appTextStyles.flagEmojiStyle` (24px)
- Located in `lib/src/common_widgets/currency_flag_text.dart`

## Color Mapping Reference

### Standard ColorScheme Colors

```dart
// Surfaces
Colors.white → colorScheme.surface
Colors.black38 → colorScheme.onSurfaceVariant

// Semantic colors
Colors.red → colorScheme.error
Colors.blue → colorScheme.primary

// Borders and dividers
Colors.grey → colorScheme.outlineVariant  // For subtle borders
              colorScheme.outline          // For prominent borders
              dividerColor                 // Same as outlineVariant
```

### Custom Semantic Colors

```dart
// Rate changes
Colors.green → appColors.positive
Colors.red → appColors.negative

// Status indicators (semi-transparent backgrounds)
Colors.green.withOpacity(0.15) → appColors.positiveLight
Colors.red.withOpacity(0.15) → appColors.negativeLight

// Chart elements
Colors.blue.shade700 → appColors.chartLine
Colors.blue.shade700 → appColors.chartDot
```

## Common Theming Tasks

### How to Change the App's Primary Color

Edit one line in `lib/src/theme/app_theme.dart`:

```dart
static const seedColor = Color(0xFF1976D2); // Change this hex value
```

The entire app will adopt the new color scheme based on Material Design 3 color generation.

### How to Access Theme Colors in Widgets

```dart
// Standard Material colors
Theme.of(context).colorScheme.primary
Theme.of(context).colorScheme.error
Theme.of(context).colorScheme.surface
Theme.of(context).dividerColor

// Custom semantic colors
Theme.of(context).appColors.positive
Theme.of(context).appColors.chartLine
Theme.of(context).appColors.negativeLight
```

### How to Access Theme Text Styles

```dart
// Standard Material text styles
Theme.of(context).textTheme.titleLarge
Theme.of(context).textTheme.bodyMedium
Theme.of(context).textTheme.labelSmall

// Custom text styles
Theme.of(context).appTextStyles.conversionAmountStyle
Theme.of(context).appTextStyles.exchangeRateHeaderStyle
Theme.of(context).appTextStyles.flagEmojiStyle
```

### How to Create Error State UI

Use the reusable widget:

```dart
ErrorStateWidget(message: 'Your error message here')
```

Don't create custom error UI with Icons and Text widgets.

### How to Add a Drag Handle to Bottom Sheets

Use the reusable widget:

```dart
const DragHandleWidget()
```

Don't create custom Container with hardcoded colors and dimensions.

## Critical Implementation Details

### Theme Extensions Require Non-Null Values

The extension getters use `!` operator:

```dart
extension AppThemeExtensions on ThemeData {
  AppColorExtension get appColors => extension<AppColorExtension>()!;
  AppTextStyleExtension get appTextStyles => extension<AppTextStyleExtension>()!;
}
```

**Implication for tests:** All widget tests must use `AppTheme.lightTheme()` instead of bare `MaterialApp()` to ensure theme extensions are registered.

**Bad:**
```dart
MaterialApp(
  home: MyWidget(),
)
```

**Good:**
```dart
MaterialApp(
  theme: AppTheme.lightTheme(),
  home: MyWidget(),
)
```

### Colors.transparent Exception

`Colors.transparent` is allowed for structural purposes:

```dart
showModalBottomSheet<Currency>(
  backgroundColor: Colors.transparent, // OK - structural, not themeable
  // ...
)
```

**Why:** The transparent background allows the child widget's rounded corners to display properly. This is a technical necessity, not a stylistic choice.

### Const vs Non-Const in Theme Extensions

`AppColorExtension` is const (all colors are const).
`AppTextStyleExtension` is **not const** because `conversionAmountStyle` includes a non-const color reference:

```dart
AppTextStyleExtension(
  flagEmojiStyle: const TextStyle(fontSize: 24),

  conversionAmountStyle: TextStyle(
    // ...
    color: colorScheme.onSurface, // Non-const reference
  ),

  exchangeRateHeaderStyle: const TextStyle(/* ... */),
)
```

## Known Issues and Solutions

### Issue: Chip Text Unreadable (White on White)

**Problem:** ChipTheme without explicit colors shows white text on white background.

**Solution:** Add explicit colors to both labelStyle and secondaryLabelStyle:

```dart
labelStyle: TextStyle(fontSize: 14, color: colorScheme.onSurface),
secondaryLabelStyle: TextStyle(fontSize: 14, color: colorScheme.onPrimary),
```

### Issue: Chips Overflow Screen Width

**Problem:** Chips with excessive padding extend beyond screen width.

**Solution:** Reduce padding from `(12, 8)` to `(8, 6)`:

```dart
padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
```

### Issue: TextField Height Mismatch

**Problem:** TextField appears shorter than adjacent currency selector.

**Attempted Solution:** Increasing vertical padding caused blank space in modal sheets.

**Current State:** Slight height mismatch accepted as acceptable trade-off.

### Issue: Test Failures with Theme Extensions

**Problem:** Tests fail with null errors when accessing `appColors` or `appTextStyles`.

**Solution:** Update all tests to use `AppTheme.lightTheme()`:

```dart
// Before
MaterialApp(home: CurrencyConverterApp())

// After
MaterialApp(
  theme: AppTheme.lightTheme(),
  home: const CurrencyConverterApp(),
)
```

## Migration Statistics

**Files Created:** 5
**Files Modified:** 14
**Total Impact:** 30+ instances of hardcoded values replaced

**Colors Replaced:**
- `Colors.white` → `colorScheme.surface` (4 instances)
- `Colors.red` → `colorScheme.error` (5 instances)
- `Colors.blue` / `Colors.blue.shade700` → `appColors.chartLine` / `colorScheme.primary` (4 instances)
- `Colors.green` → `appColors.positive` (3 instances)
- `Colors.grey` → `colorScheme.outlineVariant` / `dividerColor` (3 instances)
- `Colors.black38` → `colorScheme.onSurfaceVariant` (1 instance)

**Text Styles Replaced:**
- `fontSize: 24` → `appTextStyles.flagEmojiStyle` / `CurrencyFlagText` (9 instances)
- `FontWeight.w600` → `appTextStyles.conversionAmountStyle` (2 instances)
- `FontWeight.bold` → `appTextStyles.exchangeRateHeaderStyle` (1 instance)

**Widgets Replaced:**
- Error icon + text pattern → `ErrorStateWidget` (3 instances)
- Drag handle Container → `DragHandleWidget` (2 instances)
- Flag emoji Text → `CurrencyFlagText` (4 instances)

## Future Enhancements

### Dark Mode

To add dark mode, create `AppTheme.darkTheme()` following the same pattern:

```dart
static ThemeData darkTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: Brightness.dark, // Only change needed
  );

  // ... rest follows same pattern as lightTheme()
}
```

Use in MaterialApp:

```dart
MaterialApp(
  theme: AppTheme.lightTheme(),
  darkTheme: AppTheme.darkTheme(),
  themeMode: ThemeMode.system, // or user preference
)
```

### Theme Persistence

Store user's theme preference using shared_preferences and apply on app startup.

### Accessibility Themes

Create high-contrast variants for better accessibility by modifying color intensities in ColorScheme.

## Best Practices for Future Development

1. **Never hardcode colors:** Always use `Theme.of(context).colorScheme.*` or `Theme.of(context).appColors.*`

2. **Never hardcode text styles:** Use `Theme.of(context).textTheme.*` or `Theme.of(context).appTextStyles.*`

3. **Use reusable widgets:** Prefer `ErrorStateWidget`, `DragHandleWidget`, and `CurrencyFlagText` over custom implementations

4. **Test with theme:** Always use `AppTheme.lightTheme()` in widget tests

5. **Colors.transparent is OK:** Only for structural purposes (modal backgrounds, etc.)

6. **Tabular figures for numbers:** Use when displaying financial data or numbers in columns

7. **Document new patterns:** If creating new themed components, document the pattern in this file

## Related Documentation

- **Implementation Plan:** `ai_specs/013-theming-system-plan.md` - Detailed phase-by-phase implementation log with completion notes
- **Project Guidelines:** `CLAUDE.md` - General project conventions and commands
- **API Specification:** `ai_specs/api-spec.md` - API integration details

## Verification Checklist

When adding new features, verify:

- ✅ No hardcoded `Colors.*` values (except `Colors.transparent` for structural use)
- ✅ No hardcoded `fontSize` values
- ✅ No hardcoded `FontWeight` values
- ✅ All tests use `AppTheme.lightTheme()`
- ✅ Theme extensions accessed safely (through helper getters)
- ✅ Reusable widgets used where applicable
- ✅ Run `flutter analyze` with no issues
- ✅ All tests passing (36/36)
