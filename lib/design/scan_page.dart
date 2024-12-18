import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:offline/query/data.dart';
import 'package:offline/query/trascation_query.dart';
import 'package:offline/query/ussd.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String scannedResult =
      "No QR code scanned yet"; // For displaying scanned result
  TextEditingController amount = TextEditingController();
  bool visible = false;

  // Updated the function signature to match the expected callback
  void _onBarcodeDetect(BarcodeCapture barcodeCapture) {
    final barcode = barcodeCapture.barcodes.first;
    final String? code = barcode.rawValue;

    if (code != null) {
      setState(() {
        scannedResult = code;
        Variables.payTo=scannedResult;
        visible = true;
      });
      //extractUpiId(scannedResult);
      // Optionally, you can navigate or perform other actions with the scanned result.
      print("QR Code Scanned: $code");
    } else {
      setState(() {
        scannedResult = "No valid QR code detected.";
        Variables.payTo = "";
      });
    }
  }

  void extractUpiId(String upiUrl) {
    // Parse the UPI URL
    Uri uri = Uri.parse(upiUrl);

    // Extract the 'pa' parameter from the query
    String? upiId = uri.queryParameters['pa'];

    Variables.payTo = upiId ?? "";
    print(Variables.payTo);
    setState(() {
      scannedResult=upiId??"not changed$scannedResult";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: MobileScanner(
              onDetect: _onBarcodeDetect, // Callback function
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      scannedResult,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Visibility(
                  visible: visible,
                  child: TextField(
                    controller: amount,
                  ),
                ),
                Visibility(
                    visible: visible,
                    child: ElevatedButton(
                        onPressed: () {
                          ////////enter the transaction code here and check transaction status here
                          UssdQuery.sendUssdCode(
                              "*99*1*1*${Variables.payTo}*${amount.text.trim()}*1#");
                          Variables.mapTransaction = {
                            "payto": Variables.payTo,
                            "amount": amount,
                            "time": DateTime.now(),
                            "location": "",
                            "status": Variables.tranStatus,
                            "remark": "1",
                          };
                          Transaction();
                        },
                        child: Text("Pay")
                    )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
