import 'package:currency_converter/src/constants/app_sizes.dart';
import 'package:currency_converter/src/data/currency.dart';
import 'package:currency_converter/src/network/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExchangeRatesError extends ConsumerWidget {
  const ExchangeRatesError({
    super.key,
    required this.baseCurrency,
    required this.error,
  });
  final Currency baseCurrency;
  final Object error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red,
            ),
            gapH16,
            Text(
              'Failed to load exchange rates',
              style: Theme.of(
                context,
              ).textTheme.titleMedium,
            ),
            gapH8,
            Text(
              error.toString(),
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            gapH16,
            ElevatedButton(
              onPressed: () {
                ref.invalidate(
                  latestRatesProvider(baseCurrency),
                );
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
