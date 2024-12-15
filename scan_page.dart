import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String scannedResult =
      "No QR code scanned yet"; // For displaying scanned result

  // Updated the function signature to match the expected callback
  void _onBarcodeDetect(BarcodeCapture barcodeCapture) {
    final barcode = barcodeCapture.barcodes.first;
    final String? code = barcode.rawValue;

    if (code != null) {
      setState(() {
        scannedResult = code;
      });
      // Optionally, you can navigate or perform other actions with the scanned result.
      print("QR Code Scanned: $code");
    } else {
      setState(() {
        scannedResult = "No valid QR code detected.";
      });
    }
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
            child: Container(
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
          ),
        ],
      ),
    );
  }
}
