import 'package:authsec_flutter/screens/Db_Screen/Db_service.dart';
import 'package:authsec_flutter/screens/Technology/Technology_service.dart';
import 'package:flutter/material.dart';

import 'package:authsec_flutter/providers/token_manager.dart';
import 'package:flutter/services.dart';

class CreateDbScreen extends StatefulWidget {
  final int projectId; // Add moduleId parameter

  CreateDbScreen({required this.projectId, Key? key}) : super(key: key);

  @override
  _CreateDbScreenState createState() => _CreateDbScreenState();
}

class _CreateDbScreenState extends State<CreateDbScreen> {
  final DbApiService dbService = DbApiService();
  final TechnologyApiService techService = TechnologyApiService();

  final Map<String, dynamic> formData = {};
  final _formKey = GlobalKey<FormState>();
  bool isexisting = false;

  List<Map<String, dynamic>> ddtestItems = [];

  String selectedddtestValue = ''; // Use nullable type

  Future<void> _loadddtestItems() async {
    final token = await TokenManager.getToken();
    try {
      final selectTdata = await techService.get_techbytype(token!, 'database');

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
      appBar: AppBar(title: const Text('Create Databse')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Switch(
                  value: isexisting,
                  onChanged: (newValue) {
                    setState(() {
                      isexisting = newValue;
                    });
                  },
                ),
                const SizedBox(width: 8),
                const Text('Existing Db'),

                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Database name'),
                  onSaved: (value) => formData['db_name'] = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Database name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Database Username'),
                  onSaved: (value) => formData['db_username'] = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Database Username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Database Password'),
                  onSaved: (value) => formData['db_password'] = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Database Password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: '3306',
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                  ],
                  decoration: const InputDecoration(labelText: 'Port No'),
                  onSaved: (value) => formData['port_no'] = value,
                ),
                const SizedBox(height: 16),

                if (isexisting) ...[
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Host name'),
                    onSaved: (value) => formData['host_name'] = value,
                  ),
                  const SizedBox(height: 16),
                ],

                // DropdownButtonFormField with default value and null check
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'DB type'),
                  value: selectedddtestValue,
                  items: [
                    // Add an item with an empty value to represent no selection
                    const DropdownMenuItem<String>(
                      value: '',
                      child: Text('Choose DB type'),
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
                      return 'Please select DB type';
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
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5), // Add margin
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        formData['existing_db'] = isexisting;
                        formData['proj_id'] = widget.projectId;

                        final token = await TokenManager.getToken();
                        try {
                          print("token is : $token");
                          print(formData);

                          await dbService.create_db(token!, formData);

                          Navigator.pop(context);
                        } catch (e) {
                          // ignore: use_build_context_synchronously
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Error'),
                                content: Text('Failed to create database: $e'),
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
