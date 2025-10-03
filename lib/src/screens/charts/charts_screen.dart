import '/src/constants/app_sizes.dart';
import '/src/screens/charts/currency_selector_row.dart';
import '/src/screens/charts/exchange_rate_header.dart';
import '/src/screens/charts/time_range_selector.dart';
import 'package:flutter/material.dart';

class ChartsScreen extends StatelessWidget {
  const ChartsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exchange Rate Charts'),
        centerTitle: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(Sizes.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CurrencySelectorRow(),
            gapH16,
            ExchangeRateHeader(),
            gapH16,
            TimeRangeSelector(),
            gapH24,
            Expanded(
              child: Center(
                child: Text(
                  'Chart will be displayed here',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
