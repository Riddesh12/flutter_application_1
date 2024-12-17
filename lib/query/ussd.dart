import 'package:offline/query/data.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';


class UssdQuery{
  Future<void> permission() async {
    PermissionStatus status = await Permission.phone.request();

    if (status.isGranted) {
      print("object");
      // Permission granted, proceed with the USSD code
      Variables.permission=true;
    } else {
      // Handle permission denial
      print('Permission denied');
      Variables.permission=false;
    }
  }
  static const platform = MethodChannel('com.example.ussd');

  // Function to send a USSD code
  static Future<void> sendUssdCode(String ussdCode) async {
    try {
      final String response = await platform.invokeMethod('sendUssdCode', {"code": ussdCode});
      print("USSD Request: $response");
    } catch (e) {
      print("Failed to send USSD code: $e");
    }
  }

  // Listener for incoming USSD responses
  static void listenForUssdResponse(Function(String) onResponse) {
    platform.setMethodCallHandler((call) async {
      if (call.method == "onUssdResponse") {
        onResponse(call.arguments);
      }
    });
  }
}

