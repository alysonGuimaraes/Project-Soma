import 'package:flutter/cupertino.dart';

class AppEmptyState extends StatelessWidget {
  final String message;
  final IconData? icon;

  const AppEmptyState({super.key, required this.message, this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [if (icon != null) Icon(icon, size: 48), Text(message)],
      ),
    );
  }
}
