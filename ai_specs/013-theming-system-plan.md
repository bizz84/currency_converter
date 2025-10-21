# Theming System Implementation Plan

## Overview

Introduce a comprehensive theming system to eliminate hardcoded colors and text styles across the codebase. The analysis identified 30+ instances of color duplication (Colors.white, Colors.red, Colors.blue, etc.) and text style duplication (fontSize: 24, FontWeight.w600) across 15+ widget files. This plan systematically replaces these with theme-based properties through custom theme extensions.

## Implementation

### Phase 1: Create Theme Extensions for Colors

- [ ] Create `lib/src/theme/app_theme_extensions.dart` file
- [ ] Define `AppColorExtension` with custom semantic colors:
  - `chartLine` - for chart line color (currently Colors.blue.shade700)
  - `chartDot` - for chart touch indicator dot
  - `positive` - for positive rate changes (currently Colors.green)
  - `negative` - for negative rate changes (currently Colors.red)
- [ ] Create extension getter on ThemeData: `extension AppThemeExtensions on ThemeData`
- [ ] Document all custom theme colors with usage comments
- [ ] Run flutter analyze to verify no compilation errors

### Phase 2: Create Theme Extensions for Text Styles

- [ ] Add `AppTextStyleExtension` to `app_theme_extensions.dart`
- [ ] Define `flagEmojiStyle` (fontSize: 24) for currency flag emojis
- [ ] Define `conversionAmountStyle` (w600 weight with tabular figures)
- [ ] Define `exchangeRateHeaderStyle` (bold with tabular figures)
- [ ] Create extension getter on TextTheme: `extension AppTextThemeExtensions on TextTheme`
- [ ] Run flutter analyze to verify no compilation errors

### Phase 3: Create Reusable Theme-Based Widgets

- [ ] Create `lib/src/common_widgets/error_state_widget.dart` to replace duplicated error UI
- [ ] Create `lib/src/common_widgets/drag_handle_widget.dart` with consistent styling
- [ ] Create `lib/src/common_widgets/currency_flag_text.dart` with themed flag emoji style
- [ ] Ensure all widgets use theme properties exclusively (no hardcoded colors)
- [ ] Run flutter analyze to verify no compilation errors
- [ ] Test widgets in isolation if possible

### Phase 4: Configure Theme in main.dart

- [ ] Import app_theme_extensions.dart in main.dart
- [ ] Create custom ColorScheme with semantic colors (positive, negative, etc.)
- [ ] Add AppColorExtension to ThemeData.extensions
- [ ] Add AppTextStyleExtension to ThemeData.extensions
- [ ] Verify all theme extensions are properly registered
- [ ] Run flutter analyze to verify no compilation errors
- [ ] Test that theme extensions are accessible

### Phase 5: Migrate Convert Screen Widgets

- [ ] Update `base_currency_widget.dart`:
  - Replace `Colors.white` with `colorScheme.surface`
- [ ] Update `currency_conversion_tile.dart`:
  - Replace `Colors.red` with `colorScheme.error`
  - Replace `Colors.white` with `colorScheme.surface`
  - Replace `FontWeight.w600` with theme text style
- [ ] Update `exchange_rates_error.dart`:
  - Replace with `ErrorStateWidget`
  - Use `colorScheme.error` for icon
- [ ] Update `adaptive_currency_picker.dart`:
  - Replace `Colors.red` with `colorScheme.error`
  - Replace with `ErrorStateWidget` for error state
  - Replace with `DragHandleWidget`
  - Replace flag fontSize with theme style
- [ ] Update `amount_input_field.dart`:
  - Review for any hardcoded colors (currently looks clean)
- [ ] Update `last_updated_widget.dart`:
  - Review for theme compliance
- [ ] Update `currency_section_header.dart`:
  - Review for theme compliance
- [ ] Run flutter analyze after each file
- [ ] Test convert screen thoroughly after all migrations

### Phase 6: Migrate Charts Screen Widgets

- [ ] Update `exchange_rate_header.dart`:
  - Replace `Colors.blue` with `colorScheme.primary`
  - Replace `Colors.green` with custom `positive` color
  - Replace `Colors.red` with custom `negative` color
  - Replace `FontWeight.bold` with theme text style
- [ ] Update `exchange_rate_chart.dart`:
  - Replace `Colors.blue.shade700` with custom `chartLine` color
  - Update touch indicator dot color with custom `chartDot` color
- [ ] Update `time_range_selector.dart`:
  - Replace `Colors.blue` with `colorScheme.primary`
  - Replace `Colors.white` with `colorScheme.onPrimary`
- [ ] Run flutter analyze to verify no compilation errors
- [ ] Test charts screen with different time ranges and touch interactions

### Phase 7: Migrate Selector Screen Widgets

- [ ] Update `currency_selector.dart`:
  - Review for theme compliance (currently looks clean)
- [ ] Update `currency_picker_content.dart`:
  - Replace `Colors.red` with `colorScheme.error`
  - Replace with `ErrorStateWidget` for error state
  - Replace flag fontSize with theme style
- [ ] Update `adaptive_currency_picker.dart` (selector version):
  - Replace with `DragHandleWidget`
- [ ] Run flutter analyze to verify no compilation errors
- [ ] Test currency selector functionality

### Phase 8: Final Verification and Documentation

- [ ] Run flutter test to ensure all tests pass
- [ ] Manual testing of all screens (convert, charts, selector)
- [ ] Search for remaining hardcoded colors in lib/src: `Colors\.(white|red|blue|green|grey)`
- [ ] Search for remaining hardcoded font sizes: `fontSize:\s*[0-9]`
- [ ] Search for remaining hardcoded font weights: `FontWeight\.(w[0-9]+|bold)`
- [ ] Update CLAUDE.md with theming guidelines for future development
- [ ] Document theme extension usage with examples

## Implementation Notes

### Key Considerations

- **Theme-only focus**: Only addressing colors and text styles, not modifying app_sizes.dart
- **Material Design 3**: Use ColorScheme as foundation, extend with custom semantic colors
- **Type safety**: Use theme extensions pattern for compile-time safety
- **Widget reusability**: Extract duplicated UI patterns into themed widgets
- **No behavioral changes**: All changes are visual refinements only

### Migration Strategy

1. **Foundation first**: Create theme extensions before migrating widgets
2. **Incremental migration**: Complete one phase at a time
3. **Test after each phase**: Run flutter analyze and manual testing
4. **Pattern replacement**: Use themed equivalents systematically
5. **Preserve good patterns**: Many widgets already use Theme.of(context) correctly

### Theme Extension Pattern

```dart
// app_theme_extensions.dart
class AppColorExtension extends ThemeExtension<AppColorExtension> {
  const AppColorExtension({
    required this.positive,
    required this.negative,
    required this.chartLine,
    required this.chartDot,
  });

  final Color positive;
  final Color negative;
  final Color chartLine;
  final Color chartDot;

  @override
  ThemeExtension<AppColorExtension> copyWith({...}) { ... }

  @override
  ThemeExtension<AppColorExtension> lerp(...) { ... }
}

extension AppThemeExtensions on ThemeData {
  AppColorExtension get appColors =>
    extension<AppColorExtension>()!;
}
```

### Common Replacements Reference

```dart
// Colors
Colors.white → Theme.of(context).colorScheme.surface
Colors.red → Theme.of(context).colorScheme.error
Colors.blue → Theme.of(context).colorScheme.primary
Colors.blue.shade700 → Theme.of(context).appColors.chartLine
Colors.green → Theme.of(context).appColors.positive
Colors.grey → Theme.of(context).dividerColor

// Text Styles
const TextStyle(fontSize: 24) → Theme.of(context).textTheme.flagEmojiStyle
FontWeight.w600 → Theme.of(context).textTheme.conversionAmountStyle
FontWeight.bold + titleLarge → Theme.of(context).textTheme.exchangeRateHeaderStyle

// Widgets
Error icon + text pattern → ErrorStateWidget(message: '...')
Drag handle Container → DragHandleWidget()
Flag emoji Text → CurrencyFlagText(flag: currency.flag)
```

### Possible Future Enhancements (Out of Scope)

- Dark mode theme with complete color palette
- Theme persistence and user theme selection
- Accessibility theme variants (high contrast)
- Platform-specific color variations
- Animated theme switching
