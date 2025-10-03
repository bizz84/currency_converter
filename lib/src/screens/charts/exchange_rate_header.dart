import '/src/constants/app_sizes.dart';
import '/src/screens/charts/chart_data_provider.dart';
import '/src/screens/charts/charts_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ExchangeRateHeaderContent extends StatelessWidget {
  const ExchangeRateHeaderContent({
    super.key,
    required this.baseCurrency,
    required this.targetCurrency,
    required this.rate,
    required this.change,
    required this.timeRange,
    required this.isPositive,
  });

  final String baseCurrency;
  final String targetCurrency;
  final String rate;
  final String change;
  final String timeRange;
  final bool isPositive;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '1 $baseCurrency = $rate $targetCurrency',
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
          '$change $timeRange',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isPositive ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }
}

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
        final displayPoint = chartsState.selectedPoint ?? dataPoints.last;
        final firstPoint = dataPoints.first;

        // Calculate change from first to selected/latest point
        final change = displayPoint.rate - firstPoint.rate;
        final percentChange = (change / firstPoint.rate) * 100;

        final isPositive = change >= 0;

        return ExchangeRateHeaderContent(
          baseCurrency: chartsState.baseCurrency.name,
          targetCurrency: chartsState.targetCurrency.name,
          rate: _formatRate(displayPoint.rate),
          change: _formatChange(change, percentChange),
          timeRange: chartsState.timeRange.description,
          isPositive: isPositive,
        );
      },
      loading: () {
        final chartsState = ref.read(chartsControllerProvider);
        return Skeletonizer(
          enabled: true,
          child: ExchangeRateHeaderContent(
            baseCurrency: chartsState.baseCurrency.name,
            targetCurrency: chartsState.targetCurrency.name,
            rate: '1.234567',
            change: '+0.1234 (+1.23%)',
            timeRange: chartsState.timeRange.description,
            isPositive: true,
          ),
        );
      },
      error: (error, stack) => ExchangeRateHeaderContent(
        baseCurrency: chartsState.baseCurrency.name,
        targetCurrency: chartsState.targetCurrency.name,
        rate: 'Unknown',
        change: 'Error loading exchange rate',
        timeRange: '',
        isPositive: false,
      ),
    );
  }
}
