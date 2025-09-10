import 'package:flutter/material.dart';
import '../providers/fake_data_provider.dart';

class CurrencyPickerDialog extends StatefulWidget {
  final String? selectedCurrency;
  final List<String>? excludedCurrencies;

  const CurrencyPickerDialog({
    super.key,
    this.selectedCurrency,
    this.excludedCurrencies,
  });

  @override
  State<CurrencyPickerDialog> createState() => _CurrencyPickerDialogState();
}

class _CurrencyPickerDialogState extends State<CurrencyPickerDialog> {
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
    final currencies = FakeDataProvider.currencies.entries
        .where((entry) => 
            !(widget.excludedCurrencies?.contains(entry.key) ?? false) &&
            (entry.key.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             entry.value.toLowerCase().contains(_searchQuery.toLowerCase())))
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
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
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
                      FakeDataProvider.getFlag(entry.key),
                      style: const TextStyle(fontSize: 24),
                    ),
                    title: Text(entry.key),
                    subtitle: Text(entry.value),
                    selected: isSelected,
                    selectedTileColor: Theme.of(context).colorScheme.primaryContainer,
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
  }
}