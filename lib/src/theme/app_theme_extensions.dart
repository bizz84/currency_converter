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
      conversionAmountStyle:
          conversionAmountStyle ?? this.conversionAmountStyle,
      exchangeRateHeaderStyle:
          exchangeRateHeaderStyle ?? this.exchangeRateHeaderStyle,
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
      conversionAmountStyle: TextStyle.lerp(
          conversionAmountStyle, other.conversionAmountStyle, t)!,
      exchangeRateHeaderStyle: TextStyle.lerp(
          exchangeRateHeaderStyle, other.exchangeRateHeaderStyle, t)!,
    );
  }
}

/// Extension to access custom theme extensions easily
extension AppThemeExtensions on ThemeData {
  AppColorExtension get appColors => extension<AppColorExtension>()!;
  AppTextStyleExtension get appTextStyles => extension<AppTextStyleExtension>()!;
}
