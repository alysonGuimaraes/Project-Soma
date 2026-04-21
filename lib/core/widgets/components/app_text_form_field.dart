import 'package:flutter/material.dart';

class AppTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData? icon;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const AppTextFormField({
    super.key,
    required this.controller,
    required this.label,
    this.icon,
    this.readOnly = false,
    this.onTap,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      onTap: onTap,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: icon != null ? Icon(icon) : null,
        suffixIcon: readOnly ? const Icon(Icons.calendar_today) : null,
      ),
    );
  }
}
