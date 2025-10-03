import '/src/constants/app_sizes.dart';
import '/src/screens/charts/chart_data_provider.dart';
import '/src/screens/charts/charts_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExchangeRateHeader extends ConsumerWidget {
  const ExchangeRateHeader({super.key});

  String _formatRate(double rate) {
    return rate.toStringAsFixed(6);
  }

  String _formatChange(double change, double percentChange) {
    final sign = change >= 0 ? '+' : '';
    return '$sign${change.toStringAsFixed(4)} ($sign${percentChange.toStringAsFixed(2)}%)';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chartsState = ref.watch(chartsControllerProvider);
    final chartDataAsync = ref.watch(chartDataProvider);

    return chartDataAsync.when(
      data: (dataPoints) {
        if (dataPoints.isEmpty) {
          return const SizedBox.shrink();
        }

        // Use selected point if available, otherwise use the latest point
        final displayPoint =
            chartsState.selectedPoint ?? dataPoints.last;
        final firstPoint = dataPoints.first;

        // Calculate change from first to selected/latest point
        final change = displayPoint.rate - firstPoint.rate;
        final percentChange = (change / firstPoint.rate) * 100;

        final isPositive = change >= 0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '1 ${chartsState.baseCurrency.name} = ${_formatRate(displayPoint.rate)} ${chartsState.targetCurrency.name}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                gapW8,
                Container(
                  width: Sizes.p8,
                  height: Sizes.p8,
                  decoration: BoxDecoration(
                    color: isPositive ? Colors.green : Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            gapH4,
            Text(
              '${_formatChange(change, percentChange)} ${chartsState.timeRange.description}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isPositive ? Colors.green : Colors.red,
                  ),
            ),
          ],
        );
      },
      loading: () => const SizedBox(
        height: Sizes.p64,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => SizedBox(
        height: Sizes.p64,
        child: Text(
          'Error loading exchange rate',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.red,
              ),
        ),
      ),
    );
  }
}
