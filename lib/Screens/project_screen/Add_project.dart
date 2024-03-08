// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:authsec_flutter/screens/project_screen/ProjectListScreen.dart';
import 'package:authsec_flutter/screens/project_screen/project_service.dart';
import 'package:flutter/material.dart';

import 'package:authsec_flutter/providers/token_manager.dart';
import 'package:image_picker/image_picker.dart';

class CreateProjectScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  //final String type;
  final String type;
  final String? selectedAccessibility; // Add this parameter

  const CreateProjectScreen({
    required this.userData,
    required this.type,
    required this.selectedAccessibility, // Initialize it in the constructor
    Key? key,
  }) : super(key: key);

  @override
  _CreateProjectScreenState createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  final ProjectApiService apiService = ProjectApiService();
  final Map<String, dynamic> formData = {};
  final _formKey = GlobalKey<FormState>();
  bool addition_fields = false;
  var logoname;
  var logopath;

  String? uploadimageurl;
  Uint8List? _imageBytes; // Uint8List to store the image data
  String? _imageFileName;

  String? selectedcount;
  String? selectedCategory; // Add selectedCategory
  late List<Map<String, dynamic>> deploymentProfiles =
      []; // Initialize as an empty list
  var selectDeployment;

  late List<Map<String, dynamic>> deploymentProfileLines =
      []; // Initialize as an empty list
  var selectDeploymentLine;

  Future<void> _uploadImageFile() async {
    final imagePicker = ImagePicker();

    try {
      final pickedImage =
          await imagePicker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        final imageBytes = await pickedImage.readAsBytes();

        setState(() {
          _imageBytes = imageBytes;
          _imageFileName = pickedImage.name; // Store the file name
        });
      }
      _submitImage();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _submitImage() async {
    if (_imageBytes == null) {
      // Show an error message if no image is selected
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Please select an image.'),
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
      return;
    }

    if (_imageFileName == null) {
      // Handle the case where _imageFileName is null (no file name provided)
      print('File name is missing.');
      return;
    }
    try {
      final token = await TokenManager.getToken();
      Map<String, dynamic> fileuploadeddata =
          await apiService.createFile(_imageBytes!, _imageFileName!, token!);
      logoname = fileuploadeddata['image_name'];
      logopath = fileuploadeddata['image_path'];
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to upload image: $e'),
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

  Future<void> loadDepProfiles() async {
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
  Future<void> loadDepProfilesLines() async {
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

  // Future<void> _showcountSelectionDialog(BuildContext context) async {
  //   final result = await showDialog<String>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return SimpleDialog(
  //         title: const Text('Accessibility'),
  //         children: [
  //           RadioListTile<String>(
  //             title: const Text('Public'),
  //             value: 'false',
  //             groupValue: selectedcount,
  //             onChanged: (value) {
  //               setState(() {
  //                 selectedcount = value;
  //                 Navigator.pop(context, value);
  //               });
  //             },
  //           ),
  //           RadioListTile<String>(
  //             title: const Text('Private'),
  //             value: 'true',
  //             groupValue: selectedcount,
  //             onChanged: (value) {
  //               setState(() {
  //                 selectedcount = value;
  //                 Navigator.pop(context, value);
  //               });
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  void initState() {
    super.initState();
    selectedcount = widget.selectedAccessibility; // Initialize it here
    selectedCategory = 'E-commerce'; // Initialize with 'E-commerce'
    loadDepProfiles();
    loadDepProfilesLines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Project')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Project Name'),
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
                  onSaved: (value) => formData['description'] = value,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Tags'),
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
                  onSaved: (value) {
                    formData['category'] = value;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Company Display Name'),
                  onSaved: (value) => formData['company_Display_Name'] = value,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _uploadImageFile();
                  },
                  child: _imageBytes == null
                      ? Text('Pick a Company Logo')
                      : Text('Company Logo uploaded Successful'),
                  style: ButtonStyle(
                    backgroundColor: _imageBytes == null
                        ? MaterialStateProperty.all<Color>(Colors.red)
                        : MaterialStateProperty.all<Color>(
                            Colors.green), // Change to the desired color
                  ),
                ),
                const SizedBox(height: 16),
                Switch(
                  value: addition_fields,
                  onChanged: (newValue) {
                    setState(() {
                      addition_fields = newValue;
                    });
                  },
                ),
                const SizedBox(width: 8),
                const Text('Additional Fields'),
                const SizedBox(height: 16),
                if (addition_fields) ...[
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                        labelText: 'Select Git And Registery Profile '),
                    value: selectDeploymentLine,
                    items: deploymentProfileLines.map((category) {
                      return DropdownMenuItem<String>(
                        value: category['id'].toString(),
                        child: Text(category['lines_tables']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectDeploymentLine = value;
                      });
                    },
                    onSaved: (value) {
                      formData['registery_profileid'] = value;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                        labelText: 'Select Deployment profile'),
                    value: selectDeployment,
                    items: deploymentProfiles.map((category) {
                      return DropdownMenuItem<String>(
                        value: category['id'].toString(),
                        child: Text(category['name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectDeployment = value;
                      });
                    },
                    onSaved: (value) {
                      formData['private_deployid'] = value;
                    },
                  ),
                  TextFormField(
                    initialValue: '1',
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(labelText: 'major version'),
                    onSaved: (value) => formData['major_version'] = value,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: '0',
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(labelText: 'minor version'),
                    onSaved: (value) => formData['minor_version'] = value,
                  ),
                  const SizedBox(height: 16),
                ],
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        formData['upload_Logo_path'] = logopath;
                        formData['upload_Logo_name'] = logoname;
                        formData['accessibility'] = selectedcount;
                        final token = await TokenManager.getToken();
                        print('formData...............$formData');
                        try {
                          await apiService.createProject(token!, formData);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProjectListScreen(
                                userData: widget.userData,
                                type: widget.type,
                              ),
                            ),
                          );
                        } catch (e) {
                          print('error is $e');
                          // ignore: use_build_context_synchronously
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Error'),
                                content: Text('Failed to create Service: $e'),
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
