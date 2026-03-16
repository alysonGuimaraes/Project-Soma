
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';

import '../../Data/Database/Database_Service.dart';
import '../../Data/Repositories/TransactionRepositoryImpl.dart';
import '../Controllers/TransactionController.dart';

class TransactionFormDialog extends StatefulWidget {
  const TransactionFormDialog({super.key});

  @override
  State<TransactionFormDialog> createState() => _TransactionFormDialogState();
}

class _TransactionFormDialogState extends State<TransactionFormDialog> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _controllerData = TextEditingController();
  DateTime? _selectedDate;

  // Controladores dos campos de texto
  final _valueController = TextEditingController();
  final _moneyValueController = MoneyMaskedTextController(
      decimalSeparator: ',',
      thousandSeparator: '.'
  );
  final _observationController = TextEditingController();
  final _finalMonthYearController = TextEditingController();

  // Variáveis de estado (Checkboxes/Switches)
  bool _isPaid = true;
  bool _isFixed = false;
  bool _isUndeterminedFixed = true; // O seu novo controle visual

  Future<void> _selectData(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('pt', 'BR'), // Configura para português
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        // Formata a data: dd/MM/yyyy
        _controllerData.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  void dispose() {
    _controllerData.dispose();
    _valueController.dispose();
    _moneyValueController.dispose();
    _observationController.dispose();
    _finalMonthYearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nova Transação'),
      content: SizedBox(
        width: 400, // Largura fixa ideal para Desktop
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [

                // Campo de Valor
                TextFormField(
                  controller: _moneyValueController,
                  decoration: const InputDecoration(
                    labelText: 'Valor (R\$)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.attach_money_sharp),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _controllerData,
                  readOnly: true, // Impede o usuário de digitar
                  decoration: InputDecoration(
                    labelText: 'Data de Nascimento',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () => _selectData(context), // Abre o calendário
                ),

                // Campo de Observação (Opcional)
                TextFormField(
                  controller: _observationController,
                  decoration: const InputDecoration(
                    labelText: 'Observação (Opcional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Switches de Estado Simples
                SwitchListTile(
                  title: const Text('Já foi pago/recebido?'),
                  value: _isPaid,
                  onChanged: (val) => setState(() => _isPaid = val),
                ),
                SwitchListTile(
                  title: const Text('É uma transação fixa?'),
                  value: _isFixed,
                  onChanged: (val) => setState(() {
                    _isFixed = val;
                    // Se desmarcar o fixo, reseta o estado do indeterminado
                    if (!val) _isUndeterminedFixed = true;
                  }),
                ),

                // Novos campos condicionais (Só aparecem se for Fixo)
                if (_isFixed) ...[
                  const Divider(),
                  CheckboxListTile(
                    title: const Text('Tempo indeterminado (Assinatura)'),
                    value: _isUndeterminedFixed,
                    onChanged: (val) => setState(() {
                      _isUndeterminedFixed = val ?? true;
                      if (_isUndeterminedFixed) {
                        _finalMonthYearController.clear();
                      }
                    }),
                  ),
                  // Só mostra o campo de Mês Final se NÃO for indeterminado
                  if (!_isUndeterminedFixed)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: TextFormField(
                        controller: _finalMonthYearController,
                        decoration: const InputDecoration(
                          labelText: 'Mês/Ano Final (ex: 12/2026)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // Fecha o modal
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () async {
            // Valida se os campos obrigatórios estão preenchidos
            if (_formKey.currentState!.validate()) {

              // 1. Instanciar as dependências (numa app maior, usaríamos injecção de dependências)
              final db = await DatabaseService().database;
              final repository = TransactionRepositoryImpl(db);
              final controller = TransactionController(repository);

              // 2. Tentar converter o valor introduzido para número (Double)
              final double value = double.tryParse(_moneyValueController.text.replaceAll(',', '.')) ?? 0.0;

              // 3. Definir o Mês Final (nulo se for indeterminado)
              final String? finalMonth = _isUndeterminedFixed ? null : _finalMonthYearController.text;

              try {
                // 4. Chamar o controlador para gravar
                await controller.saveNewTransaction(
                  value: value,
                  categoryId: 'cat_provisoria_01', // Ainda vamos criar o menu de categorias!
                  observation: _observationController.text.isEmpty ? null : _observationController.text,
                  isFixed: _isFixed,
                  isPaid: _isPaid,
                  finalMonthYear: finalMonth,
                );

                // 5. Se correr bem, fecha o modal e avisa o utilizador
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Transação registada com sucesso!')),
                  );
                }
              } catch (e) {
                print('🚨 ERRO AO SALVAR NO BANCO: $e');
                // Se houver um erro no SQLite, mostra um alerta
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao gravar: $e'), backgroundColor: Colors.red),
                  );
                }
              }
            }
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
