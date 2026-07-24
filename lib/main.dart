import 'package:flutter/material.dart';
import 'package:project_soma/core/di/container/injection_container.dart';

import 'navigation/main_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupDependencies();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Soma',
      debugShowCheckedModeBanner: false,
      home: const Scaffold(body: MainLayout()),
    );
  }
}
