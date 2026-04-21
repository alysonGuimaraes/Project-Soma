import 'package:flutter/material.dart';

import '../../../transaction/di/dependency_injection.dart';
import '../../../transaction/presentation/widgets/transaction_form_dialog.dart';
import '../../../transaction/service/transaction_service.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  // Todo: Carregamento e atualização saldos do dashboard

  // Todo: Criação de gráficos

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
          final transactionService = await getIt.getAsync<TransactionService>();

          if (!context.mounted) return;

          showDialog(
            context: context,
            builder: (_) =>
                TransactionFormDialog(transactionService: transactionService),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Nova Transação'),
      ),
    );
  }
}
