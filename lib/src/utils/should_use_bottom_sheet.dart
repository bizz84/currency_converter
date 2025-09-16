import 'package:currency_converter/src/constants/layout_breakpoints.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

bool shouldUseBottomSheet(BuildContext context) {
  final platform = Theme.of(context).platform;

  // Desktop platforms: Always use dialog
  if (platform == TargetPlatform.macOS ||
      platform == TargetPlatform.windows ||
      platform == TargetPlatform.linux) {
    return false;
  }

  // Web: Check if mobile or desktop based on viewport
  if (kIsWeb) {
    // Use shortestSide to better detect tablets in portrait
    final shortestSide = MediaQuery.sizeOf(context).shortestSide;
    // Mobile web if shortest side < 768 (includes tablets)
    return shortestSide < 768;
  }

  // iOS and Android: Use adaptive approach based on screen width
  final screenWidth = MediaQuery.sizeOf(context).width;
  return screenWidth < LayoutBreakpoints.medium;
}
