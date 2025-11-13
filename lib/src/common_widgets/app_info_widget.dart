import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/src/constants/app_sizes.dart';
import '/src/utils/package_info_provider.dart';

class AppInfoWidget extends ConsumerWidget {
  const AppInfoWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packageInfo = ref.watch(packageInfoProvider).requireValue;
    return Column(
      mainAxisSize: .min,
      children: [
        gapH32,
        Text(
          'Currency Converter',
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: .center,
        ),
        gapH12,
        Text(
          'Version ${packageInfo.version} (${packageInfo.buildNumber})',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: .center,
        ),
        if (kIsWeb) ...[
          gapH12,
          Text(
            'WASM enabled: $kIsWasm',
            style: Theme.of(context).textTheme.labelMedium,
            textAlign: .center,
          ),
        ],
        gapH32,
        //const ShowLicensesTile(),
      ],
    );
  }
}
