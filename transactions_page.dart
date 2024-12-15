import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  List<Map<String, dynamic>> transactions = [];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    // Get the application documents directory
    final directory = await getApplicationDocumentsDirectory();
    final path =
        '${directory.path}/offline_transactions.db'; // Set path for the database file

    // Open the database
    var db = await openDatabase(path);

    // Query the database
    List<Map<String, dynamic>> result = await db.query('transactions');
    await db.close();

    setState(() {
      transactions = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: transactions.isEmpty
          ? const Center(child: Text('No transactions found'))
          : ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                var transaction = transactions[index];
                return ListTile(
                  title: Text('Transaction: ${transaction['data']}'),
                  subtitle: Text(
                      'Status: ${transaction['synced'] == 1 ? 'Synced' : 'Pending'}'),
                );
              },
            ),
    );
  }
}
