import 'dart:convert';
import 'package:authsec_flutter/screens/Components/ReportBuilder/reportbuilderedit.dart';
import 'package:authsec_flutter/screens/Components/ReportBuilder/reportquery.dart';
import 'package:flutter/material.dart';
import '../../../providers/token_manager.dart';
import '../../../resources/api_constants.dart';
import 'package:http/http.dart' as http;

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  List<Map<String, dynamic>> reports = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final token = await TokenManager.getToken();
    final String baseUrl = ApiConstants.baseUrl;
    final String apiUrl = '$baseUrl/Rpt_builder2/Rpt_builder2';
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          reports = List<Map<String, dynamic>>.from(jsonData);
        });
      } else {
        throw Exception('Failed to load data: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  void _showAddReportPopup() {
    TextEditingController reportNameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    bool isActive = false; // Initially set to false

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add Report"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: reportNameController,
                    decoration: InputDecoration(labelText: 'Report Name'),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                  ),
                  Row(
                    children: [
                      Text("Active"),
                      StatefulBuilder(
                        builder:
                            (BuildContext context, StateSetter switchState) {
                          return Switch(
                            value: isActive,
                            onChanged: (bool newValue) {
                              switchState(() {
                                isActive = newValue; // Update isActive
                              });
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Submit"),
              onPressed: () async {
                String reportName = reportNameController.text;
                String description = descriptionController.text;
                final token = await TokenManager.getToken();
                const String baseUrlSureOps = ApiConstants.baseUrl;
                const String apiUrl =
                    '$baseUrlSureOps/Rpt_builder2/Rpt_builder2';
                try {
                  final response = await http.post(
                    Uri.parse(apiUrl),
                    headers: {
                      'Authorization': 'Bearer $token',
                      'Content-Type': 'application/json',
                    },
                    body: jsonEncode({
                      "reportName": reportName,
                      "description": description,
                      "active": isActive,
                    }),
                  );
                  if (response.statusCode >= 200 &&
                      response.statusCode <= 209) {
                    print("done");
                  } else {
                    throw Exception(
                        'Failed to load data: ${response.statusCode}');
                  }
                } catch (e) {
                  throw Exception('Failed to load data: $e');
                }
                setState(() {
                  fetchData();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Report'),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _showAddReportPopup();
                setState(() {
                  fetchData();
                });
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Go To')),
                DataColumn(label: Text('Report Name')),
                DataColumn(label: Text('Report Description')),
                DataColumn(label: Text('Active')),
                DataColumn(label: Text('Folder Name')),
                DataColumn(label: Text('Action')),
              ],
              rows: reports.map((report) {
                return DataRow(cells: [
                  DataCell(IconButton(
                    icon: Icon(Icons.settings_applications_rounded),
                    onPressed: () {
                      if (report['Rpt_builder2_lines'].length != 0 &&
                          report['Rpt_builder2_lines'][0]['model'] != '') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ReportEditPage(report['id'])),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReportQuery(report)),
                        );
                      }
                    },
                  )),
                  DataCell(Text(report['reportName'] ?? '')),
                  DataCell(Text(report['description'] ?? '')),
                  DataCell(Text(report['active'].toString())),
                  DataCell(Text(report['folderName'] ?? '')),
                  DataCell(IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      final token = await TokenManager.getToken();
                      int reportid = report['id'];
                      const String baseUrlSureOps = ApiConstants.baseUrl;
                      String apiUrl =
                          '$baseUrlSureOps/Rpt_builder2/Rpt_builder2/$reportid';
                      try {
                        final response = await http.delete(
                          Uri.parse(apiUrl),
                          headers: {
                            'Authorization': 'Bearer $token',
                          },
                        );
                        if (response.statusCode >= 200 &&
                            response.statusCode <= 209) {
                          print("done");
                        } else {
                          throw Exception(
                              'Failed to load data: ${response.statusCode}');
                        }
                      } catch (e) {
                        throw Exception('Failed to load data: $e');
                      }
                      setState(() {
                        fetchData();
                      });
                    },
                  )),
                ]);
              }).toList(),
            ),
          ),
        ));
  }
}
