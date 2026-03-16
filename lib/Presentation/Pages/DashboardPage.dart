
import 'package:flutter/material.dart';

import '../Widget/transaction_form_dialog.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Resumo do Mês',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'R\$ 5,00',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            Text('Saldo atual', style: TextStyle(color: Colors.grey)),
            // Aqui entrarão os gráficos e cards no futuro!
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const TransactionFormDialog(),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Nova Transação'),
      ),
    );
  }
}