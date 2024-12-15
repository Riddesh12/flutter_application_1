import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UssdDialer extends StatefulWidget {
  const UssdDialer({super.key});

  @override
  State<UssdDialer> createState() => _UssdDialerState();
}

class _UssdDialerState extends State<UssdDialer> {
  TextEditingController controller = TextEditingController();

  Future<void> ussdCode(String phone) async {
    final Uri launch = Uri(
      scheme: 'tel',
      path: phone,
    );
    await launchUrl(launch);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              TextField(
                controller: controller,
              ),
              ElevatedButton(
                  onPressed: () => ussdCode("*99*3*${controller.text.trim()}#"),
                  child: const Text("check balance")),
            ],
          ),
        ),
      ),
    );
  }
}
