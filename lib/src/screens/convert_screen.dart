import 'package:flutter/material.dart';
import '../widgets/currency_selector.dart';
import '../widgets/currency_picker_dialog.dart';
import '../widgets/amount_input_field.dart';
import '../providers/fake_data_provider.dart';

class ConvertScreen extends StatefulWidget {
  const ConvertScreen({super.key});

  @override
  State<ConvertScreen> createState() => _ConvertScreenState();
}

class _ConvertScreenState extends State<ConvertScreen> {
  // State variables
  String baseCurrency = 'USD';
  double amount = 100.0;
  List<String> targetCurrencies = ['EUR', 'GBP', 'JPY'];
  DateTime lastUpdated = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Converter'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Main content area with scroll
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Base Currency Section
                    BaseCurrencyCard(
                      currency: baseCurrency,
                      amount: amount,
                      onCurrencyTap: () => _showCurrencyPicker(true),
                      onAmountChanged: (value) {
                        setState(() {
                          amount = value;
                        });
                      },
                    ),
                    const SizedBox(height: 24),

                    // Target Currencies Section
                    TargetCurrenciesSection(
                      baseCurrency: baseCurrency,
                      amount: amount,
                      targetCurrencies: targetCurrencies,
                      onRemoveCurrency: _removeCurrency,
                    ),
                    const SizedBox(height: 80), // Space for FAB
                  ],
                ),
              ),
            ),

            // Last Updated Footer
            LastUpdatedFooter(
              lastUpdated: lastUpdated,
              onRefresh: () {
                setState(() {
                  lastUpdated = DateTime.now();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Rates refreshed')),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCurrencyPicker(false),
        tooltip: 'Add Currency',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showCurrencyPicker(bool isBaseCurrency) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => CurrencyPickerDialog(
        selectedCurrency: isBaseCurrency ? baseCurrency : null,
        excludedCurrencies: isBaseCurrency
            ? null
            : [baseCurrency, ...targetCurrencies],
      ),
    );

    if (result != null) {
      setState(() {
        if (isBaseCurrency) {
          baseCurrency = result;
        } else {
          if (!targetCurrencies.contains(result)) {
            targetCurrencies.add(result);
          }
        }
      });
    }
  }

  void _removeCurrency(String currency) {
    setState(() {
      targetCurrencies.remove(currency);
    });
  }
}

class BaseCurrencyCard extends StatelessWidget {
  final String currency;
  final double amount;
  final VoidCallback onCurrencyTap;
  final ValueChanged<double> onAmountChanged;

  const BaseCurrencyCard({
    super.key,
    required this.currency,
    required this.amount,
    required this.onCurrencyTap,
    required this.onAmountChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'From',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                // Currency selector
                CurrencySelector(currency: currency, onTap: onCurrencyTap),
                const SizedBox(width: 16),
                // Amount input
                Expanded(
                  child: AmountInputField(
                    initialAmount: amount,
                    onChanged: onAmountChanged,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TargetCurrenciesSection extends StatelessWidget {
  final String baseCurrency;
  final double amount;
  final List<String> targetCurrencies;
  final void Function(String) onRemoveCurrency;

  const TargetCurrenciesSection({
    super.key,
    required this.baseCurrency,
    required this.amount,
    required this.targetCurrencies,
    required this.onRemoveCurrency,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'To',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        ...targetCurrencies.map(
          (currency) => CurrencyConversionTile(
            currency: currency,
            baseCurrency: baseCurrency,
            amount: amount,
            onRemove: () => onRemoveCurrency(currency),
          ),
        ),
      ],
    );
  }
}

class CurrencyConversionTile extends StatelessWidget {
  final String currency;
  final String baseCurrency;
  final double amount;
  final VoidCallback? onRemove;

  const CurrencyConversionTile({
    super.key,
    required this.currency,
    required this.baseCurrency,
    required this.amount,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final rate = FakeDataProvider.getExchangeRate(baseCurrency, currency);
    final convertedAmount = amount * rate;
    final flag = FakeDataProvider.getFlag(currency);
    final currencyName = FakeDataProvider.getCurrencyName(currency);

    return Dismissible(
      key: Key(currency),
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
              Text(currency),
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
          subtitle: Text(
            '1 $baseCurrency = ${rate.toStringAsFixed(4)} $currency',
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    convertedAmount.toStringAsFixed(2),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(currency, style: Theme.of(context).textTheme.bodySmall),
                ],
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

class LastUpdatedFooter extends StatelessWidget {
  final DateTime lastUpdated;
  final VoidCallback onRefresh;

  const LastUpdatedFooter({
    super.key,
    required this.lastUpdated,
    required this.onRefresh,
  });

  String _formatLastUpdated() {
    final difference = DateTime.now().difference(lastUpdated);
    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else {
      return '${difference.inHours}h ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.update,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                'Updated ${_formatLastUpdated()}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          TextButton(onPressed: onRefresh, child: const Text('Refresh')),
        ],
      ),
    );
  }
}
