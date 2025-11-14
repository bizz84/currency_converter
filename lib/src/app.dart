import '/src/common_widgets/responsive_constrained_box.dart';
import '/src/storage/user_prefs_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/convert/convert_screen.dart';
import 'screens/charts/charts_screen.dart';

class CurrencyConverterApp extends StatelessWidget {
  const CurrencyConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: const ResponsiveConstrainedBox(
        child: MainScreen(),
      ),
    );
  }
}

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  static const _screens = [
    ConvertScreen(),
    ChartsScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(
      userPrefsProvider.select((prefs) => prefs.selectedTabIndex),
    );

    return Scaffold(
      body: _screens[selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          ref.read(userPrefsProvider.notifier).updateSelectedTabIndex(index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.currency_exchange),
            label: 'Convert',
          ),
          NavigationDestination(
            icon: Icon(Icons.show_chart),
            label: 'Charts',
          ),
        ],
      ),
    );
  }
}
