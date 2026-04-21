import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'features/transaction/di/transaction_di.dart';
import 'navigation/main_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final transactionProviders = await TransactionDI.providers();

  runApp(MyApp(providers: transactionProviders));
}

class MyApp extends StatelessWidget {
  final List<SingleChildWidget> providers;

  const MyApp({super.key, required this.providers});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        title: 'Soma',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blueGrey),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('pt', 'BR'), Locale('en', 'US')],
        home: const Scaffold(body: MainLayout()),
      ),
    );
  }
}
