import 'package:authsec_flutter/screens/BackendServices/BackendService.dart';
import 'package:authsec_flutter/screens/Components/List%20Builder/ListBuilderService.dart';
import 'package:flutter/material.dart';

import 'package:authsec_flutter/providers/token_manager.dart';

class UpdateListBuilderScreen extends StatefulWidget {
  final Map<String, dynamic> entity;
  final int moduleId; // Add moduleId parameter

  UpdateListBuilderScreen(
      {required this.moduleId, required this.entity, Key? key})
      : super(key: key);

  @override
  _UpdateListBuilderScreenState createState() =>
      _UpdateListBuilderScreenState();
}

class _UpdateListBuilderScreenState extends State<UpdateListBuilderScreen> {
  final backendApiService backendService = backendApiService();
  final ListBuilderApiService listService = ListBuilderApiService();
  final _formKey = GlobalKey<FormState>();

  bool istesting = false;
  List<Map<String, dynamic>> ddtestItems = [];
  String? selectedddtestValue;

  Future<void> fetchddtestItems() async {
    final token = await TokenManager.getToken();
    try {
      final selectTdata =
          await backendService.getBackendByModuleId(token!, widget.moduleId);

      print('backend data is : $selectTdata');

      // Handle null or empty dropdownData
      if (selectTdata != null && selectTdata.isNotEmpty) {
        setState(() {
          ddtestItems = selectTdata;

          // Set the initial value of selectedselect_tValue based on the entity's value
          selectedddtestValue = widget.entity['backend_id'].toString();
        });
      } else {
        print('backend data is null or empty');
      }
    } catch (e) {
      print('Failed to load backend items: $e');
    }
  }

  @override
  void initState() {
    super.initState();

    istesting =
        widget.entity['testing'] ?? false; // Set initial value of checkbox

    fetchddtestItems(); // Fetch dropdown items when the screen initializes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update ListBuilder')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  initialValue: widget.entity['lb_name'],
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a ListBuilder name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    widget.entity['lb_name'] = value;
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
                DropdownButtonFormField<String>(
                  decoration:
                      const InputDecoration(labelText: 'Backend Service'),
                  value: selectedddtestValue,
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text('No Value'),
                    ),
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
                      selectedddtestValue = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter  Backend';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    widget.entity['backend_id'] = value;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: widget.entity['package_name'],
                  decoration: const InputDecoration(labelText: 'Package name'),
                  validator: (value) {},
                  onSaved: (value) {
                    widget.entity['package_name'] = value;
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
                          await listService.updateListBuiulder(
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
                                content:
                                    Text('Failed to update ListBuilder: $e'),
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
