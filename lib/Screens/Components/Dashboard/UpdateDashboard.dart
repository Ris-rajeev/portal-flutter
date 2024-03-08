import 'package:authsec_flutter/screens/BackendServices/BackendService.dart';
import 'package:authsec_flutter/screens/Components/Dashboard/Dashboard_Service.dart';
import 'package:flutter/material.dart';

import 'package:authsec_flutter/providers/token_manager.dart';

class UpdateDashboardScreen extends StatefulWidget {
  final Map<String, dynamic> entity;
  final int moduleId; // Add moduleId parameter

  UpdateDashboardScreen(
      {required this.moduleId, required this.entity, Key? key})
      : super(key: key);

  @override
  _UpdateDashboardScreenState createState() => _UpdateDashboardScreenState();
}

class _UpdateDashboardScreenState extends State<UpdateDashboardScreen> {
  final backendApiService backendService = backendApiService();
  final DashboardApiService dashService = DashboardApiService();
  final _formKey = GlobalKey<FormState>();

  bool istesting = false;
  bool ischildform = false;

  @override
  void initState() {
    super.initState();

    istesting =
        widget.entity['testing'] ?? false; // Set initial value of checkbox
    // Fetch dropdown items when the screen initializes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Dashboard')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  initialValue: widget.entity['dashboard_name'],
                  decoration:
                      const InputDecoration(labelText: 'Dashboard name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Dashboard name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    widget.entity['dashboard_name'] = value;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: widget.entity['description'],
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Description';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    widget.entity['description'] = value;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: widget.entity['secuirity_profile'],
                  decoration:
                      const InputDecoration(labelText: 'Secuirity Profile'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Secuirity Profile';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    widget.entity['secuirity_profile'] = value;
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
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5), // Add margin
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        widget.entity['testing'] = istesting;

                        final token = await TokenManager.getToken();
                        try {
                          await dashService.updatedashboard(
                              token!,
                              // Assuming 'id' is the key in your entity map
                              widget.entity);
                          Navigator.pop(context);
                        } catch (e) {
                          // ignore: use_build_context_synchronously
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Error'),
                                content: Text('Failed to update Dashboard: $e'),
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
