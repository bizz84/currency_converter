import '/src/common_widgets/drag_handle_widget.dart';
import '/src/utils/should_use_bottom_sheet.dart';
import '/src/data/currency.dart';
import '/src/screens/selector/currency_picker_content.dart';
import 'package:flutter/material.dart';

class AdaptiveCurrencyPicker {
  static Future<Currency?> show(
    BuildContext context, {
    Currency? selectedCurrency,
    List<Currency>? inUseCurrencies,
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
          inUseCurrencies: inUseCurrencies,
        ),
      );
    } else {
      return showDialog<Currency>(
        context: context,
        builder: (context) => _AdaptiveCurrencyPickerDialog(
          selectedCurrency: selectedCurrency,
          inUseCurrencies: inUseCurrencies,
        ),
      );
    }
  }
}

// Bottom sheet implementation for mobile
class _AdaptiveCurrencyPickerBottomSheet extends StatefulWidget {
  final Currency? selectedCurrency;
  final List<Currency>? inUseCurrencies;

  const _AdaptiveCurrencyPickerBottomSheet({
    this.selectedCurrency,
    this.inUseCurrencies,
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
            const DragHandleWidget(),
            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: CurrencyPickerContent(
                  selectedCurrency: widget.selectedCurrency,
                  inUseCurrencies: widget.inUseCurrencies,
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
  final List<Currency>? inUseCurrencies;

  const _AdaptiveCurrencyPickerDialog({
    this.selectedCurrency,
    this.inUseCurrencies,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
          maxWidth: 400,
        ),
        child: CurrencyPickerContent(
          selectedCurrency: selectedCurrency,
          inUseCurrencies: inUseCurrencies,
          showHeader: true,
        ),
      ),
    );
  }
}
