import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../transaction/presentation/controllers/transaction_form_controller.dart';
import '../../../transaction/presentation/widgets/transaction_form_dialog.dart';

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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog(
          context: context,
          builder: (dialogContext) => ChangeNotifierProvider.value(
            // Passa o controllers já existente para dentro do dialog
            value: context.read<TransactionFormController>(),
            child: const TransactionFormDialog(),
          ),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Nova Transação'),
      ),
    );
  }
}
