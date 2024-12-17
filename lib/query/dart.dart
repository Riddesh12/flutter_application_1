import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';


const platform = MethodChannel('com.example.ussd');

Future<void> startUssdSession(String code) async {
  try {
    await platform.invokeMethod('sendUssdCode', {'code': code});
  } on PlatformException catch (e) {
    print("Failed to send USSD code: ${e.message}");
  }
}

void listenForUssdResponses() {
  platform.setMethodCallHandler((call) async {
    if (call.method == 'onUssdResponse') {
      String response = call.arguments;
      print("USSD Response: $response");
      // Display the response to the user and allow for further input
    }
  });
}

void main() {
  runApp(UssdApp());
}

class UssdApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UssdHomePage(),
    );
  }
}

class UssdHomePage extends StatefulWidget {
  @override
  _UssdHomePageState createState() => _UssdHomePageState();
}

class _UssdHomePageState extends State<UssdHomePage> {
  final TextEditingController _controller = TextEditingController();
  String _ussdResponse = "";

  @override
  void initState() {
    super.initState();
    listenForUssdResponses();
  }

  void sendUssd() async {
    PermissionStatus status = await Permission.phone.request();

    if (status.isGranted) {
      // Permission granted, proceed with the USSD code
      String ussdCode = _controller.text;
      await startUssdSession(ussdCode);
      listenForUssdResponses();
    } else {
      // Handle permission denial
      print('Permission denied');
    }
    simulateResponse();
  }

  void simulateResponse() {
    platform.invokeMethod('onUssdResponse', 'Simulated response');
  }


  void listenForUssdResponses() {
    print("asdf");
    platform.setMethodCallHandler((call) async {
      print("asdfsfdasda");
      if (call.method == 'onUssdResponse') {
        print("asdfasdfadsfadsf");
        setState(() {
          _ussdResponse = call.arguments;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('USSD App')),
      body: Column(
        children: [
          TextField(controller: _controller, decoration: InputDecoration(labelText: "Enter USSD Code")),
          ElevatedButton(onPressed: sendUssd, child: Text("Send USSD")),
          Text("Response: $_ussdResponse"),
        ],
      ),
    );
  }
}
