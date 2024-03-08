import 'package:flutter/material.dart';

class AccessibilitySelectionScreen extends StatefulWidget {
  @override
  _AccessibilitySelectionScreenState createState() =>
      _AccessibilitySelectionScreenState();
}

class _AccessibilitySelectionScreenState
    extends State<AccessibilitySelectionScreen> {
  String? selectedAccessibility;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Accessibility'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RadioListTile<String>(
              title: const Text('Public'),
              value: 'false',
              groupValue: selectedAccessibility,
              onChanged: (value) {
                setState(() {
                  selectedAccessibility = value;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Private'),
              value: 'true',
              groupValue: selectedAccessibility,
              onChanged: (value) {
                setState(() {
                  selectedAccessibility = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, selectedAccessibility);
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
