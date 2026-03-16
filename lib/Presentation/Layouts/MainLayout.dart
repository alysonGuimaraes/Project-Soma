
import 'package:flutter/material.dart';
import 'package:project_soma/Presentation/Pages/Transactions/TransactionsPage.dart';
import '../Pages/DashboardPage.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  // Lista das telas reais que vão aparecer na área principal
  final List<Widget> _pages = [
    const DashboardPage(),
    const TransactionsPage(), // Placeholder temporário
    const Center(child: Text('Tela de Configurações')), // Placeholder temporário
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
                icon: Icon(Icons.list_alt),
                selectedIcon: Icon(Icons.list),
                label: Text('Transações'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: Text('Configurações'),
              ),
            ],
          ),

          const VerticalDivider(thickness: 1, width: 1), // Linha divisória

          // 2. Área Principal de Conteúdo
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
    );
  }
}