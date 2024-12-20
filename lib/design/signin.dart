import 'package:flutter/material.dart';
import 'package:offline/design/home_page.dart';
import 'package:offline/query/log_status.dart';
import 'package:offline/query/ussd.dart';

class LogInState extends StatefulWidget {
  const LogInState({super.key});

  @override
  State<LogInState> createState() => _LogInStateState();
}

class _LogInStateState extends State<LogInState> {

  String str = "Name: SANYAM KATARIYA\nUPI ID: 8852992xxx@upi\nBank Account Linked: HDFC BANK\n UPI PIN SET";

  Future<void> login(BuildContext context) async {
    UssdQuery.sendUssdCode("*99*4*3#");
    UssdQuery.listenForUssdResponse((onResponse){
      LogStatus().enterDetails(onResponse.isEmpty?str:onResponse);////enter profile detail
    });
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const HomePage()));
  }

  Future<void> checkPage() async {
    if(!await LogStatus().fileIsEmpty('profile.json')||!await LogStatus().fileIsEmpty('registered.json')){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomePage()));
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    checkPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  login(context);
                  LogStatus().writeJson({"true":true}, "registered.json");
                },
                child: Text("resigtered")),
            SizedBox(height: 25,),
            ElevatedButton(
                onPressed: () {
                  UssdQuery.sendUssdCode("*99#");
                  login(context);
                  LogStatus().writeJson({"true":true}, "registered.json");
                },
                child: Text("Not Registered")),
          ],
        ),
      ),
    );
  }
}
