import 'package:authsec_flutter/screens/BackendServices/BackendService.dart';
import 'package:authsec_flutter/screens/Db_Screen/Db_service.dart';
import 'package:authsec_flutter/screens/Technology/Technology_service.dart';
import 'package:flutter/material.dart';

import 'package:authsec_flutter/providers/token_manager.dart';

class CreateBackendScreen extends StatefulWidget {
  final int projectId; // Add moduleId parameter

  CreateBackendScreen({required this.projectId, Key? key}) : super(key: key);

  @override
  _CreateBackendScreenState createState() => _CreateBackendScreenState();
}

class _CreateBackendScreenState extends State<CreateBackendScreen> {
  final backendApiService backendService = backendApiService();
  final DbApiService dbService = DbApiService();
  final TechnologyApiService techService = TechnologyApiService();

  final Map<String, dynamic> formData = {};
  final _formKey = GlobalKey<FormState>();
  bool isprimary = false;

  List<Map<String, dynamic>> ddtestItems = [];
  List<Map<String, dynamic>> dbItems = [];

  var selectedddtestValue; // Use nullable type
  var selecteDbValue; // Use nullable type

  Future<void> _loadddtestItems() async {
    final token = await TokenManager.getToken();
    try {
      final selectTdata = await techService.get_techbytype(token!, 'backend');

      print('techstack fetched...');

      // Handle null or empty dropdownData
      if (selectTdata != null && selectTdata.isNotEmpty) {
        setState(() {
          ddtestItems = selectTdata;
          ddtestItems = ddtestItems
              .toSet()
              .toList(); // This will convert the list to a set to remove duplicates and then back to a list.
        });
      } else {
        print('techstack data is null or empty');
      }
    } catch (e) {
      print('Failed to load techstack items: $e');
    }
  }

  Future<void> _loadDbitems() async {
    final token = await TokenManager.getToken();
    try {
      final selectTdata =
          await dbService.getDbByprojectId(token!, widget.projectId);

      print('database fetched...');

      // Handle null or empty dropdownData
      if (selectTdata.isNotEmpty) {
        setState(() {
          dbItems = selectTdata;
        });
      } else {
        print('database data is null or empty');
      }
    } catch (e) {
      print('Failed to load database items: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadddtestItems();
    _loadDbitems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Backend')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Backend Service Name'),
                  onSaved: (value) => formData['backend_service_name'] = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter  Backend name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Description (optional)'),
                  onSaved: (value) => formData['description'] = value,
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'Please enter Description';
                  //   }
                  //   return null;
                  // },
                ),
                const SizedBox(height: 16),

                // DropdownButtonFormField with default value and null check
                DropdownButtonFormField<String>(
                  decoration:
                      const InputDecoration(labelText: 'Technology Stack'),
                  value: selectedddtestValue,
                  items: [
                    ...ddtestItems.map<DropdownMenuItem<String>>(
                      (item) {
                        return DropdownMenuItem<String>(
                          value: item['tech_stack'].toString(),
                          child: Text(item['tech_stack']),
                        );
                      },
                    ),
                  ],
                  onChanged: (value) {
                    print('Selected technology stack: $value');
                    setState(() {
                      selectedddtestValue = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a Technology Stack';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    if (selectedddtestValue.isEmpty) {
                      selectedddtestValue = "no value";
                    }
                    formData['techstack'] = selectedddtestValue;
                  },
                ),
                const SizedBox(height: 16),

                // DropdownButtonFormField with default value and null check
                DropdownButtonFormField<String>(
                  decoration:
                      const InputDecoration(labelText: 'Choose Database'),
                  value: selecteDbValue,
                  items: [
                    ...dbItems.map<DropdownMenuItem<String>>(
                      (item) {
                        return DropdownMenuItem<String>(
                          value: item['id'].toString(),
                          child: Text(item['db_name']),
                        );
                      },
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selecteDbValue = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a Database';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    if (selecteDbValue.isEmpty) {
                      selecteDbValue = "no value";
                    }
                    formData['db_id'] = selecteDbValue;
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
                // const SizedBox(height: 16),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5), // Add margin
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        formData['isprimary'] = isprimary;
                        formData['proj_id'] = widget.projectId;
                        if (formData['techstack'] != null &&
                            formData['db_id'] != null &&
                            formData['backend_service_name'] != '') {
                          final token = await TokenManager.getToken();
                          try {
                            print(formData);

                            await backendService.createBackend(
                                token!, formData);

                            Navigator.pop(context);
                          } catch (e) {
                            // ignore: use_build_context_synchronously
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Error'),
                                  content:
                                      Text('Failed to create database: $e'),
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
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      child: const Center(
                        child: Text(
                          'SUBMIT',
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
