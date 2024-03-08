import 'dart:convert';

import 'package:authsec_flutter/screens/Components/Wireframes/CreateWireframe.dart';
import 'package:authsec_flutter/screens/Components/Wireframes/DragandandDrop.dart';
import 'package:authsec_flutter/screens/Components/Wireframes/UpdateWireframe.dart';
import 'package:authsec_flutter/screens/Components/Wireframes/Wireframe_Service.dart';
import 'package:authsec_flutter/screens/main_app_screen/CustomizeFooter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:authsec_flutter/providers/token_manager.dart';
import 'package:http/http.dart' as http;

import '../../../resources/api_constants.dart';

class Wireframe_screen extends StatefulWidget {
  final int projId;
  final int moduleId;
  final String type;

  Wireframe_screen(
      {required this.projId, required this.moduleId, required this.type});

  static const String routeName = '/wfmodel';

  @override
  // ignore: library_private_types_in_public_api
  _Wireframe_screenState createState() => _Wireframe_screenState();
}

class _Wireframe_screenState extends State<Wireframe_screen> {
  final WireframeApiService apiService = WireframeApiService();
  List<Map<String, dynamic>> entities = [];
  var selectedValues;

  @override
  void initState() {
    super.initState();
    fetchEntities();
  }

  Future<void> fetchEntities() async {
    try {
      final token = await TokenManager.getToken();

      if (token != null) {
        final fetchedEntities =
            await apiService.getwirrframeBymoduleId(token, widget.moduleId);
        setState(() {
          entities = fetchedEntities;
        });
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to fetch entities: $e'),
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

  Future<void> deleteEntity(Map<String, dynamic> entity) async {
    try {
      final token = await TokenManager.getToken();
      await apiService.deleteWireframe(token!, entity['id']);
      setState(() {
        entities.remove(entity);
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to delete wireframe: $e'),
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

  Future<List<DropdownWireFrameModel>> _fetchLibraryWireFrame() async {
    final token = await TokenManager.getToken();
    String baseUrl = ApiConstants.baseUrl;
    final apiUrl = '$baseUrl/wflibrary/copylib/getall_wf_lib';

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
          return DropdownWireFrameModel(id: map['id'], uiName: map['uiName']);
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
              title: const Text('Select a Wireframe'),
              content: FutureBuilder<List<DropdownWireFrameModel>>(
                future: _fetchLibraryWireFrame(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error loading data: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No data available.');
                  } else {
                    return DropdownButton<String>(
                      isExpanded: true,
                      value: selectedValues,
                      hint: const Text("Select Library Wireframe"),
                      items: snapshot.data!.map((e) {
                        return DropdownMenuItem(
                          value: e.id.toString(),
                          child: Text(e.uiName.toString()),
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
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (selectedValues != null) {
                      print(selectedValues);
                      _copyWireFrame();
                      fetchEntities();
                      Navigator.of(context).pop();
                    } else {
                      print('No Wireframe selected.');
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _copyWireFrame() async {
    int moduleid = widget.moduleId;

    String baseUrl = ApiConstants.baseUrl;
    final token = await TokenManager.getToken();
    final apiUrl =
        '$baseUrl/wflibrary/copylib/copy_library/$selectedValues/$moduleid';
    print(apiUrl);
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token', // Include the token in the headers
        },
      );
      if (response.statusCode <= 209) {
        setState(() {
          entities.add(json.decode((response.body)));
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

  Future<void> _addtoWireFrameLibrary(int wireframeId) async {
    String baseUrl = ApiConstants.baseUrl;
    final token = await TokenManager.getToken();
    final apiUrl = '$baseUrl/wflibrary/copylib/copy_library/$wireframeId';
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token', // Include the token in the headers
        },
      );

      if (response.statusCode <= 209) {
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
      appBar: AppBar(title: const Text('Wireframe List'), actions: [
        widget.type == 'myproject'
            ? IconButton(
                icon: const Icon(Icons.local_library),
                tooltip: 'Copy From Library',
                onPressed: () {
                  _openPopup(context);
                },
              )
            : IconButton(
                icon: const Icon(Icons.local_library),
                tooltip: 'Copy From Library',
                onPressed: () {
                  Fluttertoast.showToast(
                    msg: 'Unauthorized access',
                    backgroundColor: Colors.red,
                  );
                },
              ),
      ]),
      body: entities.isEmpty
          ? const Center(
              child: Text('No entities found.'),
            )
          : ListView.builder(
              itemCount: entities.length,
              itemBuilder: (BuildContext context, int index) {
                final entity = entities[index];
                return ListTile(
                  title: Text(entity['id'].toString()),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(entity['uiName'] ?? 'No name provided'),
                      const SizedBox(height: 4),
                      Text(entity['testing'].toString()),
                      const SizedBox(height: 4),
                      Text(
                          entity['package_name'] ?? 'No Package Name provided'),
                      const SizedBox(height: 4),
                      // Added address text
                      Row(
                        children: [
                          widget.type == 'myproject'
                              ? ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DragAndDropFormBuilder(
                                          projId: widget.projId,
                                          headerId: entity['id'],
                                          moduleId: widget.moduleId,
                                          backendId: entity['backend_id'],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text('WF Line'),
                                )
                              : ElevatedButton(
                                  onPressed: () {
                                    Fluttertoast.showToast(
                                      msg: 'Unauthorized access',
                                      backgroundColor: Colors.red,
                                    );
                                  },
                                  child: Text('WF Line'),
                                ),
                          widget.type == 'myproject'
                              ? IconButton(
                                  icon: const Icon(Icons.library_add_outlined),
                                  tooltip: 'Add Wireframe to Library',
                                  onPressed: () {
                                    final wireframeid = entity['id'];
                                    _addtoWireFrameLibrary(wireframeid);
                                  },
                                )
                              : IconButton(
                                  icon: const Icon(
                                    Icons.library_add_outlined,
                                    color: Colors.grey,
                                  ),
                                  tooltip: 'Add Wireframe to Library',
                                  onPressed: () {
                                    Fluttertoast.showToast(
                                      msg: 'Unauthorized access',
                                      backgroundColor: Colors.red,
                                    );
                                  },
                                )
                        ],
                      )
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    itemBuilder: (BuildContext context) {
                      return [
                        const PopupMenuItem<String>(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete),
                              SizedBox(width: 8),
                              Text('Delete'),
                            ],
                          ),
                        ),
                      ];
                    },
                    onSelected: (String value) {
                      if (value == 'edit' && widget.type == 'myproject') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateWireframeScreen(
                              moduleId: widget.moduleId,
                              entity: entity,
                              projId: widget.projId,
                            ),
                          ),
                        ).then((_) {
                          fetchEntities();
                        });
                      } else if (value == 'delete' &&
                          widget.type == 'myproject') {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Confirm Deletion'),
                              content: const Text(
                                  'Are you sure you want to delete this entity?'),
                              actions: [
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text('Delete'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    deleteEntity(entity);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        Fluttertoast.showToast(
                          msg: 'Unauthorized access',
                          backgroundColor: Colors.red,
                        );
                      }
                    },
                  ),
                );
              },
            ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) =>
      //             CreateWireframeScreen(moduleId: widget.moduleId),
      //       ),
      //     ).then((_) {
      //       fetchEntities();
      //     });
      //   },
      //   child: const Icon(Icons.add),
      // ),

      bottomNavigationBar: CustomizedFooter(
        homeIcon: Icons.home,
        squareIcon: Icons.apps,
        addIcon: Icons.add,
        labels: const ['Home', 'Wireframe List', 'Add'],
        onTapActions: [
          () {
            // Navigate to Home
            print('Navigate to Home');
          },
          () {
            fetchEntities();
            print(' Wireframe List');
          },
          () {
            if (widget.type == 'myproject') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CreateWireframeScreen(moduleId: widget.moduleId),
                ),
              ).then((_) {
                fetchEntities();
              });
              print('Add Wireframe');
            } else {
              Fluttertoast.showToast(
                msg: 'Unauthorized access',
                backgroundColor: Colors.red,
              );
            }
          },
        ],
      ),
    );
  }
}

class DropdownWireFrameModel {
  String? uiName;
  int? id;

  DropdownWireFrameModel({this.uiName, this.id});

  DropdownWireFrameModel.fromJson(Map<String, dynamic> json) {
    uiName = json['uiName'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uiName'] = this.uiName;
    data['id'] = this.id;
    return data;
  }
}
