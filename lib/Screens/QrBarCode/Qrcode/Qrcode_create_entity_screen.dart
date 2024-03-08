// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class qrcodeScreen extends StatefulWidget {
  const qrcodeScreen({super.key});

  @override
  _qrcodeScreenState createState() => _qrcodeScreenState();
}

class _qrcodeScreenState extends State<qrcodeScreen> {
  final _formKey = GlobalKey<FormState>();

  String scannedqr_code_scanner = 'No data';

  Future<void> scanQRcode() async {
    final result = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', // Background color
      'Cancel', // Cancel button text
      true, // Show flash icon
      ScanMode.QR, // Scan mode (you can change to QR code if needed)
    );

    if (!mounted) return;

    setState(() {
      scannedqr_code_scanner = result;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Code')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                children: [
                  const Text(
                    'Scanned QRcode:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    scannedqr_code_scanner,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      scanQRcode(); // Trigger barcode scanning
                    },
                    icon: const Icon(Icons.camera_alt), // Camera icon
                    label: const Text('Scan QRcode'),
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
