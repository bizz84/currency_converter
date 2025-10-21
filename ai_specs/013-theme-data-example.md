# Comprehensive ThemeData Example (Using ColorScheme.fromSeed)

## Current ThemeData (main.dart:60-66)

```dart
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.light,
  ),
  useMaterial3: true,
),
```

## Proposed Approach: Create Theme in Separate File

### Step 1: Create `lib/src/theme/app_theme.dart`

```dart
import 'package:flutter/material.dart';

class AppTheme {
  // ============================================================
  // CHANGE THESE TO REBRAND THE ENTIRE APP
  // ============================================================

  /// Primary brand color - change this to update entire color scheme
  static const seedColor = Color(0xFF1976D2);  // Blue (default)
  // Examples of other colors:
  // static const seedColor = Color(0xFF0D47A1);  // Darker blue
  // static const seedColor = Color(0xFF6A1B9A);  // Purple
  // static const seedColor = Color(0xFFD32F2F);  // Red

  /// Positive state color (e.g., rate increases)
  static const positiveColor = Color(0xFF388E3C);  // Green

  /// Negative state color (e.g., rate decreases)
  static const negativeColor = Color(0xFFD32F2F);  // Red

  // ============================================================
  // THEME CONFIGURATION
  // ============================================================

  static ThemeData lightTheme() {
    // Generate full color scheme from seed color
    // Material Design automatically creates harmonious shades
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
    );

    // Override specific colors if needed
    final customColorScheme = colorScheme.copyWith(
      // Use green for secondary (positive states)
      secondary: positiveColor,
      // Use red for errors (negative states)
      error: negativeColor,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: customColorScheme,

      // Divider theme
      dividerColor: colorScheme.outlineVariant,
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),

      // Text theme - define text styles used throughout app
      textTheme: const TextTheme(
        // Title styles
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: 0,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),

        // Body styles
        bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),

        // Label styles
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
      ),

      // ChoiceChip theme (used in time range selector)
      chipTheme: ChipThemeData(
        backgroundColor: Colors.transparent,
        selectedColor: colorScheme.primary,  // Uses primary from seed
        disabledColor: colorScheme.surfaceContainerHighest,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        labelStyle: const TextStyle(fontSize: 14),
        secondaryLabelStyle: const TextStyle(fontSize: 14, color: Colors.white),
        shape: const StadiumBorder(),
        side: BorderSide(color: colorScheme.outline),
        checkmarkColor: colorScheme.onPrimary,
      ),

      // Input decoration theme (TextFields)
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),

      // Icon theme
      iconTheme: IconThemeData(
        color: colorScheme.onSurface,
        size: 24,
      ),

      // AppBar theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),

      // Card theme
      cardTheme: CardTheme(
        elevation: 1,
        color: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(8),
      ),

      // Custom theme extensions for app-specific values
      extensions: <ThemeExtension<dynamic>>[
        AppColorExtension(
          // Chart colors - use primary color from seed
          chartLine: colorScheme.primary,
          chartDot: colorScheme.primary,

          // Semantic colors for rate changes
          positive: positiveColor,
          negative: negativeColor,

          // Light variants for status indicators (semi-transparent)
          positiveLight: positiveColor.withOpacity(0.15),
          negativeLight: negativeColor.withOpacity(0.15),
        ),

        AppTextStyleExtension(
          // Currency flag emoji style
          flagEmojiStyle: const TextStyle(fontSize: 24),

          // Conversion amount with tabular figures for alignment
          conversionAmountStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFeatures: [FontFeature.tabularFigures()],
          ),

          // Exchange rate header with tabular figures
          exchangeRateHeaderStyle: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }

  // Future: Add dark theme
  // static ThemeData darkTheme() { ... }
}
```

### Step 2: Create Theme Extensions

Create `lib/src/theme/app_theme_extensions.dart`:

```dart
import 'package:flutter/material.dart';

/// Custom color extension for app-specific semantic colors
class AppColorExtension extends ThemeExtension<AppColorExtension> {
  const AppColorExtension({
    required this.chartLine,
    required this.chartDot,
    required this.positive,
    required this.negative,
    required this.positiveLight,
    required this.negativeLight,
  });

  /// Chart line color
  final Color chartLine;

  /// Chart touch indicator dot color
  final Color chartDot;

  /// Positive rate change color (e.g., green)
  final Color positive;

  /// Negative rate change color (e.g., red)
  final Color negative;

  /// Light variant for positive status indicator
  final Color positiveLight;

  /// Light variant for negative status indicator
  final Color negativeLight;

  @override
  ThemeExtension<AppColorExtension> copyWith({
    Color? chartLine,
    Color? chartDot,
    Color? positive,
    Color? negative,
    Color? positiveLight,
    Color? negativeLight,
  }) {
    return AppColorExtension(
      chartLine: chartLine ?? this.chartLine,
      chartDot: chartDot ?? this.chartDot,
      positive: positive ?? this.positive,
      negative: negative ?? this.negative,
      positiveLight: positiveLight ?? this.positiveLight,
      negativeLight: negativeLight ?? this.negativeLight,
    );
  }

  @override
  ThemeExtension<AppColorExtension> lerp(
    ThemeExtension<AppColorExtension>? other,
    double t,
  ) {
    if (other is! AppColorExtension) {
      return this;
    }
    return AppColorExtension(
      chartLine: Color.lerp(chartLine, other.chartLine, t)!,
      chartDot: Color.lerp(chartDot, other.chartDot, t)!,
      positive: Color.lerp(positive, other.positive, t)!,
      negative: Color.lerp(negative, other.negative, t)!,
      positiveLight: Color.lerp(positiveLight, other.positiveLight, t)!,
      negativeLight: Color.lerp(negativeLight, other.negativeLight, t)!,
    );
  }
}

/// Custom text style extension for app-specific text styles
class AppTextStyleExtension extends ThemeExtension<AppTextStyleExtension> {
  const AppTextStyleExtension({
    required this.flagEmojiStyle,
    required this.conversionAmountStyle,
    required this.exchangeRateHeaderStyle,
  });

  /// Text style for currency flag emojis
  final TextStyle flagEmojiStyle;

  /// Text style for conversion amounts (with tabular figures)
  final TextStyle conversionAmountStyle;

  /// Text style for exchange rate header (with tabular figures)
  final TextStyle exchangeRateHeaderStyle;

  @override
  ThemeExtension<AppTextStyleExtension> copyWith({
    TextStyle? flagEmojiStyle,
    TextStyle? conversionAmountStyle,
    TextStyle? exchangeRateHeaderStyle,
  }) {
    return AppTextStyleExtension(
      flagEmojiStyle: flagEmojiStyle ?? this.flagEmojiStyle,
      conversionAmountStyle: conversionAmountStyle ?? this.conversionAmountStyle,
      exchangeRateHeaderStyle: exchangeRateHeaderStyle ?? this.exchangeRateHeaderStyle,
    );
  }

  @override
  ThemeExtension<AppTextStyleExtension> lerp(
    ThemeExtension<AppTextStyleExtension>? other,
    double t,
  ) {
    if (other is! AppTextStyleExtension) {
      return this;
    }
    return AppTextStyleExtension(
      flagEmojiStyle: TextStyle.lerp(flagEmojiStyle, other.flagEmojiStyle, t)!,
      conversionAmountStyle: TextStyle.lerp(conversionAmountStyle, other.conversionAmountStyle, t)!,
      exchangeRateHeaderStyle: TextStyle.lerp(exchangeRateHeaderStyle, other.exchangeRateHeaderStyle, t)!,
    );
  }
}

/// Extension to access custom theme extensions easily
extension AppThemeExtensions on ThemeData {
  AppColorExtension get appColors => extension<AppColorExtension>()!;
  AppTextStyleExtension get appTextStyles => extension<AppTextStyleExtension>()!;
}
```

### Step 3: Update `lib/main.dart`

```dart
import '/src/theme/app_theme.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),  // Single line!
      // Future: darkTheme: AppTheme.darkTheme(),
      navigatorKey: _rootNavigatorKey,
      // ... rest of MaterialApp config
    );
  }
}
```

## Using the Theme in Widgets

### Standard Material Colors

```dart
// Use ColorScheme colors (automatically from seed)
Container(
  color: Theme.of(context).colorScheme.surface,  // White
  child: Text(
    'Amount',
    style: TextStyle(color: Theme.of(context).colorScheme.onSurface),  // Black
  ),
)

// Error colors
Icon(
  Icons.error_outline,
  color: Theme.of(context).colorScheme.error,  // Red
)

// Primary colors
ChoiceChip(
  selectedColor: Theme.of(context).colorScheme.primary,  // Blue from seed
  labelStyle: TextStyle(
    color: isSelected
      ? Theme.of(context).colorScheme.onPrimary  // White
      : null,
  ),
)
```

### Custom Theme Extension Colors

```dart
// Chart line color
LineChartBarData(
  color: Theme.of(context).appColors.chartLine,
)

// Positive/negative indicators
Container(
  color: isPositive
    ? Theme.of(context).appColors.positive   // Green
    : Theme.of(context).appColors.negative,  // Red
)

// Status indicator with light background
Container(
  decoration: BoxDecoration(
    border: Border.all(
      color: isPositive
        ? Theme.of(context).appColors.positiveLight
        : Theme.of(context).appColors.negativeLight,
    ),
  ),
)
```

### Custom Text Styles

```dart
// Flag emoji
Text(
  currency.flag,
  style: Theme.of(context).appTextStyles.flagEmojiStyle,
)

// Conversion amount
Text(
  '1.234567',
  style: Theme.of(context).appTextStyles.conversionAmountStyle,
)

// Exchange rate header
Text(
  '1 GBP = 1.150600 EUR',
  style: Theme.of(context).appTextStyles.exchangeRateHeaderStyle,
)
```

## What ColorScheme.fromSeed Generates

When you set `seedColor: Color(0xFF1976D2)`, Material Design automatically generates:

```dart
colorScheme.primary           // Main brand color (from seed)
colorScheme.onPrimary         // Text on primary (usually white)
colorScheme.primaryContainer  // Lighter variant of primary
colorScheme.onPrimaryContainer // Text on primary container

colorScheme.secondary         // Complementary color (auto-generated)
colorScheme.onSecondary       // Text on secondary
colorScheme.secondaryContainer
colorScheme.onSecondaryContainer

colorScheme.error             // Error color (red-ish)
colorScheme.onError           // Text on error
colorScheme.errorContainer
colorScheme.onErrorContainer

colorScheme.surface           // Background surfaces (white/light)
colorScheme.onSurface         // Text on surfaces (black/dark)
colorScheme.surfaceContainerHighest  // Slightly elevated surfaces

colorScheme.outline           // Borders, dividers
colorScheme.outlineVariant    // Lighter borders
```

All harmonious and accessible!

## Benefits of This Approach

### 1. Single Source of Truth

```dart
// Want darker blue? Just change ONE line:
static const seedColor = Color(0xFF0D47A1);  // Done!

// Want purple theme?
static const seedColor = Color(0xFF6A1B9A);  // Done!

// Everything updates automatically:
// - Chart lines
// - Selected chips
// - Focus borders
// - Touch indicators
```

### 2. Automatic Material Components

Many widgets automatically use theme without code changes:
- ✅ `ChoiceChip` uses `chipTheme.selectedColor`
- ✅ `TextField` uses `inputDecorationTheme`
- ✅ `Icon` uses `iconTheme.color`

### 3. Accessibility Built-in

Material Design ensures proper contrast ratios automatically.

### 4. Easy Dark Mode Later

```dart
static ThemeData darkTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: seedColor,  // Same seed!
    brightness: Brightness.dark,  // Just change this
  );
  // ... rest of theme config
}
```

### 5. Type-Safe Theme Access

```dart
// Compile-time checked
Theme.of(context).appColors.chartLine

// vs error-prone string keys
Theme.of(context).extension<Map>()['chartLine']  // Yuck!
```

## Migration Path

1. ✅ Create `app_theme.dart` and `app_theme_extensions.dart`
2. ✅ Update `main.dart` to use `AppTheme.lightTheme()`
3. ✅ Widgets using Material components get automatic theming
4. 🔄 Gradually migrate custom widgets to use theme colors
5. 🔄 Replace hardcoded styles with theme text styles

## Changing Colors Later

```dart
// Current: Blue theme
static const seedColor = Color(0xFF1976D2);

// Want to try: Indigo theme?
static const seedColor = Color(0xFF3F51B5);

// Or: Teal theme?
static const seedColor = Color(0xFF00897B);

// Hot reload and see the entire app update! 🎨
```

That's it! Maximum flexibility with minimal code.
