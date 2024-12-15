import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SyncManager {
  // Method to sync transactions
  static Future<void> syncTransactions() async {
    try {
      // Open the local database
      var db = await openDatabase('offline_transactions.db');

      // Fetch unsynced transactions from the database
      List<Map<String, dynamic>> transactions = await db.query(
        'transactions',
        where: 'synced = ?',
        whereArgs: [0], // Only fetch unsynced transactions
      );

      if (transactions.isEmpty) {
        print("No unsynced transactions found.");
        return;
      }

      // Iterate through transactions and send them to the server
      for (var transaction in transactions) {
        var response = await http.post(
          Uri.parse('https://example.com/sync'), // Replace with your server URL
          body: jsonEncode({
            'id': transaction['id'],
            'data': transaction['data'],
            // Add any other necessary data fields
          }),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          // Mark the transaction as synced in the local database
          await db.update(
            'transactions',
            {'synced': 1},
            where: 'id = ?',
            whereArgs: [transaction['id']],
          );
          print('Transaction ${transaction['id']} synced successfully.');
        } else {
          // Handle failure response if needed (e.g., retry logic)
          print(
              'Failed to sync transaction ${transaction['id']}. Server error: ${response.statusCode}');
        }
      }

      await db.close();
    } catch (e) {
      print('Error syncing transactions: $e');
    }
  }

  // Optional: Method to manually sync a specific transaction
  static Future<void> syncSingleTransaction(int transactionId) async {
    try {
      var db = await openDatabase('offline_transactions.db');
      List<Map<String, dynamic>> transaction = await db.query(
        'transactions',
        where: 'id = ?',
        whereArgs: [transactionId],
      );

      if (transaction.isEmpty) {
        print("Transaction $transactionId not found.");
        return;
      }

      var response = await http.post(
        Uri.parse('https://example.com/sync'), // Replace with your server URL
        body: jsonEncode({
          'id': transaction[0]['id'],
          'data': transaction[0]['data'],
          // Add any other necessary data fields
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Mark the transaction as synced in the local database
        await db.update(
          'transactions',
          {'synced': 1},
          where: 'id = ?',
          whereArgs: [transaction[0]['id']],
        );
        print('Transaction ${transaction[0]['id']} synced successfully.');
      } else {
        print(
            'Failed to sync transaction ${transaction[0]['id']}. Server error: ${response.statusCode}');
      }

      await db.close();
    } catch (e) {
      print('Error syncing transaction $transactionId: $e');
    }
  }

  // Optional: Retry logic in case of network issues
  static Future<void> retryFailedSync() async {
    try {
      var db = await openDatabase('offline_transactions.db');

      // Fetch transactions that failed to sync (e.g., status 'failed')
      List<Map<String, dynamic>> failedTransactions = await db.query(
        'transactions',
        where: 'synced = ?',
        whereArgs: [0], // Can filter for failed sync status if you have one
      );

      if (failedTransactions.isEmpty) {
        print("No failed transactions to retry.");
        return;
      }

      for (var transaction in failedTransactions) {
        var response = await http.post(
          Uri.parse('https://example.com/sync'), // Replace with your server URL
          body: jsonEncode({
            'id': transaction['id'],
            'data': transaction['data'],
          }),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          // Mark the transaction as synced in the local database
          await db.update(
            'transactions',
            {'synced': 1},
            where: 'id = ?',
            whereArgs: [transaction['id']],
          );
          print('Transaction ${transaction['id']} synced successfully.');
        } else {
          print(
              'Failed to sync transaction ${transaction['id']}. Server error: ${response.statusCode}');
        }
      }

      await db.close();
    } catch (e) {
      print('Error retrying failed transactions: $e');
    }
  }
}
