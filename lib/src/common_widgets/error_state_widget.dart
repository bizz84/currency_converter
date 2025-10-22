import '/src/constants/app_sizes.dart';
import 'package:flutter/material.dart';

/// Reusable error state widget with themed icon and message
class ErrorStateWidget extends StatelessWidget {
  const ErrorStateWidget({
    super.key,
    required this.message,
    this.padding = const EdgeInsets.all(Sizes.p32),
  });

  final String message;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: Sizes.p48,
              color: Theme.of(context).colorScheme.error,
            ),
            gapH8,
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
