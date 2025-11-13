import 'package:currency_converter/src/env/env.dart';

import '/src/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LastUpdatedWidget extends StatelessWidget {
  const LastUpdatedWidget({super.key, required this.lastUpdated});
  final DateTime? lastUpdated;

  String _formatLastUpdated() {
    // Format: "16 Sep 2025"
    if (lastUpdated == null) {
      return 'Updating...';
    }
    final format = Env.converterApi == ConverterApi.currencyApi
        ? 'd MMM yyyy - HH:mm'
        : 'd MMM yyyy';
    return 'Last updated: ${DateFormat(format).format(lastUpdated!)}';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: .center,
        children: [
          Icon(
            Icons.update,
            size: 16,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          gapW4,
          Text(
            _formatLastUpdated(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
