import 'package:flutter/material.dart';
import '/src/theme/app_theme_extensions.dart';

class AppTheme {
  // ============================================================
  // CHANGE THESE TO REBRAND THE ENTIRE APP
  // ============================================================

  /// Primary brand color - change this to update entire color scheme
  static const seedColor = Color(0xFF1976D2); // Blue (default)
  // Examples of other colors:
  // static const seedColor = Color(0xFF0D47A1);  // Darker blue
  // static const seedColor = Color(0xFF6A1B9A);  // Purple
  // static const seedColor = Color(0xFFD32F2F);  // Red

  /// Positive state color (e.g., rate increases)
  static const positiveColor = Color(0xFF388E3C); // Green

  /// Negative state color (e.g., rate decreases)
  static const negativeColor = Color(0xFFD32F2F); // Red

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
        selectedColor: colorScheme.primary, // Uses primary from seed
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
      cardTheme: CardThemeData(
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
          positiveLight: positiveColor.withValues(alpha: 0.15),
          negativeLight: negativeColor.withValues(alpha: 0.15),
        ),

        const AppTextStyleExtension(
          // Currency flag emoji style
          flagEmojiStyle: TextStyle(fontSize: 24),

          // Conversion amount with tabular figures for alignment
          conversionAmountStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFeatures: [FontFeature.tabularFigures()],
          ),

          // Exchange rate header with tabular figures
          exchangeRateHeaderStyle: TextStyle(
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
