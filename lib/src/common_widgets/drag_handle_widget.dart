import '/src/constants/app_sizes.dart';
import 'package:flutter/material.dart';

/// Reusable drag handle widget for bottom sheets
class DragHandleWidget extends StatelessWidget {
  const DragHandleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 4,
      margin: const .symmetric(vertical: Sizes.p12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.outline,
        borderRadius: .circular(2),
      ),
    );
  }
}
