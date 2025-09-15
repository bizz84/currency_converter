import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/currency.dart';
import '../network/frankfurter_client.dart';

class CurrencyPickerDialog extends ConsumerStatefulWidget {
  final String? selectedCurrency;
  final List<String>? excludedCurrencies;

  const CurrencyPickerDialog({
    super.key,
    this.selectedCurrency,
    this.excludedCurrencies,
  });

  @override
  ConsumerState<CurrencyPickerDialog> createState() =>
      _CurrencyPickerDialogState();
}

class _CurrencyPickerDialogState extends ConsumerState<CurrencyPickerDialog> {
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

    return currenciesAsync.when(
      data: (currenciesData) {
        final currencies = currenciesData.currencies.entries
            .where(
              (entry) =>
                  !(widget.excludedCurrencies?.contains(entry.key) ?? false) &&
                  (entry.key.toLowerCase().contains(
                        _searchQuery.toLowerCase(),
                      ) ||
                      entry.value.toLowerCase().contains(
                        _searchQuery.toLowerCase(),
                      )),
            )
            .toList();

        return Dialog(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
              maxWidth: 400,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with search
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Currency',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search currencies...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                // Currency list
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: currencies.length,
                    itemBuilder: (context, index) {
                      final entry = currencies[index];
                      final isSelected = entry.key == widget.selectedCurrency;

                      return ListTile(
                        leading: Text(
                          Currency.from(entry.key).flag,
                          style: const TextStyle(fontSize: 24),
                        ),
                        title: Text(entry.key),
                        subtitle: Text(entry.value),
                        selected: isSelected,
                        selectedTileColor: Theme.of(
                          context,
                        ).colorScheme.primaryContainer,
                        onTap: () {
                          Navigator.of(context).pop(entry.key);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Dialog(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading currencies...'),
            ],
          ),
        ),
      ),
      error: (error, stack) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              const Text('Failed to load currencies'),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
