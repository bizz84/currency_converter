import 'package:currency_converter/src/data/currency.dart';
import 'package:flutter/material.dart';

class CurrencyConversionTile extends StatelessWidget {
  final Currency currency;
  final Currency baseCurrency;
  final double amount;
  final double? rate;
  final VoidCallback? onRemove;
  final int index;

  const CurrencyConversionTile({
    super.key,
    required this.currency,
    required this.baseCurrency,
    required this.amount,
    required this.index,
    this.rate,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(currency.name),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onRemove?.call(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Container(
        color: Colors.white,
        margin: const EdgeInsets.only(bottom: 1),
        child: Material(
          color: Colors.transparent,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            leading: Text(
              currency.flag,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            title: Text(
              currency.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (rate != null) ...[
                      Text(
                        '${currency.symbol} ${(amount * rate!).toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '1 ${baseCurrency.name} = ${rate!.toStringAsFixed(4)} ${currency.name}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ] else
                      Text(
                        '—',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                ReorderableDragStartListener(
                  index: index,
                  child: const Icon(
                    Icons.drag_handle,
                    color: Colors.black38,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
