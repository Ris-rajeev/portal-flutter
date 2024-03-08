import 'package:authsec_flutter/screens/BackendServices/BackendService.dart';
import 'package:authsec_flutter/screens/Components/List%20Builder/ListBuilderService.dart';
import 'package:flutter/material.dart';

import 'package:authsec_flutter/providers/token_manager.dart';

class CreateListBuilderScreen extends StatefulWidget {
  final int moduleId; // Add moduleId parameter

  CreateListBuilderScreen({required this.moduleId, Key? key}) : super(key: key);

  @override
  _CreateListBuilderScreenState createState() =>
      _CreateListBuilderScreenState();
}

class _CreateListBuilderScreenState extends State<CreateListBuilderScreen> {
  final ListBuilderApiService listService = ListBuilderApiService();
  final backendApiService backendService = backendApiService();

  final Map<String, dynamic> formData = {};

  final _formKey = GlobalKey<FormState>();
  bool istesting = false;

  List<Map<String, dynamic>> ddtestItems = [];
  String selectedddtestValue = ''; // Use nullable type

  Future<void> _loadddtestItems() async {
    final token = await TokenManager.getToken();
    try {
      final selectTdata =
          await backendService.getBackendByModuleId(token!, widget.moduleId);

      print('backend data is : $selectTdata');

      // Handle null or empty dropdownData
      // ignore: unnecessary_null_comparison
      if (selectTdata != null && selectTdata.isNotEmpty) {
        setState(() {
          ddtestItems = selectTdata;
        });
      } else {
        print('backend data is null or empty');
      }
    } catch (e) {
      print('Failed to load ddtest items: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadddtestItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create ListBuilder')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Name'),
                  onSaved: (value) => formData['lb_name'] = value,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  onSaved: (value) => formData['description'] = value,
                ),
                const SizedBox(height: 16),

                // DropdownButtonFormField with default value and null check
                DropdownButtonFormField<String>(
                  decoration:
                      const InputDecoration(labelText: 'Backend Service'),
                  value: selectedddtestValue,
                  items: [
                    // Add an item with an empty value to represent no selection
                    const DropdownMenuItem<String>(
                      value: '',
                      child: Text('Choose Backend'),
                    ),
                    // Map your dropdownItems as before
                    ...ddtestItems.map<DropdownMenuItem<String>>(
                      (item) {
                        return DropdownMenuItem<String>(
                          value: item['id'].toString(),
                          child: Text(item['backend_service_name']),
                        );
                      },
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedddtestValue = value!;
                    });
                  },
                  onSaved: (value) {
                    if (selectedddtestValue.isEmpty) {
                      selectedddtestValue = "no value";
                    }
                    formData['backend_id'] = selectedddtestValue;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: istesting,
                      onChanged: (newValue) {
                        setState(() {
                          istesting = newValue!;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    const Text('Testing'),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Package name'),
                  onSaved: (value) => formData['package_name'] = value,
                ),
                const SizedBox(height: 16),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5), // Add margin
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        formData['testing'] = istesting;

                        formData['module_id'] = widget.moduleId;

                        final token = await TokenManager.getToken();
                        try {
                          print(formData);

                          await listService.createListBuiulder(
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
                                    Text('Failed to create ListBuilder: $e'),
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
