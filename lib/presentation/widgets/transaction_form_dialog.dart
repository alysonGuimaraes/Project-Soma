import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';
import 'package:project_soma/Presentation/Widgets/app_switch_tile.dart';

import '../controllers/transaction_controller.dart';
import 'app_text_form_field.dart';

class TransactionFormDialog extends StatefulWidget {
  final TransactionController transactionController;

  const TransactionFormDialog({super.key, required this.transactionController});

  @override
  State<TransactionFormDialog> createState() => _TransactionFormDialogState();
}

class _TransactionFormDialogState extends State<TransactionFormDialog> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _dataController = TextEditingController();
  DateTime? _selectedDate;

  // Controladores dos campos de texto
  final _valueController = TextEditingController();
  final _moneyValueController = MoneyMaskedTextController(
    decimalSeparator: ',',
    thousandSeparator: '.',
  );
  final _observationController = TextEditingController();
  final _finalMonthYearController = TextEditingController();

  // Variáveis de estado (Checkboxes/Switches)
  bool _isPaid = true;
  bool _isFixed = false;
  bool _isUndeterminedFixed = true;

  Future<void> _selectData(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('pt', 'BR'),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dataController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  void dispose() {
    _dataController.dispose();
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
        width: 400,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextFormField(
                  controller: _moneyValueController,
                  label: 'Valor (R\$)',
                  icon: Icons.attach_money_sharp,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                AppTextFormField(
                  controller: _dataController,
                  label: 'data de transação',
                  readOnly: true,
                  onTap: () => _selectData(context),
                ),
                const SizedBox(height: 16),

                AppTextFormField(
                  controller: _observationController,
                  label: 'Observação (Opcional)',
                ),
                const SizedBox(height: 16),

                AppSwitchTile(
                  title: 'Já foi pago/recebido?',
                  value: _isPaid,
                  onChanged: (val) => setState(() => _isPaid = val),
                ),

                AppSwitchTile(
                  title: 'É uma transação fixa?',
                  value: _isFixed,
                  onChanged: (val) => setState(() {
                    _isFixed = val;
                    if (!val) _isUndeterminedFixed = true;
                  }),
                ),

                _buildFixedSection(),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),

        FilledButton(onPressed: _handleSave, child: const Text('Salvar')),
      ],
    );
  }

  Widget _buildFixedSection() {
    if (!_isFixed) return const SizedBox();

    return Column(
      children: [
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
        if (!_isUndeterminedFixed)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TextFormField(
              controller: _finalMonthYearController,
              decoration: const InputDecoration(
                labelText: 'Mês/Ano Final',
                border: OutlineInputBorder(),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final value =
        double.tryParse(
          _moneyValueController.text.replaceAll('.', '').replaceAll(',', '.'),
        ) ??
        0.0;

    final finalMonth = _isUndeterminedFixed
        ? null
        : _finalMonthYearController.text;

    try {
      await widget.transactionController.saveNewTransaction(
        value: value,
        categoryId: 'cat_provisoria_01',
        transactionDate: DateFormat('dd/MM/yyyy').parse(_dataController.text),
        observation: _observationController.text.isEmpty
            ? null
            : _observationController.text,
        isFixed: _isFixed,
        isPaid: _isPaid,
        finalMonthYear: finalMonth,
      );

      if (!mounted) return;

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transação registrada com sucesso!')),
      );
    } catch (e) {
      print(e);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
