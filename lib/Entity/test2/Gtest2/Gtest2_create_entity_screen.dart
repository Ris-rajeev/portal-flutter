import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math';
import 'package:intl/intl.dart';

import 'package:authsec_flutter/Entity/test2/Gtest2/Gtest2_api_service.dart';
import 'package:authsec_flutter/providers/token_manager.dart';
import 'package:flutter/services.dart';

class CreateEntityScreen extends StatefulWidget {
  const CreateEntityScreen({super.key});

  @override
  _CreateEntityScreenState createState() => _CreateEntityScreenState();
}

class _CreateEntityScreenState extends State<CreateEntityScreen> {
  final ApiService apiService = ApiService();
  final Map<String, dynamic> formData = {};
  final _formKey = GlobalKey<FormState>();

  bool isSubscribed = false;

  List<Map<String, dynamic>> ddtestItems = [];
  String selectedddtestValue = ''; // Use nullable type

  Future<void> _loadddtestItems() async {
    final token = await TokenManager.getToken();
    try {
      final selectTdata = await apiService.getddtest(token!);

      print('ddtest data is : $selectTdata');

      // Handle null or empty dropdownData
      if (selectTdata != null && selectTdata.isNotEmpty) {
        setState(() {
          ddtestItems = selectTdata;
        });
      } else {
        print('ddtest data is null or empty');
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
      appBar: AppBar(title: const Text('Create Gtest2')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'name'),
                  onSaved: (value) => formData['name'] = value,
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Checkbox(
                      value: isSubscribed,
                      onChanged: (newValue) {
                        setState(() {
                          isSubscribed = newValue!;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    Text('testcheck'),
                  ],
                ),
                SizedBox(height: 16),

                // DropdownButtonFormField with default value and null check
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'ddtest'),
                  value: selectedddtestValue,
                  items: [
                    // Add an item with an empty value to represent no selection
                    const DropdownMenuItem<String>(
                      value: '',
                      child: Text('Select option'),
                    ),
                    // Map your dropdownItems as before
                    ...ddtestItems.map<DropdownMenuItem<String>>(
                      (item) {
                        return DropdownMenuItem<String>(
                          value: item['name'].toString(),
                          child: Text(item['name']),
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
                    formData['ddtest'] = selectedddtestValue;
                  },
                ),
                const SizedBox(height: 16),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5), // Add margin
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        formData['testcheck'] = isSubscribed;

                        final token = await TokenManager.getToken();
                        try {
                          print("token is : $token");
                          print(formData);

                          await apiService.createEntity(token!, formData);

                          Navigator.pop(context);
                        } catch (e) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Error'),
                                content: Text('Failed to create entity: $e'),
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
