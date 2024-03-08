import 'package:authsec_flutter/screens/BackendServices/BackendService.dart';
import 'package:authsec_flutter/screens/Components/Wireframes/Wireframe_Service.dart';
import 'package:authsec_flutter/screens/Module_screen/module_service.dart';
import 'package:flutter/material.dart';

import 'package:authsec_flutter/providers/token_manager.dart';

class UpdateWireframeScreen extends StatefulWidget {
  final Map<String, dynamic> entity;
  final int moduleId; // Add moduleId parameter
  final int projId;

  UpdateWireframeScreen(
      {required this.moduleId,
      required this.entity,
      required this.projId,
      Key? key})
      : super(key: key);

  @override
  _UpdateWireframeScreenState createState() => _UpdateWireframeScreenState();
}

class _UpdateWireframeScreenState extends State<UpdateWireframeScreen> {
  final backendApiService backendService = backendApiService();
  final WireframeApiService wireframeService = WireframeApiService();
  final ModuleApiService moduleService = ModuleApiService();
  final _formKey = GlobalKey<FormState>();

  bool istesting = false;
  bool ischildform = false;
  bool add_tomobile = false;

  List<Map<String, dynamic>> ddtestItems = [];
  List<Map<String, dynamic>> modItems = [];

  var selectedddtestValue; // Use nullable type
  var selectService; // Use nullable type

  bool enabledropdown = false;

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

  Future<void> _loadFlutterServices() async {
    final token = await TokenManager.getToken();
    try {
      final modules = await moduleService.getOnlyFlutterServicesByProjectId(
          token!, widget.projId);

      print('modules fetched... $modules');

      // Handle null or empty dropdownData
      if (modules != null && modules.isNotEmpty) {
        setState(() {
          modItems = modules;
          modItems = modItems
              .toSet()
              .toList(); // This will convert the list to a set to remove duplicates and then back to a list.
        });
      } else {
        print('Modules data is null or empty');
      }
    } catch (e) {
      print('Failed to load Modules items: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    var ent = widget.entity;
    print('entity is...........$ent');
    istesting = widget.entity['testing'] ?? false;
    ischildform = widget.entity['child_form'] ?? false;
    selectService = widget.entity['serviceTechid'].toString();
    selectedddtestValue = widget.entity['backend_id'].toString();
    fetchddtestItems().then((_) {
      _loadFlutterServices().then((_) {
        initvalues();
        enabledropdown = true;
      });
    });
  }

  void initvalues() {
    if (selectService == "null") {
      selectService = null;
    }
    if (selectedddtestValue == "null") {
      selectedddtestValue = null;
    }
    bool flagser = false;
    bool flagback = false;
    modItems.forEach((element) {
      if (element['id'].toString() == selectService) {
        flagser = true;
      }
    });
    ddtestItems.forEach((element) {
      if (element['id'].toString() == selectedddtestValue) {
        flagback = true;
      }
    });
    if (!flagser) {
      selectService = null;
    }
    if (!flagback) {
      selectedddtestValue = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Wireframe')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  initialValue: widget.entity['uiName'],
                  decoration:
                      const InputDecoration(labelText: 'Wireframe name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Wireframe name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    widget.entity['uiName'] = value;
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
                enabledropdown
                    ? DropdownButton<String>(
                        hint: const Text("Select Backend Service"),
                        isExpanded: true,
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
                                child: Text(
                                    item['backend_service_name'].toString()),
                              );
                            },
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedddtestValue = value;
                          });
                        },
                      )
                    : Text("loading..."),
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
                Row(
                  children: [
                    Checkbox(
                      value: ischildform,
                      onChanged: (newValue) {
                        setState(() {
                          ischildform = newValue!;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    const Text('Child Form'),
                  ],
                ),
                const SizedBox(height: 16),
                Switch(
                  value: add_tomobile,
                  onChanged: (newValue) {
                    setState(() {
                      add_tomobile = newValue;
                    });
                  },
                ),
                const SizedBox(width: 8),
                const Text('Add To Mobile'),
                if (add_tomobile) ...[
                  enabledropdown
                      ? DropdownButton(
                          isExpanded: true,
                          hint: const Text("Select Flutter Services"),
                          value: selectService,
                          items: [
                            const DropdownMenuItem<String>(
                              value: null,
                              child: Text('No Value'),
                            ),
                            ...modItems.map<DropdownMenuItem<String>>(
                              (item) {
                                return DropdownMenuItem<String>(
                                  value: item['id'].toString(),
                                  child: Text(item['moduleName'].toString()),
                                );
                              },
                            )
                          ],
                          onChanged: (value) {
                            print(
                                'Selected Module Stack: $value'); // Add this line

                            setState(() {
                              selectService = value!;
                            });
                          },
                        )
                      : Text("loading..."),
                ],
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5), // Add margin
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        widget.entity['serviceTechid'] = selectService;
                        widget.entity['backend_id'] = selectedddtestValue;
                        widget.entity['testing'] = istesting;
                        widget.entity['child_form'] = ischildform;
                        widget.entity['add_tomobile'] = add_tomobile;
                        print(widget.entity['moduleId']);
                        final token = await TokenManager.getToken();
                        try {
                          await wireframeService.updateWireframe(
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
