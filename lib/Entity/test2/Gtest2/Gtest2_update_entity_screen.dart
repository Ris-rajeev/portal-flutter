import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:authsec_flutter/Entity/test2/Gtest2/Gtest2_api_service.dart';
import 'dart:math';
import 'package:authsec_flutter/providers/token_manager.dart';

import 'package:flutter/services.dart';

class UpdateEntityScreen extends StatefulWidget {
  final Map<String, dynamic> entity;

  UpdateEntityScreen({required this.entity});

  @override
  _UpdateEntityScreenState createState() => _UpdateEntityScreenState();
}

class _UpdateEntityScreenState extends State<UpdateEntityScreen> {
  final ApiService apiService = ApiService();
  final _formKey = GlobalKey<FormState>();

  bool isCheckboxChecked = false;

  List<Map<String, dynamic>> ddtestItems = [];
  String? selectedddtestValue;

  Future<void> fetchddtestItems() async {
    final token = await TokenManager.getToken();
    try {
      final selectTdata = await apiService.getddtest(token!);

      print('ddtest data is : $selectTdata');

      // Handle null or empty dropdownData
      if (selectTdata != null && selectTdata.isNotEmpty) {
        setState(() {
          ddtestItems = selectTdata;

          // Set the initial value of selectedselect_tValue based on the entity's value
          selectedddtestValue = widget.entity['ddtest'] ?? null;
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

    isCheckboxChecked =
        widget.entity['testcheck'] ?? false; // Set initial value of checkbox

    fetchddtestItems(); // Fetch dropdown items when the screen initializes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Gtest2')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  initialValue: widget.entity['name'],
                  decoration: const InputDecoration(labelText: 'name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    widget.entity['name'] = value;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: isCheckboxChecked,
                      onChanged: (newValue) {
                        setState(() {
                          isCheckboxChecked = newValue!;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    Text('testcheck'),
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'ddtest'),
                  value: selectedddtestValue,
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text('No Value'),
                    ),
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
                      selectedddtestValue = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a ddtest';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    widget.entity['ddtest'] = value;
                  },
                ),
                const SizedBox(height: 16),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5), // Add margin
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        widget.entity['testcheck'] = isCheckboxChecked;

                        final token = await TokenManager.getToken();
                        try {
                          await apiService.updateEntity(
                              token!,
                              widget.entity[
                                  'id'], // Assuming 'id' is the key in your entity map
                              widget.entity);
                          Navigator.pop(context);
                        } catch (e) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Error'),
                                content: Text('Failed to update entity: $e'),
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
