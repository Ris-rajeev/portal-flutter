import 'package:authsec_flutter/screens/Components/Dashboard/Dashboard_Service.dart';
import 'package:flutter/material.dart';

import 'package:authsec_flutter/providers/token_manager.dart';

class CreateDashboardScreen extends StatefulWidget {
  final int moduleId; // Add moduleId parameter

  CreateDashboardScreen({required this.moduleId, Key? key}) : super(key: key);

  @override
  _CreateDashboardScreenState createState() => _CreateDashboardScreenState();
}

class _CreateDashboardScreenState extends State<CreateDashboardScreen> {
  final DashboardApiService dashService = DashboardApiService();

  final Map<String, dynamic> formData = {};
  final Map<String, dynamic> dashboardline = {};
  List<Map<String, dynamic>> dashlineList = [];

  final _formKey = GlobalKey<FormState>();
  bool istesting = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Dashboard')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Dashboard name'),
                  onSaved: (value) => formData['dashboard_name'] = value,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  onSaved: (value) => formData['description'] = value,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Secuirity Profile'),
                  onSaved: (value) => formData['secuirity_profile'] = value,
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
                        formData['testing'] = istesting;

                        formData['module_id'] = widget.moduleId;
                        dashboardline['model'] =
                            '{"dashboard":[{"cols":5,"rows":5,"x":0,"y":0,"chartid":4,"component":"Bar Chart","name":"Bar Chart"}]}';

                        dashlineList.add(dashboardline);
                        formData['dashbord1_Line'] = dashlineList;

                        final token = await TokenManager.getToken();
                        try {
                          print(formData);

                          await dashService.createdashboard(token!, formData);

                          Navigator.pop(context);
                        } catch (e) {
                          // ignore: use_build_context_synchronously
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Error'),
                                content: Text('Failed to create Dashboard: $e'),
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
