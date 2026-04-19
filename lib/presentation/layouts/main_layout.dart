
import 'package:flutter/material.dart';

import '../pages/dashboard_page.dart';
import '../pages/transactions/transactions_page.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardPage(),
    const TransactionsPage(),
    const Center(child: Text('Tela de Categorias')),
    const Center(child: Text('Tela de Configurações')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Menu Lateral
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            extended: true, // Se true, mostra os textos. Se false, só ícones.
            minExtendedWidth: 200, // Largura do menu
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: Text('Dashboard'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.featured_play_list_outlined),
                selectedIcon: Icon(Icons.featured_play_list),
                label: Text('Transações'),
              ),NavigationRailDestination(
                icon: Icon(Icons.category_outlined),
                selectedIcon: Icon(Icons.category_rounded),
                label: Text('Categorias'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: Text('Configurações'),
              ),
            ],
          ),

          const VerticalDivider(thickness: 1, width: 1),

          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
    );
  }
}