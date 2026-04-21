import 'package:flutter/material.dart';

class AppLoadingIndicator extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const AppLoadingIndicator({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading) const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
