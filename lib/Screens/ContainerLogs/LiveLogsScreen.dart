import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../resources/api_constants.dart';

class LiveLogsScreen extends StatefulWidget {
  final String containerName;

  const LiveLogsScreen({Key? key, required this.containerName})
      : super(key: key);

  @override
  _LiveLogsScreenState createState() => _LiveLogsScreenState();
}

class _LiveLogsScreenState extends State<LiveLogsScreen> {
  final Dio dio = Dio();
  final String baseUrl = ApiConstants.baseUrl;

  String logs = '';
  Timer? timer; // Add a timer variable
  bool disposed = false; // Track if the widget has been disposed

  void fetchLogs() async {
    if (disposed) {
      // Check if the widget has been disposed
      return;
    }
    var contName = widget.containerName;
    print('container name is $contName');
    try {
      final response = await dio.get(
        'http://13.233.70.96:30168/script/executeCommandtest?privateKey=/usr/app&command=docker logs $contName',
      );
      if (response.statusCode == 200) {
        setState(() {
          logs = response.data.join("\n"); // Set logs to the new response
        });
      }
    } catch (e) {
      print('Error fetching logs: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    // Refresh logs every 15 seconds
    const duration = Duration(seconds: 10);
    Timer.periodic(duration, (Timer t) {
      // Clear logs before fetching new ones
      setState(() {
        logs = '';
      });
      fetchLogs();
    });
  }

  @override
  void dispose() {
    disposed = true; // Mark the widget as disposed
    // Cancel the timer when the widget is disposed
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Logs'),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            logs,
            style: const TextStyle(color: Colors.green),
          ),
        ),
      ),
    );
  }
}
