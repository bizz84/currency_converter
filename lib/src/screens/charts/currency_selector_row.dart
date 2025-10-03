import '/src/constants/app_sizes.dart';
import '/src/screens/charts/charts_controller.dart';
import '/src/screens/convert/adaptive_currency_picker.dart';
import '/src/screens/selector/currency_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrencySelectorRow extends ConsumerWidget {
  const CurrencySelectorRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chartsState = ref.watch(chartsControllerProvider);

    return Row(
      children: [
        Expanded(
          child: CurrencySelector(
            currency: chartsState.baseCurrency,
            onTap: () async {
              final currency = await AdaptiveCurrencyPicker.show(
                context,
                selectedCurrency: chartsState.baseCurrency,
                inUseCurrencies: [chartsState.targetCurrency],
              );
              if (currency != null) {
                ref.read(chartsControllerProvider.notifier).setBaseCurrency(currency);
              }
            },
          ),
        ),
        gapW16,
        IconButton(
          onPressed: () {
            ref.read(chartsControllerProvider.notifier).swapCurrencies();
          },
          icon: const Icon(Icons.swap_horiz),
        ),
        gapW16,
        Expanded(
          child: CurrencySelector(
            currency: chartsState.targetCurrency,
            onTap: () async {
              final currency = await AdaptiveCurrencyPicker.show(
                context,
                selectedCurrency: chartsState.targetCurrency,
                inUseCurrencies: [chartsState.baseCurrency],
              );
              if (currency != null) {
                ref.read(chartsControllerProvider.notifier).setTargetCurrency(currency);
              }
            },
          ),
        ),
      ],
    );
  }
}
