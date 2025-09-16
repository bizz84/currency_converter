import 'package:currency_converter/src/utils/should_use_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/currency.dart';
import '../../network/frankfurter_client.dart';

class AdaptiveCurrencyPicker {
  static Future<Currency?> show(
    BuildContext context, {
    Currency? selectedCurrency,
    List<Currency>? excludedCurrencies,
  }) async {
    if (shouldUseBottomSheet(context)) {
      return showModalBottomSheet<Currency>(
        context: context,
        isScrollControlled: true,
        enableDrag: true,
        isDismissible: true,
        backgroundColor: Colors.transparent,
        useSafeArea: true,
        builder: (context) => _AdaptiveCurrencyPickerBottomSheet(
          selectedCurrency: selectedCurrency,
          excludedCurrencies: excludedCurrencies,
        ),
      );
    } else {
      return showDialog<Currency>(
        context: context,
        builder: (context) => _AdaptiveCurrencyPickerDialog(
          selectedCurrency: selectedCurrency,
          excludedCurrencies: excludedCurrencies,
        ),
      );
    }
  }
}

// Shared content widget used by both bottom sheet and dialog
class _CurrencyPickerContent extends ConsumerStatefulWidget {
  final Currency? selectedCurrency;
  final List<Currency>? excludedCurrencies;
  final ScrollController? scrollController;
  final bool showHeader;

  const _CurrencyPickerContent({
    this.selectedCurrency,
    this.excludedCurrencies,
    this.scrollController,
    this.showHeader = true,
  });

  @override
  ConsumerState<_CurrencyPickerContent> createState() =>
      _CurrencyPickerContentState();
}

class _CurrencyPickerContentState
    extends ConsumerState<_CurrencyPickerContent> {
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
        final currencies = currenciesData.currencies
            .where(
              (currency) =>
                  !(widget.excludedCurrencies?.contains(currency) ?? false) &&
                  (currency.name.toLowerCase().contains(
                        _searchQuery.toLowerCase(),
                      ) ||
                      currency.desc.toLowerCase().contains(
                        _searchQuery.toLowerCase(),
                      )),
            )
            .toList();

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with search
            if (widget.showHeader)
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
                controller: widget.scrollController,
                shrinkWrap: true,
                itemCount: currencies.length,
                itemBuilder: (context, index) {
                  final currency = currencies[index];
                  final isSelected = currency == widget.selectedCurrency;

                  return ListTile(
                    leading: Text(
                      currency.flag,
                      style: const TextStyle(fontSize: 24),
                    ),
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
                },
              ),
            ),
          ],
        );
      },
      loading: () => const Padding(
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
      error: (error, stack) => Padding(
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
    );
  }
}

// Bottom sheet implementation for mobile
class _AdaptiveCurrencyPickerBottomSheet extends StatefulWidget {
  final Currency? selectedCurrency;
  final List<Currency>? excludedCurrencies;

  const _AdaptiveCurrencyPickerBottomSheet({
    this.selectedCurrency,
    this.excludedCurrencies,
  });

  @override
  State<_AdaptiveCurrencyPickerBottomSheet> createState() =>
      _AdaptiveCurrencyPickerBottomSheetState();
}

class _AdaptiveCurrencyPickerBottomSheetState
    extends State<_AdaptiveCurrencyPickerBottomSheet> {
  final DraggableScrollableController _draggableController =
      DraggableScrollableController();
  static const intitialSize = 0.9;
  double _previousSize = intitialSize;

  @override
  void initState() {
    super.initState();
    _draggableController.addListener(_onDraggableChanged);
  }

  void _onDraggableChanged() {
    final currentSize = _draggableController.size;

    // Detect when dragging down
    if (currentSize < _previousSize) {
      // Dismiss keyboard when dragging down
      FocusScope.of(context).unfocus();
    }

    _previousSize = currentSize;
  }

  @override
  void dispose() {
    _draggableController.removeListener(_onDraggableChanged);
    _draggableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: _draggableController,
      initialChildSize: intitialSize,
      minChildSize: 0.3,
      maxChildSize: intitialSize,
      snap: true,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: _CurrencyPickerContent(
                  selectedCurrency: widget.selectedCurrency,
                  excludedCurrencies: widget.excludedCurrencies,
                  scrollController: scrollController,
                  showHeader: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Dialog implementation for tablet/desktop
class _AdaptiveCurrencyPickerDialog extends StatelessWidget {
  final Currency? selectedCurrency;
  final List<Currency>? excludedCurrencies;

  const _AdaptiveCurrencyPickerDialog({
    this.selectedCurrency,
    this.excludedCurrencies,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
          maxWidth: 400,
        ),
        child: _CurrencyPickerContent(
          selectedCurrency: selectedCurrency,
          excludedCurrencies: excludedCurrencies,
          showHeader: true,
        ),
      ),
    );
  }
}
