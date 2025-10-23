import 'package:flutter/material.dart';
import '/src/common_widgets/show_info_dialog.dart';
import '/src/constants/app_sizes.dart';
import '../../common_widgets/app_info_widget.dart';
import '/src/screens/charts/currency_selector_row.dart';
import '/src/screens/charts/exchange_rate_chart.dart';
import '/src/screens/charts/exchange_rate_header.dart';
import '/src/screens/charts/time_range_selector.dart';

class ChartsScreen extends StatelessWidget {
  const ChartsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Charts'),
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
              child: ExchangeRateChart(),
            ),
          ],
        ),
      ),
    );
  }
}
