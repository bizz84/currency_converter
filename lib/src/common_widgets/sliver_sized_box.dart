import 'package:flutter/material.dart';

class SliverSizedBox extends StatelessWidget {
  const SliverSizedBox({
    super.key,
    this.width,
    this.height,
    this.child,
  });

  const SliverSizedBox.square({
    super.key,
    double? dimension,
    this.child,
  }) : width = dimension,
       height = dimension;

  const SliverSizedBox.shrink({super.key})
    : width = 0.0,
      height = 0.0,
      child = null;

  final double? width;
  final double? height;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        width: width,
        height: height,
        child: child,
      ),
    );
  }
}
