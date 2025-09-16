import 'package:currency_converter/src/common_widgets/responsive_constrained_box.dart';
import 'package:flutter/material.dart';
import 'screens/convert/convert_screen.dart';
import 'screens/charts/charts_screen.dart';

class CurrencyConverterApp extends StatelessWidget {
  const CurrencyConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      builder: (context, child) => ResponsiveConstrainedBox(
        child: child!,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    ConvertScreen(),
    ChartsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
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
