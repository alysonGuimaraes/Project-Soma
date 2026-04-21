import 'package:flutter/material.dart';

import '../errors/app_error_message.dart';
import '../states/app_empty_state.dart';

class AppList<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(T item) itemBuilder;
  final bool isLoading;
  final String? error;
  final String emptyMessage;
  final VoidCallback? onRetry;

  const AppList({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.emptyMessage,
    this.isLoading = false,
    this.error,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (error != null) return AppErrorMessage(error: error, onRetry: onRetry);
    if (items.isEmpty) return AppEmptyState(message: emptyMessage);

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (_, index) => Card(child: itemBuilder(items[index])),
    );
  }
}
