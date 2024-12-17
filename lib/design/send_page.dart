import 'package:flutter/material.dart';
import 'package:offline/query/ussd.dart';

class SendPage extends StatelessWidget {
  const SendPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Controllers for the input fields
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController amountController = TextEditingController();
    final TextEditingController remarkController = TextEditingController();

    String onResponse = "";

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
                onPressed: () {
                  UssdQuery.sendUssdCode("*99*3#");
                  UssdQuery.listenForUssdResponse((onResponse) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(onResponse)),
                    );
                  });
                },
                child: const Text("Check Amount")),
            SizedBox(height: 16),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),
            TextField(
              controller: amountController,
              decoration: InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            TextField(
              controller: remarkController,
              decoration: InputDecoration(
                labelText: 'Remark (if not enter 1)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.feedback),
              ),
            ),
            SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Fetch values from the controllers
                  String phone = phoneController.text;
                  String amount = amountController.text;
                  String remark = remarkController.text;
                  // Simple validation
                  if (phone.isEmpty || amount.isEmpty || remark.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill all the fields')),
                    );
                  } else {
                    UssdQuery.sendUssdCode(
                        "*99*1*1*${phoneController.text.trim()}*${amountController.text.trim()}*${remarkController.text.trim()}#");
                    UssdQuery.listenForUssdResponse((onResponse) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(onResponse)),
                      );
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: Text('Pay'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
