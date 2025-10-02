import '/src/constants/app_sizes.dart';
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

/// Constant sliver gap widths
const sliverGapW4 = SliverSizedBox(width: Sizes.p4);
const sliverGapW8 = SliverSizedBox(width: Sizes.p8);
const sliverGapW12 = SliverSizedBox(width: Sizes.p12);
const sliverGapW16 = SliverSizedBox(width: Sizes.p16);
const sliverGapW20 = SliverSizedBox(width: Sizes.p20);
const sliverGapW24 = SliverSizedBox(width: Sizes.p24);
const sliverGapW32 = SliverSizedBox(width: Sizes.p32);
const sliverGapW40 = SliverSizedBox(width: Sizes.p40);
const sliverGapW48 = SliverSizedBox(width: Sizes.p48);
const sliverGapW64 = SliverSizedBox(width: Sizes.p64);
const sliverGapW80 = SliverSizedBox(width: Sizes.p80);

/// Constant sliver gap heights
const sliverGapH4 = SliverSizedBox(height: Sizes.p4);
const sliverGapH8 = SliverSizedBox(height: Sizes.p8);
const sliverGapH12 = SliverSizedBox(height: Sizes.p12);
const sliverGapH16 = SliverSizedBox(height: Sizes.p16);
const sliverGapH20 = SliverSizedBox(height: Sizes.p20);
const sliverGapH24 = SliverSizedBox(height: Sizes.p24);
const sliverGapH32 = SliverSizedBox(height: Sizes.p32);
const sliverGapH40 = SliverSizedBox(height: Sizes.p40);
const sliverGapH48 = SliverSizedBox(height: Sizes.p48);
const sliverGapH64 = SliverSizedBox(height: Sizes.p64);
const sliverGapH80 = SliverSizedBox(height: Sizes.p80);
