import 'dart:async';

import 'package:flutter/material.dart';
import 'package:money_manager/providers/transaction_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:money_manager/screens/home_screen.dart';
import 'package:provider/provider.dart';

import 'generated/l10n.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final transactionProvider = TransactionProvider();
  await transactionProvider.initializeDB();
  runApp(
    ChangeNotifierProvider(
      create: (context) => transactionProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Manager',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.amber,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.amber,
          elevation: 0,
          centerTitle: true
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.amber
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.amber)
          )
        )
      ),
      home: const HomeScreen(),
    );
  }
}
