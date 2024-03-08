// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class BarcodeScreen extends StatefulWidget {
  const BarcodeScreen({super.key});

  @override
  _BarcodeScreenState createState() => _BarcodeScreenState();
}

class _BarcodeScreenState extends State<BarcodeScreen> {
  final _formKey = GlobalKey<FormState>();

  String scannedbar_code_scanner = 'No data';

  Future<void> scanBarcode() async {
    final result = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', // Background color
      'Cancel', // Cancel button text
      true, // Show flash icon
      ScanMode.BARCODE, // Scan mode (you can change to QR code if needed)
    );

    if (!mounted) return;

    setState(() {
      scannedbar_code_scanner = result;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BAR CODE')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                children: [
                  const Text(
                    'Scanned Barcode:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    scannedbar_code_scanner,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      scanBarcode(); // Trigger barcode scanning
                    },
                    icon: const Icon(Icons.camera_alt), // Camera icon
                    label: const Text('Scan Barcode'),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
