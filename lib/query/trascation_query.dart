import 'dart:async';

import 'package:offline/query/data.dart';
import 'package:offline/query/log_status.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';

class Transaction {
  bool isSmsReceived = false; // Variable to track specific message status.

  // Transaction check and add method
  void transactionCheckAndAdd(Map<String, dynamic> transaction) {
    // Use this method to handle the transaction based on received SMS data.
    requestPermission();/////direct call function without permission
    transaction['transaction_status'] = Variables.tranStatus;
    print(Variables.mapTransaction);
    LogStatus().writeJson(transaction, "transcation.json");
    // For now, just print the transaction
    Variables.tranStatus = "fail";
    ////// call log status here
    print('Transaction Details: $transaction');
  }

  // Request SMS permission
  Future<void> requestPermission() async {
    PermissionStatus status = await Permission.sms.request();
    if (status.isGranted) {
      getMessageTimeOut();
    } else {
      // Handle permission denied
      print('Permission denied');
    }
  }

  // Get message with timeout
  Future<void> getMessageTimeOut() async {
    try {
      // Set a timeout for the SMS query (15 seconds)
      await Future.delayed(Duration(seconds: 60));/////////
      var result = await Future.any([
        getParticularSMS().then((_) => 'success'), // Convert to return a value on success
        Future.delayed(const Duration(seconds: 15), () => 'timeout'),
      ]);

      if (result == 'timeout') {
        Variables.tranStatus = "failed";
      }
    } catch (e) {
      print("SMS error: ${e.toString()}");
    }
  }

  // Fetch a particular SMS message using flutter_sms_inbox
  Future<void> getParticularSMS() async {
    // Create an instance of SmsQuery
    SmsQuery query = SmsQuery();

    // Get all SMS in the inbox
    List<SmsMessage> messages = await query.getAllSms;

    // Example: Get a particular SMS by content or sender
    String targetContent = 'Sent';
    String targetSender = 'sent';

    // Loop through messages to find the one you need
    for (int i = 0; i < 5 && i < messages.length; i++) {
      SmsMessage message = messages[i];
      if (message.body!.contains(targetContent) || message.body!.contains(targetSender)) {
        print('Found message: ${message.body}');
        print('Sender: ${message.sender}');
        Variables.tranStatus = "completed";
        break; // Exit loop if you find the message
      }
    }
  }
}
