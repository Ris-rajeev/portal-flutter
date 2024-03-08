import 'package:authsec_flutter/screens/Db_Screen/Db_service.dart';
import 'package:authsec_flutter/screens/Technology/Technology_service.dart';
import 'package:flutter/material.dart';

import 'package:authsec_flutter/providers/token_manager.dart';

import 'package:flutter/services.dart';

class UpdateDatabseScreen extends StatefulWidget {
  final Map<String, dynamic> entity;
  final int projectId; // Add moduleId parameter

  UpdateDatabseScreen({required this.projectId, required this.entity, Key? key})
      : super(key: key);

  @override
  _UpdateDatabseScreenState createState() => _UpdateDatabseScreenState();
}

class _UpdateDatabseScreenState extends State<UpdateDatabseScreen> {
  final DbApiService dbService = DbApiService();
  final TechnologyApiService techService = TechnologyApiService();
  final _formKey = GlobalKey<FormState>();

  bool isexisting = false;
  List<Map<String, dynamic>> ddtestItems = [];
  String? selectedddtestValue;

  Future<void> _loadddtestItems() async {
    final token = await TokenManager.getToken();
    try {
      final selectTdata = await techService.get_techbytype(token!, 'database');

      print('techstack fetched...');

      // Handle null or empty dropdownData
      if (selectTdata != null && selectTdata.isNotEmpty) {
        setState(() {
          ddtestItems = selectTdata;
          selectedddtestValue = widget.entity['techstack'];
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

    isexisting = widget.entity['existing_db'] ?? false; // Set initial value

    _loadddtestItems(); // Fetch dropdown items when the screen initializes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Database')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
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
                  ],
                ),
                TextFormField(
                  initialValue: widget.entity['db_name'],
                  decoration: const InputDecoration(labelText: 'Database name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter  Database name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    widget.entity['db_name'] = value;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: widget.entity['db_username'],
                  decoration:
                      const InputDecoration(labelText: 'Database Username'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Database Username';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    widget.entity['db_username'] = value;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: widget.entity['db_password'],
                  decoration:
                      const InputDecoration(labelText: 'Database Password'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Database Password';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    widget.entity['db_password'] = value;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: widget.entity['port_no'].toString(),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                  ],
                  decoration: const InputDecoration(labelText: 'Port No'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Port No';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    widget.entity['port_no'] = value;
                  },
                ),
                const SizedBox(height: 16),
                if (isexisting) ...[
                  TextFormField(
                    initialValue: widget.entity['host_name'],
                    decoration: const InputDecoration(labelText: 'Host name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Host name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      widget.entity['host_name'] = value;
                    },
                  ),
                  const SizedBox(height: 16),
                ],
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'DB type'),
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
                      return 'Please enter DB type';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    widget.entity['techstack'] = value;
                  },
                ),
                const SizedBox(height: 16),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5), // Add margin
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        widget.entity['existing_db'] = isexisting;
                        widget.entity['proj_id'] = widget.projectId;

                        final token = await TokenManager.getToken();
                        try {
                          await dbService.update_db(
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
                                content: Text('Failed to update Database: $e'),
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
