import 'package:flutter/material.dart';
import 'package:offline/design/home_page.dart';
import 'package:offline/query/log_status.dart';
import 'package:offline/query/ussd.dart';
import 'package:ussd_advanced/ussd_advanced.dart';

class LogInState extends StatefulWidget {
  const LogInState({super.key});

  @override
  State<LogInState> createState() => _LogInStateState();
}

class _LogInStateState extends State<LogInState> {
  TextEditingController country = TextEditingController();
  bool visible = false;

  Future<void> login(BuildContext context) async {
    String? resp = await UssdAdvanced.sendAdvancedUssd(code: "*99*4*3#");
    if (resp!.isNotEmpty) {
      LogStatus().enterDetails(resp);////enter profile detail
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  login(context);
                },
                child: Text("resigtered")),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    visible = true;
                  });
                },
                child: Text("Not Registered")),
            Visibility(
              visible: visible,
              child: TextField(
                controller: country,
                decoration: const InputDecoration(
                  label: Text("Enter bank name(only in 4 words)"),
                ),
              ),
            ),
            Visibility(
              visible: visible,
              child: ElevatedButton(
                onPressed: () async {
                  UssdQuery.sendUssdCode("*99*${country.text.trim()}#");
                  login(context);
                },
                child: const Text("Enter"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
