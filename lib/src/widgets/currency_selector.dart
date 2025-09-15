import 'package:flutter/material.dart';
import '../data/currency.dart';

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
            Text(
              currency.flag,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(width: 8),
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
