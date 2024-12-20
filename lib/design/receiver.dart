import 'package:flutter/material.dart';

class Receiver extends StatefulWidget {
  const Receiver({super.key});

  @override
  State<Receiver> createState() => _ReceiverState();
}

class _ReceiverState extends State<Receiver> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Only OFFPay user"),
              Image.asset(
                'assest/qr.jpg',
                width: 400,
                height: 700,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
