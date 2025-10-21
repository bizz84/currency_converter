# Chart UI Tweaks

## Overview

This document compares the reference design (`ai_specs/img/012-chart-reference.jpeg`) with the current simulator implementation (`ai_specs/img/012-chart-simulator.png`) to identify UI differences.

## Screenshots

- **Reference**: `ai_specs/img/012-chart-reference.jpeg`
- **Simulator**: `ai_specs/img/012-chart-simulator.png`

## UI Differences

1. **Profile icon**: Reference has profile icon in top-left, simulator doesn't

2. **Currency selector style**: Reference has compact dropdowns with circular flags, simulator has larger pill-shaped buttons with rectangular flags

3. **Exchange rate value**: Reference shows "1.152181", simulator shows "1.150600"

4. **Status indicator**: Reference has green dot, simulator has red dot

5. **Change values**: Reference shows "-0.0013 (-0.111%)", simulator shows "-0.0047 (-0.41%)"

6. **Share button**: Reference has share icon in top-right, simulator doesn't

7. **Time range options**: Reference has 7 options (1D, 1W, 1M, 3M, 1Y, 5Y, 10Y), simulator has 6 options (missing 1D)

8. **Time range button style**: Reference has blue pill for selected 3M, simulator has light blue background

9. **Chart size**: Reference has smaller chart, simulator has much larger chart taking more vertical space

10. **Y-axis labels**: Reference shows 3 labels (1.161, 1.152, 1.143), simulator shows 2 labels (1.1614, 1.1431)

11. **Create alert button**: Reference has it below chart, simulator doesn't

12. **Stats section**: Reference has "Stats" section with high value, simulator doesn't

13. **Bottom navigation**: Reference has 5 tabs (Home, Convert, Send, Charts, More), simulator has 2 tabs (Convert, Charts)

## Implemented Tweaks

The following items have been implemented (see `011-chart-ui-tweaks-plan.md` for details):

- [x] Conversion text should be bold and use slightly smaller font like in reference image
- [x] Status indicator should show two concentric circles like in the reference image
- [x] Reduce the spacing between chips so they all fit horizontally
- [x] Match the background and foreground color for the selected pill in the reference image
- [x] The chart lines should match the dark color in the reference image

## Notes

- Items 3, 5, 7, 9, 10, 11, 12, 13 are architectural/data differences not addressed in this tweak
- Items 1, 2, 6 are feature differences outside the scope of chart UI tweaks
- Items 4, 8 are addressed by the implemented status indicator and chip styling changes
