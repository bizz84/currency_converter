import '/src/common_widgets/currency_flag_text.dart';
import '/src/constants/app_sizes.dart';
import '/src/data/currency.dart';
import 'package:flutter/material.dart';

class CurrencySelector extends StatelessWidget {
  final Currency currency;
  final VoidCallback onTap;

  const CurrencySelector({
    super.key,
    required this.currency,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            CurrencyFlagText(flag: currency.flag),
            gapW8,
            Text(
              currency.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
