import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/formatters/monetary_formatter.dart';
import '../../../../core/widgets/layouts/app_form.dart';
import '../../presentation/controllers/transaction_form_controller.dart';

class TransactionFormDialog extends StatefulWidget {
  const TransactionFormDialog({super.key});

  @override
  State<TransactionFormDialog> createState() => _TransactionFormDialogState();
}

class _TransactionFormDialogState extends State<TransactionFormDialog> {
  bool _isFixed = false;
  bool _isUndeterminedFixed = true;

  @override
  void dispose() {
    super.dispose();
  }

  void _handleSubmit(Map<String, dynamic> data) async {
    await context.read<TransactionFormController>().save(
      value: data['value'] as double,
      categoryId: 'cat_provisoria_01',
      transactionDate: data['transactionDate'] as DateTime,
      observation: (data['observation'] as String?)?.isEmpty == true
          ? null
          : data['observation'] as String?,
      isFixed: data['isFixed'] as bool,
      isPaid: data['isPaid'] as bool,
      finalMonthYear: data['finalMonthYear'] as String?,
    );

    if (!mounted) return;

    final controller = context.read<TransactionFormController>();
    if (controller.success) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transação registrada com sucesso!')),
      );
    }
  }

  DateTime _parseDate(String date) {
    final parts = date.split('/');
    return DateTime(
      int.parse(parts[2]),
      int.parse(parts[1]),
      int.parse(parts[0]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Selector<TransactionFormController, (bool, String?)>(
        selector: (_, c) => (c.isSubmitting, c.error),
        builder: (_, state, _) {
          final (_, _) = state;

          return AppForm(
            title: 'Nova Transação',
            width: 400,
            onClose: () => Navigator.of(context).pop(),
            onSubmit: _handleSubmit,
            sections: [
              AppFormSection(
                title: 'Dados da Transação',
                rows: [
                  // Valor
                  AppFormRow(
                    fields: [
                      AppFormField(
                        id: 'value',
                        label: 'Valor (R\$)',
                        type: AppFieldType.number,
                        formatters: [MonetaryFormatter()],
                        isRequired: true,
                        isRequiredMessage: 'Valor da transação é obrigatório',
                        prefixIcon: Icon(Icons.attach_money_outlined),
                      ),
                    ],
                  ),

                  // Data
                  AppFormRow(
                    fields: [
                      AppFormField(
                        id: 'transactionDate',
                        label: 'Data de transação',
                        normalizer: (value) => _parseDate(value),
                        type: AppFieldType.date,
                        isRequired: true,
                      ),
                    ],
                  ),

                  // Observação
                  AppFormRow(
                    fields: [
                      AppFormField(
                        id: 'observation',
                        label: 'Observação (Opcional)',
                        type: AppFieldType.text,
                      ),
                    ],
                  ),
                ],
              ),

              AppFormSection(
                title: 'Configurações',
                rows: [
                  // isPaid
                  AppFormRow(
                    fields: [
                      AppFormField(
                        id: 'isPaid',
                        label: 'Já foi pago/recebido?',
                        type: AppFieldType.boolean,
                        initialValue: true,
                        triggersVisibilityRebuild: false,
                      ),
                    ],
                  ),

                  // isFixed
                  AppFormRow(
                    fields: [
                      AppFormField(
                        id: 'isFixed',
                        label: 'É uma transação fixa?',
                        type: AppFieldType.boolean,
                        initialValue: false,
                        triggersVisibilityRebuild: true,
                        onChanged: (val) => setState(() {
                          _isFixed = val as bool;
                          if (!_isFixed) _isUndeterminedFixed = true;
                        }),
                      ),
                    ],
                  ),
                ],
              ),

              // Seção de transação fixa — só aparece quando isFixed = true
              AppFormSection(
                title: 'Configurações de Recorrência',
                rows: [
                  AppFormRow(
                    fields: [
                      AppFormField(
                        id: 'isUndeterminedFixed',
                        label: 'Tempo indeterminado (Assinatura)',
                        type: AppFieldType.boolean,
                        initialValue: true,
                        isVisible: () => _isFixed,
                        triggersVisibilityRebuild: true,
                        onChanged: (val) => setState(() {
                          _isUndeterminedFixed = val as bool;
                        }),
                      ),
                    ],
                  ),
                  AppFormRow(
                    fields: [
                      AppFormField(
                        id: 'finalMonthYear',
                        label: 'Mês/Ano Final',
                        type: AppFieldType.text,
                        isVisible: () => _isFixed && !_isUndeterminedFixed,
                        isRequired: true,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
