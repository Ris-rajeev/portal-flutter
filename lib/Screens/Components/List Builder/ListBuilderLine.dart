import 'dart:convert';

import 'package:authsec_flutter/screens/BackendServices/BackendService.dart';
import 'package:authsec_flutter/screens/Components/List%20Builder/ListBuilderService.dart';
import 'package:authsec_flutter/providers/token_manager.dart';
import 'package:flutter/material.dart';

class ListBuilderLineBuilder extends StatefulWidget {
  final Map<String, dynamic> entity;
  final int projId;
  final int headerId;

  ListBuilderLineBuilder({
    required this.projId,
    required this.headerId,
    required this.entity,
  });

  @override
  _ListBuilderLineBuilderState createState() => _ListBuilderLineBuilderState();
}

class _ListBuilderLineBuilderState extends State<ListBuilderLineBuilder> {
  final backendApiService backendService = backendApiService();
  final ListBuilderApiService listService = ListBuilderApiService();
  final _formKey = GlobalKey<FormState>();

  //var tableName = '';
  List<dynamic> tableList = [];
  List<dynamic> colList = [];
  List<dynamic> selectedColumns = []; // Store selected columns here
  List<dynamic> attributesList = ['ext1', 'ext2', 'ext3'];
  late List<dynamic> jsonData;
  String model = '';

  var dummytablename;
  var selectedTableName;
  var selectedColumnName;
  List<String> selectedStaticOption = [];
  var selectedAtribute;

  Future<void> _loadTable() async {
    final token = await TokenManager.getToken();
    try {
      final selectTdata =
          await listService.getAllTable(token!, widget.headerId);

      print('table data is : $selectTdata');

      // Handle null or empty dropdownData
      if (selectTdata != null && selectTdata.isNotEmpty) {
        setState(() {
          tableList = selectTdata;
        });
      } else {
        print('Table  is null or empty');
      }
    } catch (e) {
      print('Failed to load Table: $e');
    }
  }

  Future<void> _loadColumns(String tableName) async {
    final token = await TokenManager.getToken();
    try {
      final selectTdata =
          await listService.getAllCols(token!, widget.projId, tableName);

      print('Column data is : $selectTdata');

      // Handle null or empty dropdownData
      if (selectTdata != null) {
        setState(() {
          colList = selectTdata; // Assign the list to colList
        });
      } else {
        print('Column  is null or empty');
      }
    } catch (e) {
      print('Failed to load Column: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadTable();
    model = widget.entity['model'];
    print('model is $model');

    if (model != null && model.isNotEmpty) {
      jsonData = json.decode(model);
      print('json is $jsonData');
      dummytablename = jsonData[0]['selectedTable'];
      print('dynamic table is $dummytablename');

      selectedTableName = jsonData[0]['selectedTable'] ?? '';
      selectedColumns = jsonData[0]['SelectedColumn'] ?? [];

      print('selecttable is $selectedTableName');
      if (selectedTableName != null && selectedTableName != '') {
        _loadColumns(selectedTableName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('List Builder')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Table Name'),
                  value: selectedTableName,
                  items: [
                    // const DropdownMenuItem<String>(
                    //   value: null,
                    //   child: Text('No Value'),
                    // ),
                    ...tableList.map<DropdownMenuItem<String>>(
                      (item) {
                        return DropdownMenuItem<String>(
                          value: item.toString(),
                          child: Text(item),
                        );
                      },
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedTableName = value!;
                      selectedColumns.clear();
                      _loadColumns(selectedTableName);
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Choose Table Name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButton<String>(
                  items: [
                    for (final col in colList)
                      DropdownMenuItem<String>(
                        value: col,
                        child: Text(col),
                      ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        if (selectedColumns.contains(value)) {
                          selectedColumns.remove(value);
                        } else {
                          selectedColumns.add(value);
                        }
                        // Add selected column
                      });
                    }
                  },
                  // validator: (value) {
                  //   // Skip validation as this dropdown allows multiple selections
                  //   return null;
                  // },
                  isExpanded: true,
                  icon: const Icon(Icons.add),
                  hint: const Text('Select Columns'),
                ),
                Text(selectedColumns.join(',')),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedAtribute,
                  decoration:
                      const InputDecoration(labelText: 'Select Attributes'),
                  items: [
                    ...attributesList.map<DropdownMenuItem<String>>(
                      (item) {
                        return DropdownMenuItem<String>(
                          value: item.toString(),
                          child: Text(item),
                        );
                      },
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedAtribute = value!;
                    });
                  },
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Select WHO'),
                  items: const [
                    DropdownMenuItem<String>(
                      value: 'createdAt',
                      child: Text('createdAt'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'createdBy',
                      child: Text('createdBy'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'accountId',
                      child: Text('accountId'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      if (selectedStaticOption.contains(value)) {
                        selectedColumns.remove(value);
                      } else {
                        selectedStaticOption.add(value!);
                      }
                    });
                  },
                ),
                Text(selectedStaticOption.join(",").toString()),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      print("option" + selectedStaticOption.toString());
                      print(selectedAtribute);
                      jsonData = [
                        {
                          'selectedTable': selectedTableName,
                          'SelectedColumn': selectedColumns,
                          'selectedAttributes': selectedAtribute,
                          'selectedWho': selectedStaticOption,
                          'mappers': '',
                          'filters':
                              '', // Placeholder for filters (you can add logic to capture filters)
                        }
                      ];
                      var data = jsonEncode(jsonData);
                      widget.entity['model'] = data;
                      print(jsonEncode(jsonData));
                      final token = await TokenManager.getToken();
                      try {
                        await listService.updateLbLine(
                            token!, widget.entity['id'], widget.entity);
                        Navigator.pop(context);
                      } catch (e) {
                        // ignore: use_build_context_synchronously
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Error'),
                              content: Text('Failed to update ListBuilder: $e'),
                              actions: [
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }
                  },
                  child: const SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Center(
                      child: Text(
                        'UPDATE',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
