import 'dart:async';
import 'package:currency_converter/src/screens/convert/currency_conversion_tile.dart';
import 'package:currency_converter/src/screens/convert/currency_section_header.dart';
import 'package:currency_converter/src/screens/convert/exchange_rates_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/currency.dart';
import 'currency_selector.dart';
import 'currency_picker_dialog.dart';
import 'amount_input_field.dart';
import '../../network/frankfurter_client.dart';

class ConvertScreen extends ConsumerStatefulWidget {
  const ConvertScreen({super.key});

  @override
  ConsumerState<ConvertScreen> createState() => _ConvertScreenState();
}

class _ConvertScreenState extends ConsumerState<ConvertScreen> {
  // State variables
  Currency baseCurrency = Currency.GBP;
  double amount = 100.0;
  List<Currency> targetCurrencies = [Currency.EUR, Currency.USD, Currency.JPY];
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
          child: CustomScrollView(
            slivers: [
              // From section header
              SliverToBoxAdapter(
                child: CurrencySectionHeader(title: 'From'),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 12),
              ),
              // Base Currency Section
              SliverToBoxAdapter(
                child: BaseCurrencyCard(
                  currency: baseCurrency,
                  amount: amount,
                  onCurrencyTap: () => _showCurrencyPicker(true),
                  onAmountChanged: (value) {
                    setState(() {
                      amount = value;
                    });
                  },
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 24),
              ),
              // Target Currencies Section with loading/error handling
              ...ratesAsync.when(
                data: (rates) {
                  if (targetCurrencies.isEmpty) {
                    return [
                      SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32.0),
                            child: ElevatedButton(
                              onPressed: () => _showCurrencyPicker(false),
                              child: const Text('Add a currency'),
                            ),
                          ),
                        ),
                      ),
                    ];
                  }
                  return [
                    SliverToBoxAdapter(
                      child: CurrencySectionHeader(title: 'To'),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 12),
                    ),
                    SliverReorderableList(
                      itemBuilder: (context, index) {
                        final currency = targetCurrencies[index];
                        return ReorderableDragStartListener(
                          key: ValueKey(currency),
                          index: index,
                          child: CurrencyConversionTile(
                            currency: currency,
                            baseCurrency: baseCurrency,
                            amount: amount,
                            rate: currency == baseCurrency
                                ? 1.0
                                : rates.rates[currency.name],
                            onRemove: () => _removeCurrency(currency),
                          ),
                        );
                      },
                      itemCount: targetCurrencies.length,
                      onReorder: (oldIndex, newIndex) {
                        HapticFeedback.mediumImpact();
                        _reorderCurrencies(oldIndex, newIndex);
                      },
                    ),
                  ];
                },
                loading: () => [
                  const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ],
                error: (error, stack) => [
                  SliverToBoxAdapter(
                    child: ExchangeRatesError(
                      baseCurrency: baseCurrency,
                      error: error,
                    ),
                  ),
                ],
              ),
              // Spacing for FAB
              const SliverToBoxAdapter(
                child: SizedBox(height: 80),
              ),
            ],
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

  void _reorderCurrencies(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final Currency currency = targetCurrencies.removeAt(oldIndex);
      targetCurrencies.insert(newIndex, currency);
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
