import 'package:currency_converter/src/utils/package_info_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '/src/screens/settings/app_list_tile.dart';
import '/src/constants/app_sizes.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packageInfo = ref.watch(packageInfoProvider).requireValue;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Info"),
      ),
      body: ListView(
        children: [
          gapH32,
          Text(
            'Currency Converter',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          gapH12,
          Text(
            'Version ${packageInfo.version} (${packageInfo.buildNumber})',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          if (kIsWeb) ...[
            gapH12,
            Text(
              'WASM enabled: $kIsWasm',
              style: Theme.of(context).textTheme.labelMedium,
              textAlign: TextAlign.center,
            ),
          ],
          gapH32,
          //const ShowLicensesTile(),
        ],
      ),
    );
  }
}

class AppIconWidget extends StatelessWidget {
  const AppIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Sizes.p20),
      child: Image.asset('assets/app-icon.png', height: 100),
    );
  }
}

class ShowLicensesTile extends StatelessWidget {
  const ShowLicensesTile({super.key});

  @override
  Widget build(BuildContext context) {
    return AppListTile(
      title: 'Show licenses',
      trailing: const Icon(Icons.chevron_right),
      onTap: () => showLicensePage(context: context),
    );
  }
}
