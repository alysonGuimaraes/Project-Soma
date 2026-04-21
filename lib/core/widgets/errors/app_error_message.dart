import 'package:flutter/material.dart';

class AppErrorMessage extends StatelessWidget {
  final String? error;
  final VoidCallback? onRetry;

  const AppErrorMessage({super.key, this.error, this.onRetry});

  @override
  Widget build(BuildContext context) {
    if (error == null) return const SizedBox.shrink();
    return Column(
      children: [
        Text(error!, style: const TextStyle(color: Colors.red)),
        if (onRetry != null)
          TextButton(onPressed: onRetry, child: const Text('Tentar novamente')),
      ],
    );
  }
}
