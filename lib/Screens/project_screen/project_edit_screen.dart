// ignore_for_file: use_build_context_synchronously

import 'package:authsec_flutter/screens/project_screen/project_service.dart';
import 'package:flutter/material.dart';

import '../../providers/token_manager.dart';

class CreateEditProjectScreen extends StatefulWidget {
  final Map<String, dynamic>? project;

  const CreateEditProjectScreen({Key? key, this.project}) : super(key: key);

  @override
  _CreateEditProjectScreenState createState() =>
      _CreateEditProjectScreenState();
}

class _CreateEditProjectScreenState extends State<CreateEditProjectScreen> {
  final Map<String, dynamic> formData = {};
  final _formKey = GlobalKey<FormState>();
  bool addition_fields = false;

  List<String> nodataavail = ["No Data Available"];

  String? selectedCount;
  String? selectedCategory; // Add selectedCategory

  bool switchenable = false;

  final ProjectApiService apiService = ProjectApiService();

  List<Map<String, dynamic>> deploymentProfiles = [];
  List<Map<String, dynamic>> deploymentProfileLines = [];
  var selectedProfile;
  var selectedProfileLine;

  Future<void> loadDeployementProfile() async {
    final token = await TokenManager.getToken();
    try {
      final projectData = await apiService.getDeploymentProfile(token!);
      setState(() {
        deploymentProfiles = projectData;
      });
    } catch (e) {
      print('Failed to load Deployment Profile: $e');
    }
  }

// for registery profile
  Future<void> loadDeploymentProfileLine() async {
    final token = await TokenManager.getToken();
    try {
      final projectData = await apiService.getDeploymentProfileLines(token!);
      setState(() {
        deploymentProfileLines = projectData;
      });
    } catch (e) {
      print('Failed to load Deployment Profile Lines: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.project != null) {
      formData['projectName'] = widget.project!['projectName'];
      formData['tags'] = widget.project!['tags'];
      formData['description'] = widget.project!['description'];
      formData['major_version'] = widget.project!['major_version'].toString();
      formData['minor_version'] = widget.project!['minor_version'].toString();
      selectedCategory = widget.project!['category'];
      selectedCount = widget.project!['accessibility'].toString();
    }
    selectedProfile = widget.project!['private_deployid'].toString();
    selectedProfileLine = widget.project!['registery_profileid'].toString();
    loadDeployementProfile().then((_) {
      loadDeploymentProfileLine().then((_) {
        intializationhere();
        switchenable = true;
      });
    });
  }

  void intializationhere() {
    // Initialize form fields with project data if editing
    if (selectedProfile == "null") {
      selectedProfile = null;
    }
    if (selectedProfileLine == "null") {
      selectedProfileLine = null;
    }
    print("selectedProfile---$selectedProfile");
    deploymentProfiles.forEach((element) {
      print(element['id'].toString() + "  " + element['name'].toString());
    });
    print("selectedProfileLine---$selectedProfileLine");
    deploymentProfileLines.forEach((element) {
      print(
          element['id'].toString() + "  " + element['lines_tables'].toString());
    });
    //-------------------check id valid or not----
    bool flagprof = false;
    bool flagprofline = false;
    deploymentProfiles.forEach((element) {
      if (element['id'].toString() == selectedProfile) {
        flagprof = true;
      }
    });
    deploymentProfileLines.forEach((element) {
      if (element['id'].toString() == selectedProfileLine) {
        flagprofline = true;
      }
    });
    if (!flagprof) {
      selectedProfile = null;
    }
    if (!flagprofline) {
      selectedProfileLine = null;
    }
  }

  Future<void> _showCountSelectionDialog(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Accessibility'),
          children: [
            RadioListTile<String>(
              title: const Text('Public'),
              value: 'false', // Use string values here
              groupValue: selectedCount,
              onChanged: (value) {
                setState(() {
                  selectedCount = value;
                  Navigator.pop(context, value);
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Private'),
              value: 'true', // Use string values here
              groupValue: selectedCount,
              onChanged: (value) {
                setState(() {
                  selectedCount = value;
                  Navigator.pop(context, value);
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.project == null ? 'Add Project' : 'Edit Project')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Project Name'),
                  initialValue: formData['projectName'],
                  onSaved: (value) => formData['projectName'] = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Project Name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  initialValue: formData['description'],
                  onSaved: (value) => formData['description'] = value,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Tags'),
                  initialValue: formData['tags'],
                  onSaved: (value) => formData['tags'] = value,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'App Category'),
                  value: selectedCategory,
                  items: ['E-commerce', 'CRM'].map((Category) {
                    return DropdownMenuItem<String>(
                      value: Category,
                      child: Text(Category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value == '') {
                      return 'Please select App Category';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    formData['category'] = value;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Accessibility'),
                  readOnly: true,
                  controller: TextEditingController(text: selectedCount),
                  onTap: () => _showCountSelectionDialog(context),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select Accessibility';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    formData['accessibility'] = value;
                  },
                ),
                const SizedBox(height: 16),
                switchenable
                    ? Switch(
                        value: addition_fields,
                        onChanged: (newValue) {
                          setState(() {
                            addition_fields = newValue;
                          });
                        },
                      )
                    : Text("Waiting"),
                const SizedBox(width: 8),
                const Text('Additional Fields'),
                const SizedBox(height: 16),
                if (addition_fields) ...[
                  //-----------------
                  DropdownButton<String>(
                    isExpanded: true,
                    value: selectedProfileLine,
                    hint: const Text("Select Git And Registery Profile"),
                    items: [
                      const DropdownMenuItem<String>(
                        value: null,
                        child: Text('No Value'),
                      ),
                      ...deploymentProfileLines.isNotEmpty ||
                              deploymentProfileLines != null
                          ? deploymentProfileLines
                              .map<DropdownMenuItem<String>>(
                              (item) {
                                return DropdownMenuItem<String>(
                                  value: item['id'].toString(),
                                  child: Text(item['lines_tables'].toString()),
                                );
                              },
                            )
                          : nodataavail.map((e) => DropdownMenuItem<String>(
                                value: null,
                                child: Text(e.toString()),
                              )),
                    ],
                    onChanged: (value) {
                      print(value);
                      setState(() {
                        selectedProfileLine = value;
                      });
                    },
                  ),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: selectedProfile,
                    items: [
                      const DropdownMenuItem<String>(
                        value: null,
                        child: Text('No Value'),
                      ),
                      ...deploymentProfiles.isNotEmpty ||
                              deploymentProfiles != null
                          ? deploymentProfiles.map<DropdownMenuItem<String>>(
                              (item) {
                                return DropdownMenuItem<String>(
                                  value: item['id'].toString(),
                                  child: Text(item['name'].toString()),
                                );
                              },
                            )
                          : nodataavail.map(
                              (e) => DropdownMenuItem<String>(
                                value: null,
                                child: Text(e.toString()),
                              ),
                            )
                    ],
                    onChanged: (value) {
                      print(value);
                      setState(() {
                        selectedProfile = value;
                      });
                    },
                    hint: const Text("Select Deployment profile"),
                  ),

                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(labelText: 'Major version'),
                    initialValue: formData['major_version'],
                    onSaved: (value) => formData['major_version'] = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter major_version';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(labelText: 'Minor version'),
                    initialValue: formData['minor_version'],
                    onSaved: (value) => formData['minor_version'] = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter minor version';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                ],
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: ElevatedButton(
                    onPressed: () async {
                      formData['registery_profileid'] = selectedProfileLine;
                      formData['private_deployid'] = selectedProfile;
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        final token = await TokenManager.getToken();

                        try {
                          print("token is : $token");
                          print(formData);

                          if (widget.project == null) {
                            // Create new project
                            await apiService.createProject(token!, formData);
                          } else {
                            // Update existing project
                            await apiService.updateProject(
                                token!, widget.project?['id'], formData);
                          }

                          Navigator.pop(context);
                          // Add navigation or any other logic after successful create/update
                        } catch (e) {
                          print('error is $e');
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Error'),
                                content: Text(
                                    'Failed to ${widget.project == null ? 'create' : 'update'} project: $e'),
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
