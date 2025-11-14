# Formatting Tweaks Implementation Plan

## Overview

This plan addresses three formatting improvements in the currency converter app: changing the default amount from 100.00 to 1.00, adding visible currency symbols in the amount input field (e.g., `£ 1.00`) while keeping editing numeric-only, and reducing the charts screen decimal precision from 6 to 4 decimals.

## Implementation

### Phase 1: Update Default Amount ✅
- [x] Change default amount from 100.0 to 1.0 in `lib/src/storage/user_prefs_notifier.dart`
- [x] Run `flutter analyze` to check for any code issues
- [x] Verify the app compiles and runs
- [x] Test that new users see 1.00 as the default amount on fresh app start
- [x] Test that existing conversions still work correctly with the new default
- [x] Test that the 1.00 value displays properly in the input field

### Phase 2: Add Currency Symbol to Amount Input Field ✅
- [x] Analyze current `AmountInputField` implementation in `lib/src/screens/convert/amount_input_field.dart`
- [x] Add currency symbol parameter to the widget
- [x] Implement prefix/decoration to show currency symbol (e.g., `£ `) before the numeric input
- [x] Ensure the text input controller only handles numeric values (no symbol editing)
- [x] Update the parent widget to pass the base currency symbol to `AmountInputField`
- [x] Run `flutter analyze` to check for any code issues
- [x] Verify the app compiles and runs
- [x] Test that currency symbol is always visible in the input field (e.g., `£ 1.00`)
- [x] Test that editing only affects the numeric portion
- [x] Test that changing base currency updates the symbol correctly
- [x] Test edge cases: deleting all text, pasting values, clearing input
- [x] Test that conversions still calculate correctly with the symbol present

### Phase 3: Reduce Chart Decimal Precision ✅
- [x] Update `_formatRate` method in `lib/src/screens/charts/exchange_rate_header.dart` from `toStringAsFixed(6)` to `toStringAsFixed(4)`
- [x] Run `flutter analyze` to check for any code issues
- [x] Verify the app compiles and runs
- [x] Test that exchange rates display with 4 decimals (e.g., `1 GBP = 1.1339 EUR`)
- [x] Test with various currency pairs (high and low value rates) to ensure formatting looks correct
- [x] Test different time ranges to verify formatting is consistent
- [x] Verify that chart functionality and tap/hold interactions still work correctly
- [x] Test that rate changes still display properly with the reduced precision

### Phase 4: Final Integration Testing
- [ ] Run `flutter test` to ensure all existing tests pass
- [ ] Manually test all three changes together in the app
- [ ] Test complete user flow: launch app → verify default 1.00 → check symbol in input → switch currencies → navigate to charts → verify 4 decimal display
- [ ] Test both converter and charts screens thoroughly
- [ ] Verify no regressions in existing functionality (drag & drop, time range selection, etc.)
- [ ] Test on different screen sizes if possible

## Implementation Notes

**Key Considerations:**
- The currency symbol in the input field should be non-editable and always visible, acting as a visual prefix to help users understand which currency they're entering
- The input controller should continue to only handle numeric values to avoid parsing complexity
- Consider using `InputDecoration.prefixText` or a custom `InputDecoration.prefix` widget for the currency symbol
- Existing user preferences will not be affected by the default amount change (only new installations or reset preferences)
- The decimal precision change is purely cosmetic and doesn't affect calculation accuracy

**Migration Strategy:**
- No migration needed - these are UI-only changes that don't affect data structures or storage
- Existing users will retain their current amount values; only the default for new users changes

**Edge Cases to Consider:**
- Currency symbol should update immediately when base currency changes
- Input field focus/blur behavior with the currency symbol prefix
- Right-to-left language support (if applicable)
- Very small or very large exchange rates with 4 decimal precision

**Future Enhancements (Out of Scope):**
- Allow users to customize decimal precision in settings
- Support for different number formatting conventions (comma vs period as decimal separator)
- Dynamic decimal precision based on exchange rate magnitude
- Localized currency symbol positioning (before/after amount based on locale)
