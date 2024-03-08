import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bookmark App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BookmarkPage(),
    );
  }
}

class BookmarkPage extends StatefulWidget {
  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  GlobalKey _screenshotKey = GlobalKey();

  String _currentLink = "https://example.com";
  Image? _screenshotImage; // Store the captured screenshot image

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmark Page'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Current Link: $_currentLink',
                style: TextStyle(fontSize: 18),
              ),
            ),
            RepaintBoundary(
              key: _screenshotKey,
              child: Container(
                color: Colors.white,
                height: 300,
                child: Center(
                  child: _screenshotImage,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => _takeScreenshot(),
              child: Text('Take Screenshot'),
            ),
            ElevatedButton(
              onPressed: () => _bookmarkPage(_currentLink),
              child: Text('Bookmark Page'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _takeScreenshot() async {
    RenderRepaintBoundary boundary =
    _screenshotKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    final buffer = byteData!.buffer.asUint8List();

    setState(() {
      _screenshotImage = Image.memory(
        buffer,
        fit: BoxFit.cover, // You can adjust this property as needed
      );
    });
    // You can share the screenshot here if needed
  }

  void _bookmarkPage(String link) {
    // Implement bookmarking logic here
    // For demonstration purposes, we'll just print the link
    print('Bookmarking page: $link');
  }
}
