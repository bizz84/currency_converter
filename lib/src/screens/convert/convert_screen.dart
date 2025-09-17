import 'dart:async';
import 'package:currency_converter/src/common_widgets/sliver_sized_box.dart';
import 'package:currency_converter/src/screens/convert/base_currency_widget.dart';
import 'package:currency_converter/src/screens/convert/currency_conversion_tile.dart';
import 'package:currency_converter/src/screens/convert/currency_section_header.dart';
import 'package:currency_converter/src/screens/convert/exchange_rates_error.dart';
import 'package:currency_converter/src/screens/convert/last_updated_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'adaptive_currency_picker.dart';
import '/src/network/frankfurter_client.dart';
import '/src/storage/user_prefs_notifier.dart';

class ConvertScreen extends ConsumerStatefulWidget {
  const ConvertScreen({super.key});

  @override
  ConsumerState<ConvertScreen> createState() => _ConvertScreenState();
}

class _ConvertScreenState extends ConsumerState<ConvertScreen> {
  // Refresh timer
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    // Set up automatic refresh every hour
    _refreshTimer = Timer.periodic(const Duration(hours: 1), (timer) {
      final base = ref.read(userPrefsProvider).baseCurrency;
      ref.invalidate(latestRatesProvider(base));
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prefs = ref.watch(userPrefsProvider);
    final baseCurrency = prefs.baseCurrency;
    final amount = prefs.amount;
    final targetCurrencies = prefs.targetCurrencies;
    final ratesAsync = ref.watch(latestRatesProvider(baseCurrency));
    final date = ratesAsync.value?.dateTime;
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
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: LastUpdatedWidget(lastUpdated: date),
            ),
            // From section header
            SliverToBoxAdapter(
              child: CurrencySectionHeader(title: 'From'),
            ),
            sliverGapH12,
            // Base Currency Section
            SliverToBoxAdapter(
              child: BaseCurrencyWidget(
                currency: baseCurrency,
                amount: amount,
                onCurrencyTap: () => _showCurrencyPicker(true),
                onAmountChanged: (value) {
                  ref.read(userPrefsProvider.notifier).setAmount(value);
                },
              ),
            ),
            sliverGapH24,
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
                  sliverGapH12,
                  SliverReorderableList(
                    itemBuilder: (context, index) {
                      final currency = targetCurrencies[index];
                      return CurrencyConversionTile(
                        key: ValueKey(currency),
                        currency: currency,
                        baseCurrency: baseCurrency,
                        amount: amount,
                        index: index,
                        rate: currency == baseCurrency
                            ? 1.0
                            : rates.rates[currency.name],
                        onRemove: () => ref
                            .read(userPrefsProvider.notifier)
                            .removeTarget(currency),
                      );
                    },
                    itemCount: targetCurrencies.length,
                    onReorder: (oldIndex, newIndex) {
                      HapticFeedback.mediumImpact();
                      ref
                          .read(userPrefsProvider.notifier)
                          .reorderTargets(oldIndex, newIndex);
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
            sliverGapH80,
          ],
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
    final result = await AdaptiveCurrencyPicker.show(
      context,
      selectedCurrency: isBaseCurrency
          ? ref.read(userPrefsProvider).baseCurrency
          : null,
      excludedCurrencies: isBaseCurrency
          ? null
          : ref.read(userPrefsProvider).targetCurrencies,
    );

    if (result != null) {
      if (isBaseCurrency) {
        await ref.read(userPrefsProvider.notifier).setBase(result);
        // Invalidate rates for new base
        ref.invalidate(latestRatesProvider(result));
      } else {
        await ref.read(userPrefsProvider.notifier).addTarget(result);
      }
    }
  }
}
