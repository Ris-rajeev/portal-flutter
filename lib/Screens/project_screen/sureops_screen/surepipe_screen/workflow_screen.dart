// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:authsec_flutter/hadwin_components.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../providers/token_manager.dart';

class WorkFlowContent extends StatefulWidget {
  final int projectId;
  WorkFlowContent(
      {super.key,
      required this.projectId,
      required void Function() refreshCallback});

  @override
  _WorkFlowContentState createState() =>
      _WorkFlowContentState(projectId: projectId);
}

// class _WorkFlowContentState extends State<WorkFlowContent> {
//   final int projectId;
//   _WorkFlowContentState({required this.projectId});
//   late Future<List<Map<String, dynamic>>> _dataFuture;
//   late Timer _timer;
//
//   @override
//   void initState() {
//     super.initState();
//     _dataFuture = fetchData();
//     _timer = Timer.periodic(Duration(seconds: 3), (timer) {
//       print("fetched");
//       fetchData();});
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _timer.cancel();
//   }
//
//   Future<List<Map<String, dynamic>>> fetchData() async {
//     final token = await TokenManager.getToken();
//     const String baseUrl = ApiConstants.baseUrlSureOps;
//     final url = '$baseUrl/sureops/get/$projectId';
//
//     try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: {
//           'Authorization': 'Bearer $token',
//         },
//       );
//
//       if (response.statusCode >= 200 && response.statusCode <= 209) {
//         final List<dynamic> jsonData = json.decode(response.body);
//         return jsonData.cast<Map<String, dynamic>>();
//       } else {
//         throw Exception('Failed to load data: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Failed to load data: $e');
//     }
//   }
//
//   void showWorkflowStatus(Map<String, dynamic> workflowData) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return WorkflowStatusDialog(workflowData: workflowData);
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         const SizedBox(height: 20),
//         FutureBuilder<List<Map<String, dynamic>>>(
//           future: _dataFuture,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//               return const Center(child: Text('No data available.'));
//             } else {
//               return SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: DataTable(
//                   columns: const [
//                     DataColumn(label: Text('Workflow')),
//                     DataColumn(label: Text('Reference Id')),
//                     DataColumn(label: Text('Job Type')),
//                     DataColumn(label: Text('Created At')),
//                     DataColumn(label: Text('Action')),
//                   ],
//                   rows: snapshot.data!.map((item) {
//                     return DataRow(cells: [
//                       DataCell(
//                         GestureDetector(
//                           onTap: () {
//                             showWorkflowStatus(item);
//                           },
//                           child: const Icon(
//                             Icons.touch_app,
//                             color: Colors.green,
//                           ), // Replace "Text" with the desired icon
//                         ),
//                       ),
//                       DataCell(Text(item['ref'])),
//                       DataCell(Text(item['job_type'])),
//                       DataCell(Text(item['createdAt'])),
//                       DataCell(
//                         IconButton(
//                           icon: const Icon(Icons.info),
//                           onPressed: () {
//                             // Add your action logic here
//                           },
//                         ),
//                       ),
//                     ]);
//                   }).toList(),
//                 ),
//               );
//             }
//           },
//         ),
//       ],
//     );
//   }
// }

class _WorkFlowContentState extends State<WorkFlowContent> {
  final int projectId;
  _WorkFlowContentState({required this.projectId});

  late Future<List<Map<String, dynamic>>> _dataFuture; // Data from fetchData

  @override
  void initState() {
    super.initState();
    _dataFuture = fetchData();
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    final token = await TokenManager.getToken();
    const String baseUrl = ApiConstants.baseUrlSureOps;
    final url = '$baseUrl/sureops/get/$projectId';
    final containerUrl = '$baseUrl/sureops/container/get/$projectId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      final containerResponse = await http.get(
        Uri.parse(containerUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode >= 200 && response.statusCode <= 209) {
        final List<dynamic> jsonData = json.decode(response.body);

        if (containerResponse.statusCode >= 200 &&
            containerResponse.statusCode <= 209) {
          final List<dynamic> containerData =
              json.decode(containerResponse.body);
          jsonData.addAll(containerData); // Merge the two lists
        }

        return jsonData.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  Future<void> _showVariablesDialog() async {
    final token = await TokenManager.getToken();
    const String baseUrl = 'http://43.205.154.152:31123';
    final url = '$baseUrl/sureops/getjson/$projectId/3/test/test';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      var res = response.body;

      if (response.statusCode <= 209) {
        final Map<String, dynamic> jsonData = json.decode(res.toString());

        // Convert the JSON to a human-readable string
        final formattedData =
            const JsonEncoder.withIndent('  ').convert(jsonData);
        print('formattedData is $formattedData');

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Variables Data'),
              content: SingleChildScrollView(
                child: Text(
                  formattedData,
                  style: const TextStyle(
                      fontFamily:
                          'Courier New'), // Use monospace font for better alignment
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      } else {
        throw Exception(
            'Failed to load variables data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load variables data: $e');
    }
  }

  void showWorkflowStatus(Map<String, dynamic> workflowData) {
    showDialog(
      context: context,
      builder: (context) {
        return WorkflowStatusDialog(workflowData: workflowData);
      },
    );
  }

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
                    DataColumn(label: Text('Workflow')),
                    DataColumn(label: Text('Show Logs')),
                    DataColumn(label: Text('Show Variables')),
                    DataColumn(label: Text('Reference Id')),
                    DataColumn(label: Text('Job Type')),
                    DataColumn(label: Text('Created At')),
                    DataColumn(label: Text('Action')),
                  ],
                  rows: snapshot.data!.map((item) {
                    return DataRow(cells: [
                      DataCell(
                        GestureDetector(
                          onTap: () {
                            showWorkflowStatus(item);
                          },
                          child: const Icon(
                            Icons.touch_app,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      const DataCell(Text('logs')),
                      DataCell(
                        IconButton(
                          icon: const Icon(Icons.arrow_circle_up_outlined),
                          onPressed: () {
                            _showVariablesDialog();
                          },
                        ),
                      ),
                      DataCell(Text(item['ref'])),
                      DataCell(Text(item['job_type'])),
                      DataCell(Text(item['createdAt'])),
                      DataCell(
                        IconButton(
                          icon: const Icon(Icons.info),
                          onPressed: () {
                            // Add your action logic here
                          },
                        ),
                      ),
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
