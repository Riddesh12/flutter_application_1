import 'package:flutter/material.dart';
import 'dart:async';

class SomeSecondPage extends StatefulWidget {
  const SomeSecondPage({super.key});

  @override
  State<SomeSecondPage> createState() => _SomeSecondPageState();
}

class _SomeSecondPageState extends State<SomeSecondPage> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/signin');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assest/images.jpg',
          width: 300,
          height: 700,
        ),
      ),
    );
  }
}
