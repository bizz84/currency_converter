import '/src/constants/layout_breakpoints.dart';
import 'package:flutter/material.dart';

class ResponsiveConstrainedBox extends StatelessWidget {
  const ResponsiveConstrainedBox({
    super.key,
    this.maxContentWidth = LayoutBreakpoints.maxWidth,
    this.padding = EdgeInsets.zero,
    required this.child,
  });
  final double maxContentWidth;
  final EdgeInsetsGeometry padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxContentWidth),
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

class ResponsiveCenteredColumn extends StatelessWidget {
  const ResponsiveCenteredColumn({
    super.key,
    this.maxWidth = LayoutBreakpoints.maxWidth,
    required this.child,
  });
  final double maxWidth;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            width: maxWidth,
            child: child,
          ),
        ],
      ),
    );
  }
}
