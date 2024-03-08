import 'dart:convert';

import 'package:authsec_flutter/screens/BackendServices/BackendService.dart';
import 'package:authsec_flutter/screens/BackendServices/Backend_screen.dart';
import 'package:authsec_flutter/screens/Components/componentscreen.dart';
import 'package:authsec_flutter/screens/Db_Screen/Db_screen.dart';
import 'package:authsec_flutter/screens/Module_screen/UpdateModule.dart';
import 'package:authsec_flutter/screens/Module_screen/create_module.dart';
import 'package:authsec_flutter/screens/Module_screen/module_service.dart';
import 'package:authsec_flutter/screens/main_app_screen/CustomizeFooter.dart';
import 'package:flutter/material.dart';
import 'package:authsec_flutter/providers/token_manager.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../../resources/api_constants.dart';

class ModuleScreen extends StatefulWidget {
  final int projectId;
  final String type;

  ModuleScreen({required this.projectId, required this.type});

  @override
  _ModuleScreenState createState() => _ModuleScreenState();
}

class _ModuleScreenState extends State<ModuleScreen> {
  final ModuleApiService moduleApiService = ModuleApiService();
  final backendApiService backendservice = backendApiService();

  late List<Map<String, dynamic>> modules = [];
  late List<Map<String, dynamic>> backends = [];
  late Map<String, dynamic> mod = {};
  late Map<String, List<dynamic>> allconfigs = {};

  late List<dynamic> backendconfigs = [];

  late List<dynamic> backend_config = [];
  late List<dynamic> db_config = [];
  var selectedValues;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadModules();
  }

  Future<void> _loadModules() async {
    final token = await TokenManager.getToken();
    try {
      final moduleData = await moduleApiService.getModulesByEntityId(
        token!,
        widget.projectId,
      );

      setState(() {
        modules = moduleData;

        print('modules fetched...');
      });
      isLoading = true;
    } catch (e) {
      isLoading = true;
      print('Failed to load modules: $e');
    }
  }

  Future<void> _loadconfigs(int moduleId) async {
    final token = await TokenManager.getToken();
    try {
      final configs =
          await moduleApiService.getAllConfigByModuleId(token!, moduleId);
      setState(() {
        allconfigs = configs;

        // allconfigs = configs;
        // backend_config = configs['backend']!;
        db_config = configs['dbconfig']!;

        print('bac and db is $backend_config  and $db_config');
      });
    } catch (e) {
      print('Failed to load configs: $e');
    }
  }

  Future<void> _fetchBackendData(int moduleId) async {
    final token = await TokenManager.getToken();
    try {
      // Replace 'YOUR_API_ENDPOINT' with your actual API endpoint to fetch backend data.
      final backendData = await backendservice.getBackendByprojectId(
        token!,
        widget.projectId,
      );
      setState(() {
        backends = backendData;
      });

      // Show the data in a dialog or another widget as per your requirement.
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Backend Data'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  for (var backend in backends)
                    ListTile(
                      title: Text(backend['backend_service_name'] ?? 'N/A'),
                      subtitle: Text(backend['techstack'] ?? 'N/A'),
                      trailing: ElevatedButton(
                        onPressed: () {
                          if (widget.type == 'myproject') {
                            _callBackendAPI(backend['id'], moduleId).then((_) {
                              _loadModules();
                            });
                          } else {
                            Fluttertoast.showToast(
                              msg: 'Unauthorized access',
                              backgroundColor: Colors.red,
                            );
                          }
                        },
                        child: const Text('Add In Service'),
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Failed to fetch backend data: $e');
    }
  }

  // Function to call the API for a specific backend item
  Future<void> _callBackendAPI(int backendId, int moduleId) async {
    final token = await TokenManager.getToken();
    try {
      // Replace 'YOUR_API_ENDPOINT' with your actual API endpoint to call the API.
      final backend = await backendservice.getBackendById(
        token!,
        backendId,
      );

      final module = await moduleApiService.getModuleById(token!, moduleId);

      mod = module;

      backendconfigs = mod['backendConfig_ts'];
      backendconfigs.add(backend);

      mod['backendConfig_ts'] = backendconfigs;

      await moduleApiService.updatemodule(token!, moduleId, mod);

      // Process the API response as needed.
      print('API Response: $backend');
    } catch (e) {
      print('Failed to call backend API: $e');
    }
  }

  Future<void> deleteEntity(Map<String, dynamic> entity) async {
    try {
      final token = await TokenManager.getToken();
      await moduleApiService.deletemodule(token!, entity['id']);
      setState(() {
        modules.remove(entity);
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to delete entity: $e'),
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

  Future<List<DropdownModuleModel>> _fetchLibraryModules() async {
    final token = await TokenManager.getToken();
    String baseUrl = ApiConstants.baseUrl;
    final apiUrl = '$baseUrl/library/modulelibrary/getall_module_lib';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token', // Include the token in the headers
        },
      );
      final List<dynamic> responseData = json.decode(response.body);
      if (response.statusCode <= 209) {
        return responseData.map((e) {
          final map = e as Map<String, dynamic>;
          return DropdownModuleModel(
              id: map['id'], moduleName: map['moduleName']);
        }).toList();
      } else {
        Fluttertoast.showToast(
          msg: 'Failed to fetch projects',
          backgroundColor: Colors.red,
        );
        throw Exception("Failed");
      }
    } catch (error) {
      Fluttertoast.showToast(
        msg: 'Error: $error',
        backgroundColor: Colors.red,
      );
      throw Exception("Failed");
    }
  }

  void _openPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // StatefulBuilder is used to allow updating the dialog's state.

            return AlertDialog(
              title: const Text('Select a Module'),
              content: FutureBuilder<List<DropdownModuleModel>>(
                future: _fetchLibraryModules(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error loading data: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No data available.');
                  } else {
                    return DropdownButton<String>(
                      isExpanded: true,
                      value: selectedValues,
                      hint: const Text("Select Library Module"),
                      items: snapshot.data!.map((e) {
                        return DropdownMenuItem(
                          value: e.id.toString(),
                          child: Text(e.moduleName.toString()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          selectedValues = value;
                        });
                      },
                    );
                  }
                },
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (selectedValues != null) {
                      print(selectedValues);
                      _copyModule();
                      Navigator.of(context).pop();
                    } else {
                      print('No Module selected.');
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _copyModule() async {
    int projid = widget.projectId;

    String baseUrl = ApiConstants.baseUrl;
    final token = await TokenManager.getToken();
    final apiUrl =
        '$baseUrl/library/modulelibrary/copyfrommodulelibrarytomodule/$selectedValues/$projid';
    print(apiUrl);
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token', // Include the token in the headers
        },
      );
      print(response.statusCode);
      if (response.statusCode <= 209) {
        setState(() {
          _loadModules();
        });
        Fluttertoast.showToast(
          msg: 'Copy successful',
          backgroundColor: Colors.green,
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Copy failed',
          backgroundColor: Colors.red,
        );
      }
    } catch (error) {
      Fluttertoast.showToast(
        msg: 'Error: $error',
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> _addtomoduleLibrary(int moduleId) async {
    final token = await TokenManager.getToken();

    try {
      final response =
          await moduleApiService.moduleaddtolibrary(token!, moduleId);

      if (response.statusCode! <= 209) {
        Fluttertoast.showToast(
          msg: 'Copy successful',
          backgroundColor: Colors.green,
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Copy failed',
          backgroundColor: Colors.red,
        );
      }
    } catch (error) {
      Fluttertoast.showToast(
        msg: 'Error: $error',
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services'),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.miscellaneous_services_sharp),
        //     tooltip: 'Backend Services',
        //     onPressed: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) =>
        //               Backend_screen(projectId: widget.projectId),
        //         ),
        //       );
        //     },
        //   ),
        //   IconButton(
        //     icon: const Icon(Icons.data_usage),
        //     tooltip: 'Data bases',
        //     onPressed: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => Db_screen(projectId: widget.projectId),
        //         ),
        //       );
        //     },
        //   ),
        //   IconButton(
        //     icon: const Icon(Icons.local_library),
        //     tooltip: 'Copy Module From Library',
        //     onPressed: () {
        //       _openPopup(context);
        //       _fetchLibraryModules();
        //     },
        //   ),
        // ],
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading == false
                ? const Center(child: CircularProgressIndicator())
                : modules.isEmpty
                    ? const Center(
                        child: Text('No Services available.'),
                      )
                    : ListView.builder(
                        itemCount: modules.length,
                        itemBuilder: (context, index) {
                          final module = modules[index];
                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.all(16),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    leading: const Icon(
                                      Icons.star,
                                      color:
                                          Colors.red, // Use your desired color
                                    ),
                                    title: Text(
                                      '${module['moduleName'] ?? 'N/A'}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const SizedBox(height: 8),
                                  Container(
                                    color: Colors.grey[200],
                                    child: ListView(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      children: [
                                        for (var config
                                            in module['backendConfig_ts'])
                                          ListTile(
                                            leading: const Icon(
                                              Icons
                                                  .splitscreen_sharp, // Use the Spring Boot icon
                                              color: Colors
                                                  .green, // Use your desired color
                                            ),
                                            title: Text(
                                              config['backend_service_name']
                                                      .toString() ??
                                                  'N/A',
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    color: Colors.grey[200],
                                    child: ListView(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      children: [
                                        for (var config in backend_config)
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              config.toString(),
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    color: Colors.grey[200],
                                    child: ListView(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      children: [
                                        for (var config in db_config)
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              config.toString(),
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Container(
                                      color: Colors.grey[200],
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Column(
                                              children: [
                                                widget.type == 'myproject'
                                                    ? IconButton(
                                                        tooltip: 'Edit',
                                                        onPressed: () {
                                                          final moduleid =
                                                              module['id'];
                                                          print(
                                                              'moduleid is $moduleid');
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  UpdateModuleScreen(
                                                                      projectId:
                                                                          widget
                                                                              .projectId,
                                                                      moduleId:
                                                                          moduleid,
                                                                      entity:
                                                                          module),
                                                            ),
                                                          );
                                                        },
                                                        icon: const Icon(Icons
                                                            .edit_outlined),
                                                      )
                                                    : IconButton(
                                                        tooltip: 'Edit',
                                                        onPressed: () {
                                                          Fluttertoast
                                                              .showToast(
                                                            msg:
                                                                'Unauthorized access',
                                                            backgroundColor:
                                                                Colors.red,
                                                          );
                                                        },
                                                        icon: const Icon(
                                                          Icons.edit_outlined,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                const Text(
                                                  'Edit', // Add the label
                                                  style: TextStyle(
                                                    color: Colors
                                                        .black54, // Set the text color to white
                                                    fontSize:
                                                        10, // Adjust the font size as needed
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                IconButton(
                                                  tooltip: 'components',
                                                  onPressed: () {
                                                    final moduleid =
                                                        module['id'];
                                                    print(
                                                        'moduleid is $moduleid');
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ComponentsScreen(
                                                                projId: widget
                                                                    .projectId,
                                                                moduleId:
                                                                    moduleid,
                                                                type: widget
                                                                    .type),
                                                      ),
                                                    );
                                                  },
                                                  icon: const Icon(
                                                      Icons.add_chart_sharp),
                                                ),
                                                const Text(
                                                  'Components', // Add the label
                                                  style: TextStyle(
                                                    color: Colors
                                                        .black54, // Set the text color to white
                                                    fontSize:
                                                        10, // Adjust the font size as needed
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                IconButton(
                                                  tooltip: 'backend',
                                                  onPressed: () {
                                                    final moduleid =
                                                        module['id'];
                                                    _fetchBackendData(moduleid);
                                                  },
                                                  icon: const Icon(
                                                      Icons.api_rounded),
                                                ),
                                                const Text(
                                                  'Backend', // Add the label
                                                  style: TextStyle(
                                                    color: Colors
                                                        .black54, // Set the text color to white
                                                    fontSize:
                                                        10, // Adjust the font size as needed
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                widget.type == 'myproject'
                                                    ? IconButton(
                                                        tooltip:
                                                            'Add to Service Library',
                                                        onPressed: () {
                                                          final moduleid =
                                                              module['id'];
                                                          _addtomoduleLibrary(
                                                              moduleid);
                                                        },
                                                        icon: const Icon(
                                                            Icons.library_add),
                                                      )
                                                    : IconButton(
                                                        tooltip:
                                                            'Add to Service Library',
                                                        onPressed: () {
                                                          Fluttertoast
                                                              .showToast(
                                                            msg:
                                                                'Unauthorized access',
                                                            backgroundColor:
                                                                Colors.red,
                                                          );
                                                        },
                                                        icon: const Icon(
                                                          Icons.library_add,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                const Text(
                                                  'Add to Library', // Add the label
                                                  style: TextStyle(
                                                    color: Colors
                                                        .black54, // Set the text color to white
                                                    fontSize:
                                                        10, // Adjust the font size as needed
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                widget.type == 'myproject'
                                                    ? IconButton(
                                                        tooltip: 'delete',
                                                        onPressed: () {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: const Text(
                                                                    'Confirm Deletion'),
                                                                content: const Text(
                                                                    'Are you sure you want to delete this Module?'),
                                                                actions: [
                                                                  TextButton(
                                                                    child: const Text(
                                                                        'Cancel'),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                  ),
                                                                  TextButton(
                                                                    child: const Text(
                                                                        'Delete'),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      deleteEntity(
                                                                          module);
                                                                    },
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        },
                                                        icon: const Icon(
                                                            Icons.delete),
                                                      )
                                                    : IconButton(
                                                        tooltip: 'delete',
                                                        onPressed: () {
                                                          Fluttertoast
                                                              .showToast(
                                                            msg:
                                                                'Unauthorized access',
                                                            backgroundColor:
                                                                Colors.red,
                                                          );
                                                        },
                                                        icon: const Icon(
                                                          Icons.delete,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                const Text(
                                                  'Delete', // Add the label
                                                  style: TextStyle(
                                                    color: Colors
                                                        .black54, // Set the text color to white
                                                    fontSize:
                                                        10, // Adjust the font size as needed
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ]),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.miscellaneous_services_sharp),
            backgroundColor: Colors.blue,
            label: 'Backend Services',
            onTap: () {
              if (widget.type == 'myproject') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Backend_screen(projectId: widget.projectId),
                  ),
                );
              } else {
                Fluttertoast.showToast(
                  msg: 'Unauthorized access',
                  backgroundColor: Colors.red,
                );
              }
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.data_saver_on_sharp),
            backgroundColor: Colors.green,
            label: 'Databases',
            onTap: () {
              if (widget.type == 'myproject') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Db_screen(projectId: widget.projectId),
                  ),
                );
              } else {
                Fluttertoast.showToast(
                  msg: 'Unauthorized access',
                  backgroundColor: Colors.red,
                );
              }
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.local_library),
            backgroundColor: Colors.orange,
            label: 'Copy Module From Library',
            onTap: () {
              if (widget.type == 'myproject') {
                _openPopup(context);
                _fetchLibraryModules();
              } else {
                Fluttertoast.showToast(
                  msg: 'Unauthorized access',
                  backgroundColor: Colors.red,
                );
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: CustomizedFooter(
        homeIcon: Icons.home,
        squareIcon: Icons.apps,
        addIcon: Icons.add,
        labels: const ['Home', 'Services', 'Add'],
        onTapActions: [
          () {
            // Navigate to Home
            print('Navigate to Home');
          },
          () {
            _loadModules();
            print(' Service List');
          },
          () {
            // Navigate to Add
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CreateModuleScreen(projectId: widget.projectId),
              ),
            ).then((_) {
              _loadModules();
            });
          },
        ],
      ),
    );
  }
}

class DropdownModuleModel {
  String? moduleName;
  int? id;

  DropdownModuleModel({this.moduleName, this.id});

  DropdownModuleModel.fromJson(Map<String, dynamic> json) {
    moduleName = json['moduleName'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['moduleName'] = this.moduleName;
    data['id'] = this.id;
    return data;
  }
}
