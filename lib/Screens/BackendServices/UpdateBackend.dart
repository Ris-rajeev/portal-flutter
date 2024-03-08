import 'package:authsec_flutter/screens/BackendServices/BackendService.dart';
import 'package:authsec_flutter/screens/Db_Screen/Db_service.dart';
import 'package:authsec_flutter/screens/Technology/Technology_service.dart';
import 'package:flutter/material.dart';

import 'package:authsec_flutter/providers/token_manager.dart';

import 'package:flutter/services.dart';

class UpdateBackendScreen extends StatefulWidget {
  final Map<String, dynamic> entity;
  final int projectId; // Add moduleId parameter

  UpdateBackendScreen({required this.projectId, required this.entity, Key? key})
      : super(key: key);

  @override
  _UpdateBackendScreenState createState() => _UpdateBackendScreenState();
}

class _UpdateBackendScreenState extends State<UpdateBackendScreen> {
  final backendApiService backendService = backendApiService();
  final DbApiService dbService = DbApiService();
  final TechnologyApiService techService = TechnologyApiService();
  final _formKey = GlobalKey<FormState>();

  bool isprimary = false;
  List<Map<String, dynamic>> ddtestItems = [];
  List<Map<String, dynamic>> dbItems = [];

  var selectedTechnologyStackValue;
  var selectedDatabaseValue;

  Future<void> _loadddtestItems() async {
    final token = await TokenManager.getToken();
    try {
      final selectTdata = await techService.get_techbytype(token!, 'backend');

      print('techstack fetched...');

      // Handle null or empty dropdownData
      // ignore: unnecessary_null_comparison
      if (selectTdata != null && selectTdata.isNotEmpty) {
        setState(() {
          ddtestItems = selectTdata;
          ddtestItems = ddtestItems
              .toSet()
              .toList(); // This will convert the list to a set to remove duplicates and then back to a list.
          // selectedTechnologyStackValue = widget.entity['techstack'].toString();
          print(
              'Selected tesc: $selectedTechnologyStackValue'); // Add this line

          // selectedTechnologyStackValue = 'tesc';
        });
      } else {
        print('techstack data is null or empty');
      }
    } catch (e) {
      print('Failed to load techstack items: $e');
    }
  }

  Future<void> _loadDbItems() async {
    final token = await TokenManager.getToken();
    try {
      final selectTdata =
          await dbService.getDbByprojectId(token!, widget.projectId);

      print('Database fetched...');

      // Handle null or empty dropdownData
      // ignore: unnecessary_null_comparison
      if (selectTdata != null && selectTdata.isNotEmpty) {
        setState(() {
          dbItems = selectTdata;
          // selectedDatabaseValue = widget.entity['db_id'].toString();
          print('Selected tesc: $selectedDatabaseValue'); // Add this line
        });
      } else {
        print('databse data is null or empty');
      }
    } catch (e) {
      print('Failed to load database items: $e');
    }
  }

  // Initialize the selected values based on widget.entity
  @override
  void initState() {
    super.initState();

    isprimary = widget.entity['isprimary'] ?? false;
    selectedTechnologyStackValue = widget.entity['techstack'].toString();
    selectedDatabaseValue = widget.entity['db_id'].toString();

    _loadddtestItems();
    _loadDbItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Backend')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  initialValue:
                      widget.entity['backend_service_name'].toString(),
                  decoration:
                      const InputDecoration(labelText: 'Backend Service Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter  Database name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    widget.entity['backend_service_name'] = value;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: widget.entity['description'].toString(),
                  decoration: const InputDecoration(
                      labelText: 'Description (optional)'),
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'Please enter Description';
                  //   }
                  //   return null;
                  // },
                  onSaved: (value) {
                    widget.entity['description'] = value;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField(
                  value: selectedTechnologyStackValue,
                  decoration:
                      const InputDecoration(labelText: 'Technology Stack'),
                  items: ddtestItems.map<DropdownMenuItem<String>>(
                    (item) {
                      return DropdownMenuItem<String>(
                        value: item['tech_stack'].toString(),
                        child: Text(item['tech_stack']),
                      );
                    },
                  ).toList(),
                  onChanged: (value) {
                    print('Selected Technology Stack: $value'); // Add this line

                    setState(() {
                      selectedTechnologyStackValue = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a Technology Stack';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    widget.entity['techstack'] = value;
                  },
                ),
                DropdownButtonFormField(
                  decoration: const InputDecoration(labelText: 'Database'),
                  value: selectedDatabaseValue,
                  items: dbItems.map<DropdownMenuItem<String>>(
                    (item) {
                      return DropdownMenuItem<String>(
                        value: item['id'].toString(),
                        child: Text(item['db_name']),
                      );
                    },
                  ).toList(),
                  onChanged: (value) {
                    print('Selected Database: $value'); // Add this line

                    setState(() {
                      selectedDatabaseValue = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a Database';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    widget.entity['db_id'] = value;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: isprimary,
                      onChanged: (newValue) {
                        setState(() {
                          isprimary = newValue!;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    const Text('IsPrimary'),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5), // Add margin
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        widget.entity['isprimary'] = isprimary;
                        widget.entity['proj_id'] = widget.projectId;
                        print(widget.entity);
                        final token = await TokenManager.getToken();
                        try {
                          await backendService.updateBackend(
                              token!,
                              widget.entity[
                                  'id'], // Assuming 'id' is the key in your entity map
                              widget.entity);
                          Navigator.pop(context);
                        } catch (e) {
                          // ignore: use_build_context_synchronously
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Error'),
                                content: Text('Failed to update Database: $e'),
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
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      child: const Center(
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
