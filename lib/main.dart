import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'design/home_page.dart';
import 'design/scan_page.dart';
import 'design/send_page.dart';
import 'design/some_second_page.dart';
import 'design/transactions_page.dart';

void main() {
  // Initialize FFI for desktop platforms
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SomeSecondPage(),
      routes: {
        '/homepage': (context) => HomePage(),
        '/scanpage': (context) => ScanPage(),
        '/sendpage': (context) => SendPage(),
        '/somesecondpage': (context) => SomeSecondPage(),
        '/transactionspage': (context) => TransactionsPage(),
      },
    );
  }
}