import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/widgets/components/app_switch_tile.dart';
import '../../../../core/widgets/components/app_text_form_field.dart';
import '../../../../core/widgets/layouts/app_form.dart';
import '../../presentation/controller/transaction_form_controller.dart';

class TransactionFormDialog extends StatefulWidget {
  const TransactionFormDialog({super.key});

  @override
  State<TransactionFormDialog> createState() => _TransactionFormDialogState();
}

class _TransactionFormDialogState extends State<TransactionFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _dataController = TextEditingController();
  final _moneyValueController = MoneyMaskedTextController(
    decimalSeparator: ',',
    thousandSeparator: '.',
  );
  final _observationController = TextEditingController();
  final _finalMonthYearController = TextEditingController();

  DateTime? _selectedDate;
  bool _isPaid = true;
  bool _isFixed = false;
  bool _isUndeterminedFixed = true;

  Future<void> _selectDate(BuildContext context) async {
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
    _moneyValueController.dispose();
    _observationController.dispose();
    _finalMonthYearController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    // Parsing permanece na UI pois é responsabilidade do formulário
    // transformar input do usuário em dado estruturado
    final value =
        double.tryParse(
          _moneyValueController.text.replaceAll('.', '').replaceAll(',', '.'),
        ) ??
        0.0;

    final transactionDate = DateFormat(
      'dd/MM/yyyy',
    ).parse(_dataController.text);
    final finalMonthYear = _isUndeterminedFixed
        ? null
        : _finalMonthYearController.text;
    final observation = _observationController.text.isEmpty
        ? null
        : _observationController.text;

    await context.read<TransactionFormController>().save(
      value: value,
      categoryId: 'cat_provisoria_01',
      transactionDate: transactionDate,
      observation: observation,
      isFixed: _isFixed,
      isPaid: _isPaid,
      finalMonthYear: finalMonthYear,
    );

    if (!mounted) return;

    // UI reage ao estado do controller
    final controller = context.read<TransactionFormController>();
    if (controller.success) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transação registrada com sucesso!')),
      );
    }
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
            child: AppForm(
              isSubmitting: context.select<TransactionFormController, bool>(
                (c) => c.isSubmitting,
              ),
              error: context.select<TransactionFormController, String?>(
                (c) => c.error,
              ),
              submitLabel: 'Salvar',
              onSubmit: _handleSave,
              fields: [
                AppTextFormField(
                  controller: _moneyValueController,
                  label: 'Valor (R\$)',
                  icon: Icons.attach_money_sharp,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                AppTextFormField(
                  controller: _dataController,
                  label: 'Data de transação',
                  onTap: () => _selectDate(context),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'A data é obrigatória';
                    }
                    return null;
                  },
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
            if (_isUndeterminedFixed) _finalMonthYearController.clear();
          }),
        ),
        if (!_isUndeterminedFixed)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: AppTextFormField(
              controller: _finalMonthYearController,
              label: 'Mês/Ano Final',
            ),
          ),
      ],
    );
  }
}
