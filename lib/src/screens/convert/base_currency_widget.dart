import '/src/constants/app_sizes.dart';
import '/src/data/currency.dart';
import '/src/screens/convert/amount_input_field.dart';
import '/src/screens/selector/currency_selector.dart';
import 'package:flutter/material.dart';

class BaseCurrencyWidget extends StatelessWidget {
  final Currency currency;
  final double amount;
  final VoidCallback onCurrencyTap;
  final ValueChanged<double> onAmountChanged;

  const BaseCurrencyWidget({
    super.key,
    required this.currency,
    required this.amount,
    required this.onCurrencyTap,
    required this.onAmountChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Currency selector
            CurrencySelector(currency: currency, onTap: onCurrencyTap),
            gapW16,
            // Amount input
            Expanded(
              child: AmountInputField(
                initialAmount: amount,
                onChanged: onAmountChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
