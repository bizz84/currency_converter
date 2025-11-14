import '/src/constants/app_sizes.dart';
import '/src/screens/charts/chart_data_provider.dart';
import '/src/screens/charts/charts_controller.dart';
import '/src/theme/app_theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ExchangeRateHeader extends ConsumerWidget {
  const ExchangeRateHeader({super.key});

  String _formatRate(double rate) {
    return rate.toStringAsFixed(4);
  }

  String _formatChange(double change, double percentChange) {
    final sign = change >= 0 ? '+' : '';
    return '$sign${change.toStringAsFixed(4)} ($sign${percentChange.toStringAsFixed(2)}%)';
  }

  String _formatDate(DateTime date) {
    return DateFormat('d MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chartsState = ref.watch(chartsControllerProvider);
    final chartDataAsync = ref.watch(chartDataProvider);
    final selectedPoint = ref.watch(chartSelectedPointProvider);

    return chartDataAsync.when(
      data: (dataPoints) {
        if (dataPoints.isEmpty) {
          return const SizedBox.shrink();
        }

        // Use selected point if available, otherwise use the latest point
        final displayPoint = selectedPoint ?? dataPoints.last;
        final firstPoint = dataPoints.first;

        // Calculate change from first to selected/latest point
        final change = displayPoint.rate - firstPoint.rate;
        final percentChange = (change / firstPoint.rate) * 100;

        final isPositive = change >= 0;
        final isSelected = selectedPoint != null;

        return ExchangeRateHeaderContent(
          baseCurrency: chartsState.baseCurrency.name,
          targetCurrency: chartsState.targetCurrency.name,
          rate: _formatRate(displayPoint.rate),
          change: _formatChange(change, percentChange),
          timeRange: isSelected
              ? _formatDate(displayPoint.date)
              : chartsState.timeRange.description,
          isPositive: isPositive,
          isSelected: isSelected,
        );
      },
      loading: () {
        final chartsState = ref.read(chartsControllerProvider);
        return Skeletonizer(
          enabled: true,
          child: ExchangeRateHeaderContent(
            baseCurrency: chartsState.baseCurrency.name,
            targetCurrency: chartsState.targetCurrency.name,
            rate: '1.2345',
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

class ExchangeRateHeaderContent extends StatelessWidget {
  const ExchangeRateHeaderContent({
    super.key,
    required this.baseCurrency,
    required this.targetCurrency,
    required this.rate,
    required this.change,
    required this.timeRange,
    required this.isPositive,
    this.isSelected = false,
  });

  final String baseCurrency;
  final String targetCurrency;
  final String rate;
  final String change;
  final String timeRange;
  final bool isPositive;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Row(
          children: [
            Text(
              '1 $baseCurrency = $rate $targetCurrency',
              style: Theme.of(context).appTextStyles.exchangeRateHeaderStyle,
            ),
            gapW8,
            StatusIndicator(
              isSelected: isSelected,
              isPositive: isPositive,
            ),
          ],
        ),
        gapH4,
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: change,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isPositive
                      ? Theme.of(context).appColors.positive
                      : Theme.of(context).appColors.negative,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              TextSpan(
                text: ' $timeRange',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class StatusIndicator extends StatelessWidget {
  const StatusIndicator({
    super.key,
    required this.isSelected,
    required this.isPositive,
  });

  final bool isSelected;
  final bool isPositive;

  @override
  Widget build(BuildContext context) {
    final color = isSelected
        ? Theme.of(context).colorScheme.primary
        : (isPositive
              ? Theme.of(context).appColors.positive
              : Theme.of(context).appColors.negative);

    return Stack(
      alignment: .center,
      children: [
        // Outer circle (semi-transparent)
        Container(
          width: Sizes.p16,
          height: Sizes.p16,
          decoration: BoxDecoration(
            shape: .circle,
            border: Border.all(
              color: color.withValues(alpha: 0.15),
              width: Sizes.p4,
            ),
          ),
        ),
        // Inner circle
        Container(
          width: Sizes.p8,
          height: Sizes.p8,
          decoration: BoxDecoration(
            color: color,
            shape: .circle,
          ),
        ),
      ],
    );
  }
}
