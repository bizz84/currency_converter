import 'package:currency_converter/src/data/currency.dart';
import 'package:flutter/material.dart';

class CurrencyConversionTile extends StatelessWidget {
  final Currency currency;
  final Currency baseCurrency;
  final double amount;
  final double? rate;
  final VoidCallback? onRemove;

  const CurrencyConversionTile({
    super.key,
    required this.currency,
    required this.baseCurrency,
    required this.amount,
    this.rate,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final flag = currency.flag;
    final currencyName = currency.desc;

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
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          leading: Text(flag, style: Theme.of(context).textTheme.headlineSmall),
          title: Row(
            children: [
              Text(currency.name),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  currencyName,
                  style: Theme.of(context).textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          subtitle: rate != null
              ? Text(
                  '1 ${baseCurrency.name} = ${rate!.toStringAsFixed(4)} ${currency.name}',
                )
              : Text(
                  'Rate unavailable',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (rate != null)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      (amount * rate!).toStringAsFixed(2),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      currency.name,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                )
              else
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    '—',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              if (onRemove != null) ...[
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: onRemove,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
