
import 'package:flutter/material.dart';
import 'package:project_soma/Presentation/Controllers/transaction_controller.dart';

import '../../Data/data_dependency_injection_config.dart';
import '../Widgets/transaction_form_dialog.dart';

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
        onPressed: () async {
          final transactionController = await getIt.getAsync<TransactionController>();

          showDialog(
            context: context,
            builder: (_) => TransactionFormDialog(transactionController: transactionController),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Nova Transação'),
      ),
    );
  }
}