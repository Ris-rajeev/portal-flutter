import 'package:authsec_flutter/screens/Module_screen/module_service.dart';
import 'package:authsec_flutter/screens/Technology/Technology_service.dart';
import 'package:flutter/material.dart';

import 'package:authsec_flutter/providers/token_manager.dart';

class CreateModuleScreen extends StatefulWidget {
  final int projectId; // Pass the projectId to this screen

  const CreateModuleScreen({required this.projectId, super.key});

  @override
  _CreateModuleScreenState createState() => _CreateModuleScreenState();
}

class _CreateModuleScreenState extends State<CreateModuleScreen> {
  final ModuleApiService moduleService = ModuleApiService();
  final TechnologyApiService techService = TechnologyApiService();
  final TextEditingController tagsController = TextEditingController();

  final Map<String, dynamic> formData = {};
  final _formKey = GlobalKey<FormState>();
  List<String> tags = []; // Add a list to store tags

  bool istesting = false;
  bool addition_fields = false;
  List<Map<String, dynamic>> ddtestItems = [];

  String selectedddtestValue = ''; // Use nullable type

  Future<void> _loadddtestItems() async {
    final token = await TokenManager.getToken();
    try {
      final selectTdata = await techService.get_techbytype(token!, 'frontend');

      print('techstack fetched...');

      // Handle null or empty dropdownData
      // ignore: unnecessary_null_comparison
      if (selectTdata != null && selectTdata.isNotEmpty) {
        setState(() {
          ddtestItems = selectTdata;
        });
      } else {
        print('techstack data is null or empty');
      }
    } catch (e) {
      print('Failed to load techstack items: $e');
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
      appBar: AppBar(title: const Text('Add Service')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Service Name'),
                  onSaved: (value) => formData['moduleName'] = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter service name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  onSaved: (value) => formData['description'] = value,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Tags',
                    hintText: 'Add tags here (comma-separated)',
                    border: OutlineInputBorder(),
                  ),
                  controller: tagsController,
                ),

                // DropdownButtonFormField with default value and null check
                DropdownButtonFormField<String>(
                  decoration:
                      const InputDecoration(labelText: 'Technology Stack'),
                  value: selectedddtestValue,
                  items: [
                    // Add an item with an empty value to represent no selection
                    const DropdownMenuItem<String>(
                      value: '',
                      child: Text('Choose Technology'),
                    ),
                    // Map your dropdownItems as before
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
                    setState(() {
                      selectedddtestValue = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value == '') {
                      return 'Please select Technology Stack';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    if (selectedddtestValue.isEmpty) {
                      selectedddtestValue = "no value";
                    }
                    formData['technologyStack'] = selectedddtestValue;
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

                Switch(
                  value: addition_fields,
                  onChanged: (newValue) {
                    setState(() {
                      addition_fields = newValue;
                    });
                  },
                ),
                const SizedBox(width: 8),
                const Text('Additional Fields'),

                const SizedBox(height: 16),
                if (addition_fields) ...[
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Test1 '),
                    // onSaved: (value) => formData['test1'] = value,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Test2 '),
                    // onSaved: (value) => formData['test2'] = value,
                  ),
                  const SizedBox(height: 16),
                ],

                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5), // Add margin
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        formData['testing'] = istesting;
                        formData['projectId'] = widget.projectId;
                        final String tagsInput = tagsController.text;
                        final List<String> parsedTags = tagsInput
                            .split(',')
                            .map((tag) => tag.trim())
                            .toList();
                        formData['tags'] = parsedTags.join(
                            ', '); // Store tags as a comma-separated string

                        final token = await TokenManager.getToken();
                        // ignore: duplicate_ignore
                        try {
                          print(formData);

                          await moduleService.createmodule(token!, formData);

                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        } catch (e) {
                          print('error is $e');
                          // ignore: use_build_context_synchronously
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Error'),
                                content: Text('Failed to create Service: $e'),
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
