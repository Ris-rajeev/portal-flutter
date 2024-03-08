// ignore_for_file: use_build_context_synchronously

import 'package:authsec_flutter/screens/QrBarCode/Barcode/Barcode_create_entity_screen.dart';
import 'package:authsec_flutter/screens/QrBarCode/Qrcode/Qrcode_create_entity_screen.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:barcode_widget/barcode_widget.dart';

class QrBarCodeScreen extends StatefulWidget {
  const QrBarCodeScreen({super.key});

  @override
  _QrBarCodeScreenState createState() => _QrBarCodeScreenState();
}

class _QrBarCodeScreenState extends State<QrBarCodeScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController qr_code_dataController = TextEditingController();

  // Function to show the QR code in a dialog
  void _showqr_code_dataDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Generated QR Code'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 200, // Set a fixed width for the QR code
                height: 200, // Set a fixed height for the QR code
                child: QrImageView(
                  data: qr_code_dataController.text,
                  version: QrVersions.auto,
                  embeddedImageStyle:
                      const QrEmbeddedImageStyle(size: Size(100, 100)),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  TextEditingController bar_code_dataController = TextEditingController();

  // Function to show the barcode in a dialog
  void _show_bar_code_dataDialog(String barcodeData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Generated Bar Code'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                color: Colors.white,
                elevation: 6,
                shadowColor: Colors.amber,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: BarcodeWidget(
                    data: barcodeData,
                    barcode: Barcode.code128(),
                    color: Colors.black,
                    width: 200,
                    height: 100,
                    drawText: false,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR AND BAR CODE')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // GENERATE QR CODE
                TextFormField(
                  controller: qr_code_dataController,
                  decoration: const InputDecoration(labelText: 'qr_code_data'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                    onPressed: () {
                      _showqr_code_dataDialog();
                    },
                    child: const Text('Generate Qr')),

                // GENERATE BAR CODE
                TextFormField(
                  controller: bar_code_dataController,
                  decoration: const InputDecoration(labelText: 'Bar Code Data'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _show_bar_code_dataDialog(bar_code_dataController.text);
                  },
                  child: const Text('Generate Bar code'),
                ),
//  QR CODE SCANNER

                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const qrcodeScreen()));
                  },
                  child: const Text('QR Code Scanner'),
                ),
// BAR CODE SCANNER

                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BarcodeScreen()));
                  },
                  child: const Text('Bar Code Scanner'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
