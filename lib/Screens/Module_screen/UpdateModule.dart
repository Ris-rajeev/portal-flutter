import 'package:authsec_flutter/screens/Module_screen/module_service.dart';
import 'package:authsec_flutter/screens/Technology/Technology_service.dart';
import 'package:flutter/material.dart';

import 'package:authsec_flutter/providers/token_manager.dart';

import 'package:flutter/services.dart';

class UpdateModuleScreen extends StatefulWidget {
  final Map<String, dynamic> entity;
  final int projectId;
  final int moduleId; // Add moduleId parameter

  UpdateModuleScreen(
      {required this.projectId,
      required this.moduleId,
      required this.entity,
      Key? key})
      : super(key: key);

  @override
  _UpdateModuleScreenState createState() => _UpdateModuleScreenState();
}

class _UpdateModuleScreenState extends State<UpdateModuleScreen> {
  final ModuleApiService moduleService = ModuleApiService();
  final TechnologyApiService techService = TechnologyApiService();
  final _formKey = GlobalKey<FormState>();

  bool istesting = false;

  List<Map<String, dynamic>> ddtestItems = [];

  String? selectedddtestValue;

  Future<void> _loadddtestItems() async {
    final token = await TokenManager.getToken();
    try {
      final selectTdata = await techService.get_techbytype(token!, 'frontend');

      print('techstack fetched...');

      // Handle null or empty dropdownData
      if (selectTdata != null && selectTdata.isNotEmpty) {
        setState(() {
          ddtestItems = selectTdata;
          selectedddtestValue = widget.entity['technologyStack'];
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

    istesting =
        widget.entity['testing'] ?? false; // Set initial value of checkbox

    _loadddtestItems();
    // Fetch dropdown items when the screen initializes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Service')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  initialValue: widget.entity['moduleName'],
                  decoration: const InputDecoration(labelText: 'Service Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter  Service name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    widget.entity['moduleName'] = value;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: widget.entity['description'],
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
                TextFormField(
                  initialValue: widget.entity['tags'],
                  decoration: const InputDecoration(labelText: 'Tags'),
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'Please enter Tags';
                  //   }
                  //   return null;
                  // },
                  onSaved: (value) {
                    widget.entity['tags'] = value;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration:
                      const InputDecoration(labelText: 'Technology Stack'),
                  value: selectedddtestValue,
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text('No Value'),
                    ),
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
                      selectedddtestValue = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter  Technology Stack';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    widget.entity['technologyStack'] = value;
                  },
                ),
                const SizedBox(height: 16),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5), // Add margin
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        widget.entity['testing'] = istesting;
                        widget.entity['projectId'] = widget.projectId;

                        final token = await TokenManager.getToken();
                        try {
                          await moduleService.updatemodule(
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
                                content: Text('Failed to update Service: $e'),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
