import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../providers/token_manager.dart';
import '../../../resources/api_constants.dart';
import 'package:http/http.dart' as http;

class ReportPage2 extends StatefulWidget {
  @override
  _ReportPage2State createState() => _ReportPage2State();
}

class _ReportPage2State extends State<ReportPage2> {
  bool isActive = false;
  bool includeDateFilter = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController getUrlController = TextEditingController();

  List<String> selectedColumns = [];
  List<String> columnList = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> dropdownItems = ["Item 1", "Item 2", "Item 3"];
  var selectedDropdownItem;

  Future<void> fetchData() async {
    print("working");
    final token = await TokenManager.getToken();
    print(token);
    String baseUrl = ApiConstants.baseUrl;
    var response = await http.get(
      Uri.parse(
          '$baseUrl/Rpt_builder2_lines/geturlkeybyurl?url=$getUrlController.text'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    print(response.statusCode);
    if (response.statusCode <= 209) {
      columnList = response.body as List<String>;
      print(columnList);
    } else {
      // Handle errors
      print('Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Report (Edit Mode)'),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Report',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text('Name:'),
                  TextField(
                    controller: nameController,
                  ),
                  SizedBox(height: 10.0),
                  Text('Description:'),
                  TextField(
                    controller: descriptionController,
                    maxLines: 3,
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: [
                      Text('Active:'),
                      Switch(
                        value: isActive,
                        onChanged: (value) {
                          setState(() {
                            isActive = value;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Include Date Filter:'),
                      Switch(
                        value: includeDateFilter,
                        onChanged: (value) {
                          setState(() {
                            includeDateFilter = value;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Text('Get URL:'),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a URL';
                      }
                      if (!Uri.parse(value).isAbsolute) {
                        return 'Please enter a valid URL';
                      }
                      return null;
                    },
                    controller: getUrlController,
                    decoration: InputDecoration(
                      labelText: 'Get URL:',
                    ),
                    onChanged: (value) {
                      fetchData();
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16.0),
                  Text('Standard Parameter:'),
                  DropdownButtonFormField<String>(
                    isDense: true,
                    isExpanded: true,
                    //value: selectedTables,
                    onChanged: (newValue) {
                      setState(() {
                        if (selectedColumns.contains(newValue)) {
                          selectedColumns.remove(newValue);
                        } else {
                          selectedColumns.add(newValue!);
                        }
                      });
                    },
                    items: columnList.map((table) {
                      return DropdownMenuItem<String>(
                        value: table,
                        child: Row(
                          children: [
                            Checkbox(
                              value: selectedColumns.contains(table),
                              onChanged: (value) {
                                setState(() {
                                  if (selectedColumns.contains(table)) {
                                    selectedColumns.remove(table);
                                  } else {
                                    selectedColumns.add(table);
                                  }
                                });
                              },
                            ),
                            Text(table),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  Text('Selected Parameters: ${selectedColumns.join(", ")}'),
                  SizedBox(height: 16.0),
                  Text('List Dropdown:'),
                  DropdownButton<String>(
                    value: selectedDropdownItem,
                    items: dropdownItems.map((item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDropdownItem = value;
                      });
                    },
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Back'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          _formKey.currentState!.validate();
                          print("working");
                          final token = await TokenManager.getToken();
                          print(token);
                          String baseUrl = ApiConstants.baseUrl;
                          var response = await http.post(
                              Uri.parse('$baseUrl/Rpt_builder2/Rpt_builder2'),
                              headers: {
                                'Authorization': 'Bearer $token',
                                'Content-Type':
                                    'application/json', // You may need to adjust the content type as needed
                              },
                              body: json.encode({
                                "reportName": nameController.text,
                                "description": descriptionController.text,
                                "active": isActive,
                                "isSql": false
                              }));
                          print(response.statusCode);
                          if (response.statusCode <= 209) {
                            Navigator.pop(context);
                          } else {
                            Fluttertoast.showToast(
                              msg: 'Failed to Submit',
                              backgroundColor: Colors.red,
                            );
                          }
                        },
                        child: Text('Submit'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
