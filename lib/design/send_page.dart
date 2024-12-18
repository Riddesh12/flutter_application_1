import 'package:flutter/material.dart';
import 'package:offline/query/data.dart';
import 'package:offline/query/trascation_query.dart';
import 'package:offline/query/ussd.dart';

class SendPage extends StatelessWidget {
  const SendPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Controllers for the input fields
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController amountController = TextEditingController();
    final TextEditingController remarkController = TextEditingController();

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
                labelText: 'Remark (optional)',
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
                  String remark = remarkController.text.isEmpty
                      ? "1"
                      : remarkController.text.trim();
                  // Simple validation
                  if (phone.isEmpty || amount.isEmpty || remark.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill all the fields')),
                    );
                  } else {
                    UssdQuery.sendUssdCode(
                        "*99*1*1*${phoneController.text.trim()}*${amountController.text.trim()}*$remark#");
                    Variables.mapTransaction = {
                      "payto": phoneController.text.trim(),
                      "amount": amountController.text.trim(),
                      "time": DateTime.now(),
                      "location": "",
                      "status": Variables.tranStatus,
                      "remark": remark
                    };
                    Transaction()
                        .transactionCheckAndAdd(Variables.mapTransaction);
                    UssdQuery.listenForUssdResponse((onResponse) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(onResponse)),
                      );
                    });
                    /////enter transaction code here and check transaction status
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
