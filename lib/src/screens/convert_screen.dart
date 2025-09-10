import 'package:flutter/material.dart';

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
                      onCurrencyTap: () {
                        // TODO: Show currency picker
                      },
                      onAmountChanged: (value) {
                        // TODO: Update amount
                      },
                    ),
                    const SizedBox(height: 24),
                    
                    // Target Currencies Section
                    TargetCurrenciesSection(
                      baseCurrency: baseCurrency,
                      amount: amount,
                      targetCurrencies: targetCurrencies,
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
        onPressed: () {
          // TODO: Show currency picker
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add currency functionality coming soon')),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Add Currency',
      ),
    );
  }
}

class BaseCurrencyCard extends StatelessWidget {
  final String currency;
  final double amount;
  final VoidCallback onCurrencyTap;
  final ValueChanged<String> onAmountChanged;

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
                CurrencySelector(
                  currency: currency,
                  flag: '🇺🇸',
                  onTap: onCurrencyTap,
                ),
                const SizedBox(width: 16),
                // Amount input
                Expanded(
                  child: AmountDisplay(
                    amount: amount,
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

class CurrencySelector extends StatelessWidget {
  final String currency;
  final String flag;
  final VoidCallback onTap;

  const CurrencySelector({
    super.key,
    required this.currency,
    required this.flag,
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
              flag,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(width: 8),
            Text(
              currency,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}

class AmountDisplay extends StatelessWidget {
  final double amount;
  final ValueChanged<String> onChanged;

  const AmountDisplay({
    super.key,
    required this.amount,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        amount.toStringAsFixed(2),
        style: Theme.of(context).textTheme.titleLarge,
        textAlign: TextAlign.right,
      ),
    );
  }
}

class TargetCurrenciesSection extends StatelessWidget {
  final String baseCurrency;
  final double amount;
  final List<String> targetCurrencies;

  const TargetCurrenciesSection({
    super.key,
    required this.baseCurrency,
    required this.amount,
    required this.targetCurrencies,
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
        ...targetCurrencies.map((currency) => CurrencyConversionTile(
          currency: currency,
          baseCurrency: baseCurrency,
          amount: amount,
        )),
      ],
    );
  }
}

class CurrencyConversionTile extends StatelessWidget {
  final String currency;
  final String baseCurrency;
  final double amount;

  const CurrencyConversionTile({
    super.key,
    required this.currency,
    required this.baseCurrency,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    // Placeholder conversion rates
    final rates = {
      'EUR': 0.92,
      'GBP': 0.79,
      'JPY': 149.50,
    };
    final rate = rates[currency] ?? 1.0;
    final convertedAmount = amount * rate;
    final flag = currency == 'EUR' ? '🇪🇺' : currency == 'GBP' ? '🇬🇧' : '🇯🇵';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Text(
          flag,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        title: Text(currency),
        subtitle: Text('1 $baseCurrency = ${rate.toStringAsFixed(4)} $currency'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              convertedAmount.toStringAsFixed(2),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              currency,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
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
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
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
          TextButton(
            onPressed: onRefresh,
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }
}