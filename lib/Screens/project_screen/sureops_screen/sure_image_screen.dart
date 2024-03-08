// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import '../../../providers/token_manager.dart';
import '../../../resources/api_constants.dart';

class SureImageContent extends StatefulWidget {
  final int projectId;
  var projectName;
  SureImageContent(
      {super.key,
      required this.projectId,
      required this.projectName,
      required void Function() refreshCallback});

  @override
  _SureImageContentState createState() =>
      _SureImageContentState(projectId: projectId, projectName: projectName);
}

class _SureImageContentState extends State<SureImageContent> {
  final int projectId;
  var projectName;
  _SureImageContentState({required this.projectId, required this.projectName});

  late Future<List<Map<String, dynamic>>> _dataFuture; // Data from fetchData

  @override
  void initState() {
    super.initState();
    _dataFuture = fetchData();
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    final token = await TokenManager.getToken();
    const String baseUrl = ApiConstants.baseUrlSureOps;
    final url =
        '$baseUrl/sureops/suredocker/repo/getAllPackages/?repoName=$projectName';
    // final containerUrl = '$baseUrl/sureops/suredocker/repo/getAllPackages/?repoName=$projectId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      // final containerResponse = await http.get(
      //   Uri.parse(containerUrl),
      //   headers: {
      //     'Authorization': 'Bearer $token',
      //   },
      // );

      if (response.statusCode >= 200 && response.statusCode <= 209) {
        final List<dynamic> jsonData = json.decode(response.body);

        // if (containerResponse.statusCode >= 200 &&
        //     containerResponse.statusCode <= 209) {
        //   final List<dynamic> containerData =
        //       json.decode(containerResponse.body);
        //   jsonData.addAll(containerData); // Merge the two lists
        // }

        return jsonData.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  // Future<void> _showVariablesDialog() async {
  //   final token = await TokenManager.getToken();
  //   const String baseUrl = 'http://43.205.154.152:31123';
  //   final url = '$baseUrl/sureops/getjson/$projectId/3/test/test';

  //   try {
  //     final response = await http.get(
  //       Uri.parse(url),
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //       },
  //     );
  //     var res = response.body;

  //     if (response.statusCode <= 209) {
  //       final Map<String, dynamic> jsonData = json.decode(res.toString());

  //       // Convert the JSON to a human-readable string
  //       final formattedData =
  //           const JsonEncoder.withIndent('  ').convert(jsonData);
  //       print('formattedData is $formattedData');

  //       showDialog(
  //         context: context,
  //         builder: (context) {
  //           return AlertDialog(
  //             title: const Text('Variables Data'),
  //             content: SingleChildScrollView(
  //               child: Text(
  //                 formattedData,
  //                 style: const TextStyle(
  //                     fontFamily:
  //                         'Courier New'), // Use monospace font for better alignment
  //               ),
  //             ),
  //             actions: <Widget>[
  //               TextButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //                 child: const Text('Close'),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     } else {
  //       throw Exception(
  //           'Failed to load variables data: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     throw Exception('Failed to load variables data: $e');
  //   }
  // }

  void refreshData() {
    setState(() {
      _dataFuture = fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                refreshData(); // Refresh data when the button is pressed
              },
              child: const Text('Refresh Data'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        FutureBuilder<List<Map<String, dynamic>>>(
          future: _dataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error: Server Error'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No data available..'));
            } else {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Image Name')),
                    DataColumn(label: Text('Image Tag')),
                    DataColumn(label: Text('Created Time')),
                    DataColumn(label: Text('Author Name')),
                    DataColumn(label: Text('Labels')),
                    DataColumn(label: Text('Pull Command')),
                  ],
                  rows: snapshot.data!.map((item) {
                    return DataRow(cells: [
                      DataCell(Text(item['Image_Name'])),
                      DataCell(Text(item['Image_Tag'].toString() ?? 'empty')),
                      DataCell(Text(item['Created_Time'].toString() ?? '')),
                      DataCell(Text(item['Author_Name'].toString() ?? '')),
                      DataCell(Text(item['Labels'].toString() ?? '')),
                      const DataCell(Text(
                          'docker pull git.cloudnsure.com/risadmin/name:version')),
                    ]);
                  }).toList(),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}

class WorkflowStatusDialog extends StatefulWidget {
  final Map<String, dynamic> workflowData;

  WorkflowStatusDialog({required this.workflowData});

  @override
  _WorkflowStatusDialogState createState() => _WorkflowStatusDialogState();
}

class _WorkflowStatusDialogState extends State<WorkflowStatusDialog> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    // Start a timer that triggers a refresh every 3 seconds
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      print("workflow refresh");
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();

    // Cancel the timer when the widget is disposed
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> steps =
        json.decode(widget.workflowData['current_json']);
    return AlertDialog(
      title: const Text('Workflow Status'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the workflow status here
            for (var step in steps)
              WorkflowStepWidget(
                step: step['step'],
                state: step['state'],
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}

class WorkflowStepWidget extends StatelessWidget {
  final String step;
  final String state;

  WorkflowStepWidget({required this.step, required this.state});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color iconColor;

    if (state == 'success') {
      icon = Icons.check; // Green checkmark for successful steps
      iconColor = Colors.green;
    } else if (state == 'current') {
      icon = Icons.warning; // Caution sign for the current step
      iconColor = Colors.orange;
    } else {
      icon = Icons.close; // Red cross for failed steps
      iconColor = Colors.red;
    }

    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: iconColor),
          ),
          child: Center(
            child: Icon(
              icon,
              color: iconColor,
              size: 16,
            ),
          ),
        ),
        const SizedBox(width: 8), // Add spacing between icon and step text
        Text(
          step,
          style: TextStyle(
            color: iconColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
