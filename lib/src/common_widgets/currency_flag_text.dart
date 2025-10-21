import '/src/theme/app_theme_extensions.dart';
import 'package:flutter/material.dart';

/// Reusable widget for displaying currency flag emojis with consistent styling
class CurrencyFlagText extends StatelessWidget {
  const CurrencyFlagText({
    super.key,
    required this.flag,
  });

  final String flag;

  @override
  Widget build(BuildContext context) {
    return Text(
      flag,
      style: Theme.of(context).appTextStyles.flagEmojiStyle,
    );
  }
}
