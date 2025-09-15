import 'dart:async';
import 'package:currency_converter/src/screens/convert/currency_conversion_tile.dart';
import 'package:currency_converter/src/screens/convert/currency_section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/currency.dart';
import 'currency_selector.dart';
import 'currency_picker_dialog.dart';
import 'amount_input_field.dart';
import '../../network/frankfurter_client.dart';
import '../../data/currency_rates.dart';

class ConvertScreen extends ConsumerStatefulWidget {
  const ConvertScreen({super.key});

  @override
  ConsumerState<ConvertScreen> createState() => _ConvertScreenState();
}

class _ConvertScreenState extends ConsumerState<ConvertScreen> {
  // State variables
  Currency baseCurrency = Currency.USD;
  double amount = 100.0;
  List<Currency> targetCurrencies = [Currency.EUR, Currency.GBP, Currency.JPY];
  DateTime lastUpdated = DateTime.now();
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    // Set up automatic refresh every 60 seconds
    _refreshTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
      ref.invalidate(latestRatesProvider(baseCurrency));
      setState(() {
        lastUpdated = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ratesAsync = ref.watch(latestRatesProvider(baseCurrency));
    return GestureDetector(
      onTap: () {
        // Hide keyboard when tapping outside
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Currency Converter'),
          centerTitle: true,
          elevation: 0,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            // Invalidate the provider to force a refresh
            ref.invalidate(latestRatesProvider(baseCurrency));

            setState(() {
              lastUpdated = DateTime.now();
            });
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CurrencySectionHeader(title: 'From'),
                const SizedBox(height: 12),
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
                // Target Currencies Section with loading/error handling
                ratesAsync.when(
                  data: (rates) => TargetCurrenciesSection(
                    baseCurrency: baseCurrency,
                    amount: amount,
                    targetCurrencies: targetCurrencies,
                    onRemoveCurrency: _removeCurrency,
                    onAddCurrency: () => _showCurrencyPicker(false),
                    rates: rates,
                  ),
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (error, stack) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Failed to load exchange rates',
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            error.toString(),
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
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
                  ),
                ),
                // Last Updated Footer
                // LastUpdatedFooter(
                //   lastUpdated: lastUpdated,
                //   onRefresh: () {
                //     ref.invalidate(latestRatesProvider(baseCurrency));
                //     setState(() {
                //       lastUpdated = DateTime.now();
                //     });
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       const SnackBar(content: Text('Rates refreshed')),
                //     );
                //   },
                // ),
                // const SizedBox(height: 80), // Space for FAB
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showCurrencyPicker(false),
          tooltip: 'Add Currency',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Future<void> _showCurrencyPicker(bool isBaseCurrency) async {
    final result = await showDialog<Currency>(
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

  void _removeCurrency(Currency currency) {
    setState(() {
      targetCurrencies.remove(currency);
    });
  }
}

class BaseCurrencyCard extends StatelessWidget {
  final Currency currency;
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
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
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
      ),
    );
  }
}

class TargetCurrenciesSection extends StatelessWidget {
  final Currency baseCurrency;
  final double amount;
  final List<Currency> targetCurrencies;
  final void Function(Currency) onRemoveCurrency;
  final VoidCallback onAddCurrency;
  final CurrencyRates rates;

  const TargetCurrenciesSection({
    super.key,
    required this.baseCurrency,
    required this.amount,
    required this.targetCurrencies,
    required this.onRemoveCurrency,
    required this.onAddCurrency,
    required this.rates,
  });

  @override
  Widget build(BuildContext context) {
    if (targetCurrencies.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0),
          child: ElevatedButton(
            onPressed: onAddCurrency,
            child: const Text('Add a currency'),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CurrencySectionHeader(title: 'To'),
        const SizedBox(height: 12),
        ...targetCurrencies.map(
          (currency) => CurrencyConversionTile(
            currency: currency,
            baseCurrency: baseCurrency,
            amount: amount,
            rate: currency == baseCurrency ? 1.0 : rates.rates[currency.name],
            onRemove: () => onRemoveCurrency(currency),
          ),
        ),
      ],
    );
  }
}
