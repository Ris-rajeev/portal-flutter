import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../providers/token_manager.dart';
import '../../../resources/api_constants.dart';
import 'package:http/http.dart' as http;

class NodeEditProperties {
  String stdParamHtml = '';
  String adhocParamHtml = '';
  String columnStr = '';
  String connName = '';
  String dateParamReq = '';
  String sqlStr = '';
}

class ReportEditPage extends StatefulWidget {
  final int id;
  ReportEditPage(this.id);
  @override
  _ReportEditPageState createState() => _ReportEditPageState();
}

class _ReportEditPageState extends State<ReportEditPage> {
  final TextEditingController connectionNameController =
      TextEditingController();
  final TextEditingController dateParamReqController = TextEditingController();
  final TextEditingController stdParamHtmlController = TextEditingController();
  final TextEditingController adhocParamHtmlController =
      TextEditingController();
  final TextEditingController columnStrController = TextEditingController();
  final TextEditingController sqlStrController = TextEditingController();

  NodeEditProperties nodeEditProperties = NodeEditProperties();
  late Map<String, dynamic> ReportData;
  late List<dynamic> builderLine;
  late Map<String, dynamic> builderLineData;
  List<Map<String, dynamic>> databases = [];
  List<String> dateyesno = ["Yes", "No"];
  late int lineId;

  @override
  void initState() {
    super.initState();
    fetchdata();
    fetchdatabases();
  }

  //SqlworkbenchSqlcont/sql
  Future<void> fetchdatabases() async {
    final token = await TokenManager.getToken();
    final String baseUrl = ApiConstants.baseUrl;
    final String apiUrl = '$baseUrl/SqlworkbenchSqlcont/sql';
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final dynamic jsonData = json.decode(response.body);
        setState(() {
          databases = List<Map<String, dynamic>>.from(jsonData);
          print(databases);
        });
      } else {
        throw Exception('Failed to load data: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  Future<void> fetchdata() async {
    int idhere = widget.id;
    final token = await TokenManager.getToken();
    final String baseUrl = ApiConstants.baseUrl;
    final String apiUrl =
        '$baseUrl/Rpt_builder2/Rpt_builder2/' + idhere.toString();
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final dynamic jsonData = json.decode(response.body);
        setState(() {
          ReportData = Map<String, dynamic>.from(jsonData);
          builderLine = ReportData['rpt_builder2_lines'];
          lineId = builderLine[0]['id'];
          if (builderLine[0]['model'] != '') {
            String model = builderLine[0]['model'];
            print(model);
            Map<String, dynamic> jsonModel = json.decode(model);
            builderLineData = jsonModel;
            stdParamHtmlController.text = builderLineData['std_param_html'];
            adhocParamHtmlController.text = builderLineData['adhoc_param_html'];
            columnStrController.text = builderLineData['column_str'];
            sqlStrController.text = builderLineData['sql_str'];
            dateParamReqController.text = builderLineData['date_param_req'];
            connectionNameController.text = builderLineData['conn_name'];
          }
        });
      } else {
        throw Exception('Failed to load data: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report Edit'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'REPORT SET UP - Project Details Report (${widget.id})',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),
              Divider(),
              DropdownButton<String>(
                value: connectionNameController.text.isEmpty
                    ? "value Not available"
                    : connectionNameController.text, // Set the default value
                onChanged: (String? newValue) {
                  setState(() {
                    connectionNameController.text = newValue!;
                  });
                },
                items: databases.map<DropdownMenuItem<String>>(
                    (Map<String, dynamic> database) {
                  return DropdownMenuItem<String>(
                    value: database['name'],
                    child: Text(database['name']),
                  );
                }).toList(),
              ),
              DropdownButton<String>(
                value: dateyesno.contains(dateParamReqController.text)
                    ? dateParamReqController.text
                    : "Select the value", // Set the default value based on the controller's value or "Select the value" if it doesn't match any item
                onChanged: (String? newValue) {
                  setState(() {
                    dateParamReqController.text = newValue!;
                  });
                },
                items: dateyesno.map<DropdownMenuItem<String>>((String param) {
                  return DropdownMenuItem<String>(
                    value: param,
                    child: Text(param),
                  );
                }).toList(),
              ),
              TextField(
                controller: stdParamHtmlController,
                decoration: InputDecoration(
                    labelText: 'Standard Parameter String (html)'),
                maxLines: 3,
              ),
              TextField(
                controller: adhocParamHtmlController,
                decoration:
                    InputDecoration(labelText: 'Adhoc Parameter String (html)'),
                maxLines: 3,
              ),
              TextField(
                controller: columnStrController,
                decoration: InputDecoration(labelText: 'Column String (html)'),
                maxLines: 3,
              ),
              TextField(
                controller: sqlStrController,
                decoration: InputDecoration(labelText: 'SQL String'),
                maxLines: 3,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      builderLineData['std_param_html'] =
                          stdParamHtmlController.text;
                      builderLineData['adhoc_param_html'] =
                          adhocParamHtmlController.text;
                      builderLineData['column_str'] = columnStrController.text;
                      builderLineData['sql_str'] = sqlStrController.text;
                      builderLineData['date_param_req'] =
                          dateParamReqController.text;
                      builderLineData['conn_name'] =
                          connectionNameController.text;
                      builderLine[0]['model'] = builderLineData;
                      String jsonString = json.encode(builderLineData);
                      final token = await TokenManager.getToken();
                      final String baseUrl = ApiConstants.baseUrl;
                      final String apiUrl =
                          '$baseUrl/Rpt_builder2_lines/update/$lineId';
                      try {
                        final response = await http.put(Uri.parse(apiUrl),
                            headers: {
                              'Authorization': 'Bearer $token',
                              'Content-Type': 'application/json',
                            },
                            body: json.encode({'model': jsonString}));
                        if (response.statusCode <= 209) {
                          print("success");
                          Navigator.of(context).pop();
                        } else {
                          print(response.statusCode);
                        }
                      } catch (e) {
                        throw Exception('Failed to Update: $e');
                      }
                    },
                    child: Text('Update'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
