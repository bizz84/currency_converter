# Chart UI Tweaks Plan

## Overview

Refine the exchange rate chart UI to match the reference design by adjusting text styles, status indicator, chip spacing, button colors, and chart line colors.

## Implementation

### Phase 1: Text and Typography Adjustments

- [x] Make conversion rate text bold (e.g., "1 GBP = 1.150600 EUR")
- [x] Reduce font size of conversion rate text to match reference
- [x] Verify text changes render correctly on device

### Phase 2: Status Indicator Design

- [x] Update status indicator to show two concentric circles
- [x] Match the circle sizes and spacing from reference image
- [x] Ensure indicator color reflects rate status (green/red)
- [x] Test indicator appearance with both positive and negative changes

### Phase 3: Time Range Chip Spacing

- [x] Reduce horizontal spacing between time range chips
- [x] Ensure all chips (1W, 1M, 3M, 1Y, 5Y, 10Y) fit horizontally without wrapping
- [x] Maintain touch target sizes for accessibility
- [x] Test on various screen sizes

### Phase 4: Selected Chip Styling

- [x] Update selected chip background color to match reference (solid blue)
- [x] Update selected chip foreground color to white
- [x] Ensure unselected chips remain with current styling
- [x] Verify selection state changes are visually clear

### Phase 5: Chart Line Color

- [x] Change chart line color to dark blue matching reference
- [x] Update any chart theming or gradient if applicable
- [x] Verify chart remains readable with new color
- [x] Test chart appearance across different time ranges

## Implementation Notes

- Use theme colors where possible for consistency
- All changes should be visual only - no behavioral changes
- Test on both light and dark modes if applicable
- Verify that constant sizes from `app_sizes.dart` are used for spacing
- Each phase can be tested independently by running the app
- Manual verification recommended by comparing side-by-side with reference image
