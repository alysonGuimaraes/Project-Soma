import 'package:flutter/cupertino.dart';

import '../components/async_button.dart';
import '../errors/app_error_message.dart';

class AppForm extends StatelessWidget {
  final List<Widget> fields;
  final bool isSubmitting;
  final String? error;
  final VoidCallback? onSubmit;
  final String submitLabel;

  const AppForm({
    super.key,
    required this.fields,
    required this.onSubmit,
    this.isSubmitting = false,
    this.error,
    this.submitLabel = 'Salvar',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...fields, // ← a feature define quais campos existem
        AppErrorMessage(error: error),
        AsyncButton(
          isLoading: isSubmitting,
          label: submitLabel,
          onPressed: onSubmit,
        ),
      ],
    );
  }
}
