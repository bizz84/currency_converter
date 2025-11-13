import '/src/constants/app_sizes.dart';
import '/src/data/currency.dart';
import '/src/theme/app_theme_extensions.dart';
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
      direction: .endToStart,
      onDismissed: (_) => onRemove?.call(),
      background: Container(
        alignment: .centerRight,
        padding: const .only(right: Sizes.p16),
        color: Theme.of(context).colorScheme.error,
        child: Icon(Icons.delete, color: Theme.of(context).colorScheme.onError),
      ),
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        margin: const .only(bottom: 1),
        child: Material(
          color: Colors.transparent,
          child: ListTile(
            contentPadding: const .symmetric(
              horizontal: Sizes.p16,
              vertical: Sizes.p12,
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
              mainAxisSize: .min,
              children: [
                Column(
                  mainAxisAlignment: .center,
                  crossAxisAlignment: .end,
                  children: [
                    if (rate != null) ...[
                      Text(
                        '${currency.symbol} ${(amount * rate!).toStringAsFixed(2)}',
                        style: Theme.of(
                          context,
                        ).appTextStyles.conversionAmountStyle,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '1 ${baseCurrency.name} = ${rate!.toStringAsFixed(4)} ${currency.name}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ] else
                      Text(
                        '—',
                        style: Theme.of(context)
                            .appTextStyles
                            .conversionAmountStyle
                            .copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                      ),
                  ],
                ),
                gapW16,
                ReorderableDragStartListener(
                  index: index,
                  child: Icon(
                    Icons.drag_handle,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
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
