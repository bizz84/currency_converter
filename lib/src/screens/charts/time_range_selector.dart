import '/src/constants/app_sizes.dart';
import '/src/data/chart_time_range.dart';
import '/src/screens/charts/charts_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimeRangeSelector extends ConsumerWidget {
  const TimeRangeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRange = ref.watch(chartsControllerProvider).timeRange;

    // TODO: Add 1D back when API supports intraday data
    final availableRanges = ChartTimeRange.values
        .where((range) => range != ChartTimeRange.oneDay)
        .toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: availableRanges.map((range) {
          final isSelected = range == selectedRange;
          return Padding(
            padding: const EdgeInsets.only(right: Sizes.p8),
            child: ChoiceChip(
              label: Text(range.label),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  ref
                      .read(chartsControllerProvider.notifier)
                      .setTimeRange(range);
                }
              },
              showCheckmark: false,
              shape: const StadiumBorder(),
            ),
          );
        }).toList(),
      ),
    );
  }
}
