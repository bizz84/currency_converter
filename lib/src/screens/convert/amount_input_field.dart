import 'package:currency_converter/src/theme/app_theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AmountInputField extends StatefulWidget {
  final double initialAmount;
  final String currencySymbol;
  final ValueChanged<double> onChanged;

  const AmountInputField({
    super.key,
    required this.initialAmount,
    required this.currencySymbol,
    required this.onChanged,
  });

  @override
  State<AmountInputField> createState() => _AmountInputFieldState();
}

class _AmountInputFieldState extends State<AmountInputField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialAmount.toStringAsFixed(2),
    );
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      // Format the text when focus is lost
      final amount = double.tryParse(_controller.text) ?? widget.initialAmount;
      _controller.text = amount.toStringAsFixed(2);
      widget.onChanged(amount);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      keyboardType: const .numberWithOptions(decimal: true),
      textAlign: .right,
      style: Theme.of(context).appTextStyles.exchangeRateHeaderStyle,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      ],
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: .circular(8),
        ),
        contentPadding: const .symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        prefixText: '${widget.currencySymbol} ',
        prefixStyle: Theme.of(context).appTextStyles.exchangeRateHeaderStyle,
      ),
      onChanged: (value) {
        final amount = double.tryParse(value) ?? 0.0;
        widget.onChanged(amount);
      },
    );
  }
}
