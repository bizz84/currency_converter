import '/src/common_widgets/currency_flag_text.dart';
import '/src/common_widgets/error_state_widget.dart';
import '/src/constants/app_sizes.dart';
import '/src/data/currency.dart';
import '/src/data/currencies.dart';
import '/src/network/api_client.dart';
import '/src/storage/recent_currencies_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Shared content widget used by both bottom sheet and dialog
class CurrencyPickerContent extends ConsumerStatefulWidget {
  final Currency? selectedCurrency;
  final List<Currency>? inUseCurrencies;
  final ScrollController? scrollController;
  final bool showHeader;

  const CurrencyPickerContent({
    super.key,
    this.selectedCurrency,
    this.inUseCurrencies,
    this.scrollController,
    this.showHeader = true,
  });

  @override
  ConsumerState<CurrencyPickerContent> createState() =>
      _CurrencyPickerContentState();
}

class _CurrencyPickerContentState extends ConsumerState<CurrencyPickerContent> {
  late TextEditingController _searchController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currenciesAsync = ref.watch(availableCurrenciesProvider);
    final recentCurrencies = ref.watch(recentCurrenciesStorageProvider);

    return currenciesAsync.when(
      data: (currenciesData) => _CurrencyPickerData(
        currenciesData: currenciesData,
        recentCurrencies: recentCurrencies,
        searchQuery: _searchQuery,
        searchController: _searchController,
        onSearchChanged: (value) => setState(() => _searchQuery = value),
        selectedCurrency: widget.selectedCurrency,
        inUseCurrencies: widget.inUseCurrencies,
        scrollController: widget.scrollController,
        showHeader: widget.showHeader,
      ),
      loading: () => const Padding(
        padding: .all(32.0),
        child: Column(
          mainAxisSize: .min,
          children: [
            CircularProgressIndicator(),
            gapH16,
            Text('Loading currencies...'),
          ],
        ),
      ),
      error: (error, stack) => Padding(
        padding: const .all(32.0),
        child: Column(
          mainAxisSize: .min,
          children: [
            const ErrorStateWidget(message: 'Failed to load currencies'),
            gapH16,
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget that displays the currency list with search results
class _CurrencyPickerData extends StatelessWidget {
  final Currencies currenciesData;
  final List<Currency> recentCurrencies;
  final String searchQuery;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final Currency? selectedCurrency;
  final List<Currency>? inUseCurrencies;
  final ScrollController? scrollController;
  final bool showHeader;

  const _CurrencyPickerData({
    required this.currenciesData,
    required this.recentCurrencies,
    required this.searchQuery,
    required this.searchController,
    required this.onSearchChanged,
    this.selectedCurrency,
    this.inUseCurrencies,
    this.scrollController,
    required this.showHeader,
  });

  @override
  Widget build(BuildContext context) {
    // Get in-use currencies (which are also excluded from selection)
    final inUseCurrenciesList = inUseCurrencies ?? [];

    // Filter currencies based on search and exclusions
    final allCurrencies = currenciesData.currencies
        .where(
          (currency) =>
              !inUseCurrenciesList.contains(currency) &&
              (currency.name.toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  ) ||
                  currency.desc.toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  )),
        )
        .toList();

    // Build RECENT section: in-use currencies + MRU, deduplicated
    final recentSection =
        <Currency>[
              ...inUseCurrenciesList,
              ...recentCurrencies.where(
                (c) => !inUseCurrenciesList.contains(c),
              ),
            ]
            .where(
              (currency) =>
                  !inUseCurrenciesList.contains(currency) &&
                  (currency.name.toLowerCase().contains(
                        searchQuery.toLowerCase(),
                      ) ||
                      currency.desc.toLowerCase().contains(
                        searchQuery.toLowerCase(),
                      )),
            )
            .toList();

    return Column(
      mainAxisSize: .min,
      children: [
        // Header with search
        if (showHeader)
          Container(
            padding: const .all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  'Select Currency',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                gapH16,
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search currencies...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: .circular(8),
                    ),
                    contentPadding: const .symmetric(
                      horizontal: 16,
                    ),
                  ),
                  onChanged: onSearchChanged,
                ),
              ],
            ),
          ),
        // Currency list with sections
        Flexible(
          child: ListView(
            controller: scrollController,
            shrinkWrap: true,
            children: [
              // RECENT section
              if (recentSection.isNotEmpty) ...[
                Padding(
                  padding: const .fromLTRB(16, 16, 16, 8),
                  child: Text(
                    'RECENT',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                ...recentSection.map((currency) {
                  final isSelected = currency == selectedCurrency;
                  return ListTile(
                    leading: CurrencyFlagText(flag: currency.flag),
                    title: Text(currency.name),
                    subtitle: Text(currency.desc),
                    trailing: isSelected
                        ? Icon(
                            Icons.check,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : null,
                    onTap: () {
                      Navigator.of(context).pop(currency);
                    },
                  );
                }),
              ],
              // ALL section
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'ALL',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              ...allCurrencies.map((currency) {
                final isSelected = currency == selectedCurrency;
                return ListTile(
                  leading: CurrencyFlagText(flag: currency.flag),
                  title: Text(currency.name),
                  subtitle: Text(currency.desc),
                  trailing: isSelected
                      ? Icon(
                          Icons.check,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : null,
                  onTap: () {
                    Navigator.of(context).pop(currency);
                  },
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
