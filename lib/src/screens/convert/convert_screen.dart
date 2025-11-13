import 'dart:async';
import '../../common_widgets/app_info_widget.dart';
import '/src/common_widgets/sliver_sized_box.dart';
import '/src/common_widgets/show_info_dialog.dart';
import '/src/screens/convert/base_currency_widget.dart';
import '/src/screens/convert/currency_conversion_tile.dart';
import '/src/screens/convert/currency_section_header.dart';
import '/src/screens/convert/exchange_rates_error.dart';
import '/src/screens/convert/last_updated_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/src/data/currency.dart';
import '/src/screens/selector/adaptive_currency_picker.dart';
import '/src/network/api_client.dart';
import '/src/storage/user_prefs_notifier.dart';
import '/src/storage/recent_currencies_storage.dart';

class ConvertScreen extends ConsumerStatefulWidget {
  const ConvertScreen({super.key});

  @override
  ConsumerState<ConvertScreen> createState() => _ConvertScreenState();
}

class _ConvertScreenState extends ConsumerState<ConvertScreen> {
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    // Set up automatic refresh every hour
    _refreshTimer = Timer.periodic(const Duration(hours: 1), (timer) {
      final baseCurrency = ref.read(userPrefsProvider).baseCurrency;
      ref.invalidate(latestRatesProvider(baseCurrency));
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use provider state with selector to only rebuild when convert-related fields change
    final (baseCurrency, amount, targetCurrencies) = ref.watch(
      userPrefsProvider.select(
        (prefs) => (
          prefs.baseCurrency,
          prefs.amount,
          prefs.targetCurrencies,
        ),
      ),
    );

    final ratesAsync = ref.watch(latestRatesProvider(baseCurrency));
    final date = ratesAsync.value?.date;
    return GestureDetector(
      onTap: () {
        // Hide keyboard when tapping outside
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Converter'),
          actions: [
            IconButton(
              onPressed: () => showInfoDialog(
                context: context,
                content: const AppInfoWidget(),
              ),
              icon: const Icon(Icons.info),
            ),
          ],
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
                  ref.read(userPrefsProvider.notifier).updateAmount(value);
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
                          padding: const .symmetric(vertical: 32.0),
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
                        onRemove: () => _removeCurrency(currency),
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
                      padding: .all(32.0),
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
    final userPrefs = ref.read(userPrefsProvider);
    final result = await AdaptiveCurrencyPicker.show(
      context,
      selectedCurrency: isBaseCurrency ? userPrefs.baseCurrency : null,
      inUseCurrencies: isBaseCurrency
          ? null
          : [userPrefs.baseCurrency, ...userPrefs.targetCurrencies],
    );

    if (result != null) {
      if (isBaseCurrency) {
        ref.read(userPrefsProvider.notifier).updateBaseCurrency(result);
      } else {
        ref.read(userPrefsProvider.notifier).addTargetCurrency(result);
      }
      // Save to recent currencies
      ref.read(recentCurrenciesStorageProvider.notifier).addCurrency(result);
    }
  }

  void _removeCurrency(Currency currency) {
    ref.read(userPrefsProvider.notifier).removeTargetCurrency(currency);
  }

  void _reorderCurrencies(int oldIndex, int newIndex) {
    ref
        .read(userPrefsProvider.notifier)
        .reorderTargetCurrencies(oldIndex, newIndex);
  }
}
