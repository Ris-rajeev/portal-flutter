import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../providers/token_manager.dart';
import '../../../resources/api_constants.dart';
import 'package:http/http.dart' as http;

class ReportQuery extends StatefulWidget {
  ReportQuery(Map<String, dynamic> report);

  @override
  _SQLWorksheetState createState() => _SQLWorksheetState();
}

class _SQLWorksheetState extends State<ReportQuery> {
  int tablePrefix = 97;
  List<String> selectedTables = [];
  List<String> selectedColumns = [];
  List<String> columnList = [];
  late Map<String, List<String>> selectedTableandColumn;
  List<String> selectConditionsList = [];
  List<String> tableList = [];

  List<dynamic> getFinalDataAfterRunning = [];
  String databaseName = '';
  String selectedtable = '';
  String selectedcol = '';
  String selectedcol1 = '';
  String selectedParamter = '';
  String dataParameter = '';
  String foldername = '';
  String selectedquery = '';
  int selectedIndex = 0;
  bool isActive = true;
  bool tableActive = false;
  String selectedRowInfo = "";
  List<String> dataColumns = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchTableList() async {
    final token = await TokenManager.getToken();
    String baseUrl = ApiConstants.baseUrl;
    final apiUrl = '$baseUrl/Table_list/$selectedRowInfo';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token', // Include the token in the headers
        },
      );

      if (response.statusCode <= 209) {
        final List<dynamic> responseData = json.decode(response.body);
        tableList = responseData.cast<String>();
        setState(() {});
        print(columnList);
        //tableList = responseData;
      } else {
        Fluttertoast.showToast(
          msg: 'Failed to fetch projects',
          backgroundColor: Colors.red,
        );
        throw Exception("Failed");
      }
    } catch (error) {
      Fluttertoast.showToast(
        msg: 'Error: $error',
        backgroundColor: Colors.red,
      );
      throw Exception("Failed");
    }
  }

  Future<void> fetchColumListByTableName() async {
    final token = await TokenManager.getToken();
    String baseUrl = ApiConstants.baseUrl;
    String tables = selectedTables.join(",");
    print(tables);
    final apiUrl = '$baseUrl/Alias_Table_list/$tables';
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token', // Include the token in the headers
        },
      );

      if (response.statusCode <= 209) {
        final List<dynamic> responseData = json.decode(response.body);
        columnList = responseData.cast<String>();
        print(columnList);
        setState(() {});
        //tableList = responseData;
      } else {
        Fluttertoast.showToast(
          msg: 'Failed to fetch Data',
          backgroundColor: Colors.red,
        );
        throw Exception("Failed");
      }
    } catch (error) {
      Fluttertoast.showToast(
        msg: 'Error: $error',
        backgroundColor: Colors.red,
      );
      throw Exception("Failed");
    }
  }

  String Query = '';
  void onAddCondition() {
    setState(() {
      _showQueryTableDialog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('SQL Works.-$selectedRowInfo'),
          actions: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                _showEditDialog();
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Table List', style: TextStyle(fontWeight: FontWeight.bold)),
              FormField<bool>(
                builder: (FormFieldState<bool> state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Table List',
                      errorText: state.hasError ? state.errorText : null,
                    ),
                    child: DropdownButtonFormField<String>(
                      isDense: true,
                      isExpanded: true,
                      // value: isActive ? selectedValue : null, // Disable the dropdown if isActive is false
                      onChanged: isActive
                          ? (newValue) {
                              setState(() {
                                if (selectedTables.contains(newValue)) {
                                  selectedTables.remove(newValue);
                                } else {
                                  selectedTables.add(newValue!);
                                }
                              });
                            }
                          : null,
                      items: tableList.map((table) {
                        return DropdownMenuItem<String>(
                          value: table,
                          child: Row(
                            children: [
                              Checkbox(
                                value: selectedTables.contains(table),
                                onChanged: (value) {
                                  setState(() {
                                    if (selectedTables.contains(table)) {
                                      selectedTables.remove(table);
                                    } else {
                                      selectedTables.add(table);
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
                  );
                },
              ),

              Text('Selected Tables: ${selectedTables.join(", ")}'),
              ElevatedButton(
                onPressed: isActive
                    ? () {
                        setState(() {
                          fetchColumListByTableName();
                          isActive = false;
                        });
                      }
                    : null,
                child: Text("Submit"),
              ),
              //--------------------------------------------------------------
              Text('Column List',
                  style: TextStyle(fontWeight: FontWeight.bold)),
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
              Text('Selected Columns: ${selectedColumns.join(", ")}'),
              //------------------------------------------------------------------
              SizedBox(height: 16.0),
            ],
          ),
          ElevatedButton(
            onPressed: onAddCondition,
            child: Text("Add Conditions"),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () async {
              List<String> conditiondatastring = [];
              conditionData.forEach((element) {
                conditiondatastring.add(element['andor'] +
                    " " +
                    element['fields_name'] +
                    element['condition'] +
                    element['value'] +
                    " ");
              });
              final token = await TokenManager.getToken();
              String baseUrl = ApiConstants.baseUrl;
              final apiUrl = '$baseUrl/getQuery';

              try {
                final response = await http.post(Uri.parse(apiUrl),
                    headers: {
                      'Authorization': 'Bearer $token',
                      'Content-Type': 'application/json',
                    },
                    body: json.encode({
                      "tables": selectedTables,
                      "columns": selectedColumns,
                      "conditions": conditiondatastring
                    }));
                print(response.statusCode);
                if (response.statusCode <= 209) {
                  Query = response.body;
                  setState(() {});
                  print(Query);
                } else {
                  Fluttertoast.showToast(
                    msg: 'Failed to fetch projects',
                    backgroundColor: Colors.red,
                  );
                  throw Exception("Failed");
                }
              } catch (error) {
                Fluttertoast.showToast(
                  msg: 'Error: $error',
                  backgroundColor: Colors.red,
                );
                throw Exception("Failed");
              }
            },
            child: Text("Create Query"),
          ),
          SizedBox(height: 16.0),
          TextFormField(
            initialValue: Query,
            onChanged: (value) {
              Query = value;
            },
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () async {
              final token = await TokenManager.getToken();
              String baseUrl = ApiConstants.baseUrl;
              final apiUrl = '$baseUrl/api/master-query-data?sql_query=$Query';

              try {
                final response = await http.get(
                  Uri.parse(apiUrl),
                  headers: {
                    'Authorization': 'Bearer $token',
                  },
                );
                final List<dynamic> responseData = json.decode(response.body);
                print(response.statusCode);
                print(Query);
                if (response.statusCode <= 209) {
                  getFinalDataAfterRunning = responseData.map((e) {
                    final map = e as Map<String, dynamic>;
                    return map;
                  }).toList();
                  List<String> keysList = [];

                  for (var dynamicItem in getFinalDataAfterRunning) {
                    if (dynamicItem is Map<String, dynamic>) {
                      dynamicItem.keys.forEach((key) {
                        if (!keysList.contains(key)) {
                          keysList.add(key);
                        }
                      });
                    }
                  }

                  dataColumns = keysList;

                  print(keysList); // Output: ['id', 'name']

                  print(getFinalDataAfterRunning);
                  if (!getFinalDataAfterRunning.isEmpty) {
                    tableActive = true;
                  }
                  setState(() {});
                } else {
                  Fluttertoast.showToast(
                    msg: 'Failed to fetch Data',
                    backgroundColor: Colors.red,
                  );
                  throw Exception("Failed");
                }
              } catch (error) {
                Fluttertoast.showToast(
                  msg: 'Error: $error',
                  backgroundColor: Colors.red,
                );
                throw Exception("Failed");
              }
            },
            child: Text("Run"),
          ),
          SizedBox(height: 16.0),
          tableActive
              ?
              // DataTable(
              //     columns: getFinalDataAfterRunning.isNotEmpty
              //         ? dataColumns.map((a) {
              //       return DataColumn(
              //         label: Text(a.toString()),
              //       );
              //     }).toList()
              //         : [],
              //     rows: getFinalDataAfterRunning.map((data) {
              //       int count = 0;
              //       return DataRow(
              //         cells: data[dataColumns[count]].map(val) {
              //           return DataCell(
              //             Text(val.toString()),
              //           );
              //         }).toList(),
              //       );
              //     }).toList(),
              //   )
              DataTable(
                  columns: getFinalDataAfterRunning.isNotEmpty
                      ? dataColumns.map((columnName) {
                          return DataColumn(
                            label: Text(columnName.toString()),
                          );
                        }).toList()
                      : [],
                  rows: getFinalDataAfterRunning.map((data) {
                    return DataRow(
                      cells: dataColumns.map((columnName) {
                        return DataCell(
                          Text(data[columnName].toString()),
                        );
                      }).toList(),
                    );
                  }).toList(),
                )
              : Text("No Data Available"),
          SizedBox(height: 16.0),
        ])));
  }

  List<Map<String, dynamic>> conditionData = [];

  void deleteRow(int index) {
    setState(() {
      conditionData.removeAt(index);
    });
  }

  void onAddLines() {
    setState(() {
      conditionData.add({
        'andor': null,
        'fields_name': null,
        'condition': null,
        'value': '',
      });
    });
  }

  void onSelected() {
    print(conditionData);
  }

  void _showQueryTableDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Condition Table'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                DataTable(
                  columns: [
                    DataColumn(label: Text('ANDOR')),
                    DataColumn(label: Text('FIELD NAME')),
                    DataColumn(label: Text('CONDITION')),
                    DataColumn(label: Text('VALUE')),
                    DataColumn(label: Text('Action')),
                  ],
                  rows: conditionData.asMap().entries.map((entry) {
                    int index = entry.key;
                    Map<String, dynamic> data = entry.value;
                    return DataRow(
                      key: ValueKey<int>(
                          index), // Set a unique key for each DataRow
                      cells: [
                        DataCell(
                          DropdownButton<String>(
                            value: data['andor'],
                            onChanged: (value) {
                              setState(() {
                                data['andor'] = value;
                              });
                              Navigator.of(context).pop();
                              _showQueryTableDialog();
                            },
                            items: ['AND', 'OR'].map((value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        DataCell(
                          DropdownButton<String>(
                            value: data['fields_name'],
                            onChanged: (value) {
                              setState(() {
                                data['fields_name'] = value;
                              });
                              Navigator.of(context).pop();
                              _showQueryTableDialog();
                            },
                            items: columnList.map((value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        DataCell(
                          DropdownButton<String>(
                            value: data['condition'],
                            onChanged: (value) {
                              setState(() {
                                data['condition'] = value;
                              });
                              Navigator.of(context).pop();
                              _showQueryTableDialog();
                            },
                            items: [
                              '=',
                              '!=',
                              '<',
                              '>',
                              '<=',
                              '>=',
                              'LIKE',
                              'BETWEEN',
                              'IN'
                            ].map((value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        DataCell(
                          TextFormField(
                            initialValue: data['value'],
                            onChanged: (value) {
                              setState(() {
                                data['value'] = value;
                              });
                              Navigator.of(context).pop();
                              _showQueryTableDialog();
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        DataCell(
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              deleteRow(index);
                              Navigator.of(context).pop();
                              _showQueryTableDialog();
                            },
                            color: Colors.red,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
                ElevatedButton(
                  onPressed: () {
                    onAddLines();
                    Navigator.of(context).pop();
                    _showQueryTableDialog();
                  },
                  child: Icon(Icons.add),
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        print(conditionData);
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text('Cancel'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Function to show the edit dialog
  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Data"),
          content: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: FutureBuilder(
                future: fetchDataFromApi(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // Show a loading indicator while fetching data
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else {
                    List? data = snapshot.data;
                    return DataTable(
                      columns: [
                        DataColumn(label: Text('No')),
                        DataColumn(label: Text('Database Name')),
                        DataColumn(label: Text('Description')),
                        DataColumn(label: Text('Active')),
                        DataColumn(label: Text('Type')),
                        DataColumn(label: Text('Action')),
                      ],
                      rows: List<DataRow>.generate(
                        data!.length,
                        (index) {
                          final rowData = data[index];
                          return DataRow(
                            onSelectChanged: (isSelected) {
                              if (isSelected != null && isSelected) {
                                setState(() {
                                  selectedRowInfo = rowData['name'];
                                  fetchTableList();
                                });
                                Navigator.of(context).pop();
                              }
                            },
                            cells: [
                              DataCell(Text(index.toString())),
                              DataCell(Text(rowData['name'].toString())),
                              DataCell(Text(rowData['description'].toString())),
                              DataCell(Text(rowData['active'].toString())),
                              DataCell(Text(rowData['type'].toString())),
                              DataCell(Text('Action')),
                            ],
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Future<List<dynamic>> fetchDataFromApi() async {
    final token = await TokenManager.getToken();
    String baseUrl = ApiConstants.baseUrl;
    final apiUrl = '$baseUrl/SqlworkbenchSqlcont/sql';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token', // Include the token in the headers
        },
      );
      final List<dynamic> responseData = json.decode(response.body);
      if (response.statusCode <= 209) {
        return responseData.map((e) {
          final map = e as Map<String, dynamic>;
          return map;
        }).toList();
      } else {
        Fluttertoast.showToast(
          msg: 'Failed to fetch projects',
          backgroundColor: Colors.red,
        );
        throw Exception("Failed");
      }
    } catch (error) {
      Fluttertoast.showToast(
        msg: 'Error: $error',
        backgroundColor: Colors.red,
      );
      throw Exception("Failed");
    }
  }
}

class DropdownModel {
  int? id;
  String? tabName;

  DropdownModel({this.id, this.tabName});

  DropdownModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tabName = json['tabName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tabName'] = this.tabName;
    return data;
  }
}
