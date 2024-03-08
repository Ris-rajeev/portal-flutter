import 'dart:convert';

import 'package:authsec_flutter/screens/Components/List%20Builder/CreateListBuilder.dart';
import 'package:authsec_flutter/screens/Components/List%20Builder/ListBuilderService.dart';
import 'package:authsec_flutter/screens/Components/List%20Builder/UpdateListBuilder.dart';
import 'package:authsec_flutter/screens/main_app_screen/CustomizeFooter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:authsec_flutter/providers/token_manager.dart';
import 'package:http/http.dart' as http;

import '../../../resources/api_constants.dart';
import 'ListBuilderLine.dart';

class ListBuilder_screen extends StatefulWidget {
  final int projId;
  final int moduleId;

  ListBuilder_screen({required this.projId, required this.moduleId});

  static const String routeName = '/ListBuilder';

  @override
  _ListBuilder_screenState createState() => _ListBuilder_screenState();
}

class _ListBuilder_screenState extends State<ListBuilder_screen> {
  final ListBuilderApiService listService = ListBuilderApiService();
  List<Map<String, dynamic>> entities = [];
  bool showCardView = true; // Add this variable to control the view mode
  String? selectedLibraryListBuilder;
  String? selectedBackendListBuilder;
  bool lookuprequirementlib = false;

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
            await listService.getListBuilderBymoduleId(token, widget.moduleId);
        setState(() {
          entities = fetchedEntities;
          print('list is ... $entities');
        });
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to fetch ListBuilder: $e'),
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
      await listService.deleteListBuiulder(token!, entity['id']);
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

  Future<void> _addttoListBuilderLibrary(
      int listbuilderid, bool lookuptype) async {
    String baseUrl = ApiConstants.baseUrl;
    final token = await TokenManager.getToken();
    final apiUrl =
        '$baseUrl/listbuilder_library/lb/add/library?lbId=$listbuilderid&lookuptype=$lookuptype';
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token', // Include the token in the headers
        },
      );

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

  Future<List<DropdownListBuilderModel>> _fetchLibraryListBuilder() async {
    final token = await TokenManager.getToken();
    String baseUrl = ApiConstants.baseUrl;
    final apiUrl = '$baseUrl/listbuilder_library/lb/get_Lb_Header_library';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token', // Include the token in the headers
        },
      );
      final List<dynamic> responseData = json.decode(response.body);
      if (response.statusCode <= 209) {
        //islookuptype
        if (lookuprequirementlib == true) {
          print("lookup is true");
          responseData
              .removeWhere((element) => element['islookuptype'] == false);
        }
        return responseData.map((e) {
          final map = e as Map<String, dynamic>;
          return DropdownListBuilderModel(
              id: map['id'], lb_name: map['lb_name']);
        }).toList();
      } else {
        Fluttertoast.showToast(
          msg: 'Failed to fetch List builder',
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

  Future<List<DropdownBackendModel>> getBackendaByModuleid() async {
    final token = await TokenManager.getToken();
    int ModuleId = widget.moduleId;
    String baseUrl = ApiConstants.baseUrl;
    final apiUrl = '$baseUrl/BackendConfig/moduleid/$ModuleId';

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
          return DropdownBackendModel(
              id: map['id'], backend_service_name: map['backend_service_name']);
        }).toList();
      } else {
        Fluttertoast.showToast(
          msg: 'Failed to fetch List builder',
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

  void _copyListBuilder(int lbid, int backendid) async {
    String baseUrl = ApiConstants.baseUrl;
    int moduleidh = widget.moduleId;
    final token = await TokenManager.getToken();
    final apiUrl =
        '$baseUrl/listbuilder_library/lb/copy/from_library?lbId=$lbid&moduleid=$moduleidh&backendId=$backendid';
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

  void _openPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // StatefulBuilder is used to allow updating the dialog's state.

            return AlertDialog(
              title: const Text('Select List Builders'),
              content: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: FutureBuilder<List<DropdownListBuilderModel>>(
                      future: _fetchLibraryListBuilder(),
                      builder: (context, librarySnapshot) {
                        if (librarySnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (librarySnapshot.hasError) {
                          return Text(
                              'Error loading library data: ${librarySnapshot.error}');
                        } else if (!librarySnapshot.hasData ||
                            librarySnapshot.data!.isEmpty) {
                          return Text('No library data available.');
                        } else {
                          return DropdownButton<String>(
                            isExpanded: true,
                            value: selectedLibraryListBuilder,
                            hint: const Text("Select Library List builder"),
                            items: librarySnapshot.data!.map((e) {
                              return DropdownMenuItem(
                                value: e.id.toString(),
                                child: Text(e.lb_name.toString()),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedLibraryListBuilder = value;
                              });
                            },
                          );
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder<List<DropdownBackendModel>>(
                      future: getBackendaByModuleid(),
                      builder: (context, backendSnapshot) {
                        if (backendSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (backendSnapshot.hasError) {
                          return Text(
                              'Error loading backend data: ${backendSnapshot.error}');
                        } else if (!backendSnapshot.hasData ||
                            backendSnapshot.data!.isEmpty) {
                          return Text('No backend data available.');
                        } else {
                          return DropdownButton<String>(
                            isExpanded: true,
                            value: selectedBackendListBuilder,
                            hint: const Text("Select Backend"),
                            items: backendSnapshot.data!.map((e) {
                              return DropdownMenuItem(
                                value: e.id.toString(),
                                child: Text(e.backend_service_name.toString()),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedBackendListBuilder = value;
                              });
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
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
                    if (selectedLibraryListBuilder != null &&
                        selectedBackendListBuilder != null) {
                      print(
                          'Library List Builder: $selectedLibraryListBuilder');
                      print(
                          'Backend List Builder: $selectedBackendListBuilder');
                      int backendid = int.parse(selectedBackendListBuilder!);
                      int lbid = int.parse(selectedLibraryListBuilder!);
                      _copyListBuilder(lbid, backendid);
                      fetchEntities();
                      Navigator.of(context).pop();
                    } else {
                      print('No List Builders selected.');
                    }
                  },
                  child: Text('Submit'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      lookuprequirementlib =
                          !lookuprequirementlib; // Toggle the value
                      _fetchLibraryListBuilder();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: lookuprequirementlib ? Colors.red : Colors.green,
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Text(
                      lookuprequirementlib ? 'LookupType(true)' : 'LookupType'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Builders'),
        actions: [
          // Add a switch in the app bar to toggle between card view and normal view
          // Switch(
          //   activeColor: Colors.greenAccent,
          //   inactiveThumbColor: Colors.white,
          //   value: showCardView,
          //   onChanged: (value) {
          //     setState(() {
          //       showCardView = value;
          //     });
          //   },
          // ),
          IconButton(
            icon: const Icon(Icons.local_library),
            tooltip: 'Copy From Library',
            onPressed: () {
              _openPopup(context);
            },
          )
        ],
      ),
      body: entities.isEmpty
          ? const Center(
              child: Text('No List found.'),
            )
          : ListView.builder(
              itemCount: entities.length,
              itemBuilder: (BuildContext context, int index) {
                final entity = entities[index];
                return _buildListItem(entity);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateListBuilderScreen(
                moduleId: widget.moduleId,
              ),
            ),
          ).then((_) {
            fetchEntities();
          });
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: CustomizedFooter(
        homeIcon: Icons.home,
        squareIcon: Icons.apps,
        addIcon: Icons.add,
        labels: const ['Home', 'List Builder', 'Add'],
        onTapActions: [
          () {
            // Navigate to Home
            print('Navigate to Home');
          },
          () {
            fetchEntities();
            print(' List Builder List');
          },
          () {
            // Navigate to Add
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateListBuilderScreen(
                  moduleId: widget.moduleId,
                ),
              ),
            ).then((_) {
              fetchEntities();
            });
          },
        ],
      ),
    );
  }

  bool isLookupTypeTrue = false;

  Future<void> _openLookupPopup(int listbuilderid) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Lookup Type'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text('False'),
                  Switch(
                    value: isLookupTypeTrue,
                    onChanged: (value) {
                      setState(() {
                        isLookupTypeTrue = value;
                      });
                      Navigator.of(context).pop();
                      _openLookupPopup(listbuilderid);
                    },
                  ),
                  Text('True'),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Submit'),
              onPressed: () {
                print(listbuilderid);
                print(isLookupTypeTrue);
                _addttoListBuilderLibrary(listbuilderid, isLookupTypeTrue);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Function to build list items
  Widget _buildListItem(Map<String, dynamic> entity) {
    return showCardView ? _buildCardView(entity) : _buildNormalView(entity);
  }

  // Function to build card view for a list item
  Widget _buildCardView(Map<String, dynamic> entity) {
    return Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: _buildNormalView(entity));
  }

  // Function to build normal view for a list item
  Widget _buildNormalView(Map<String, dynamic> entity) {
    return ListTile(
      title: Text(entity['id'].toString()),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(entity['lb_name'] ?? 'No Name provided'),
          const SizedBox(height: 4),
          Text(entity['description'] ?? 'No Description Provided'),
          const SizedBox(height: 4),
          Text(entity['testing'].toString()),
          const SizedBox(height: 4),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  // List<dynamic> lblinelist = entity['lb_Line'];
                  // lblinelist.isEmpty? Fluttertoast.showToast(
                  //   msg: 'List Builder line not available',
                  //   backgroundColor: Colors.red,
                  // ):
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ListBuilderLineBuilder(
                            projId: widget.projId,
                            headerId: entity['id'],
                            entity: entity['lb_Line'][0])),
                  );
                },
                child: Text('List Builder Line'),
              ),
              IconButton(
                icon: const Icon(Icons.library_add_outlined),
                tooltip: 'Add to Library',
                onPressed: () {
                  final listbuilderid = entity['id'];
                  _openLookupPopup(listbuilderid);
                },
              )
            ],
          )
        ],
      ),
      trailing: _buildPopupMenu(entity),
    );
  }

  // Function to build popup menu for a list item
  Widget _buildPopupMenu(Map<String, dynamic> entity) {
    return PopupMenuButton<String>(
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
          const PopupMenuItem<String>(
            value: 'WHO',
            child: Row(
              children: [
                Icon(Icons.manage_accounts_outlined),
                SizedBox(width: 8),
                Text('WHO'),
              ],
            ),
          ),
        ];
      },
      onSelected: (String value) {
        if (value == 'edit') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UpdateListBuilderScreen(
                  moduleId: widget.moduleId, entity: entity),
            ),
          ).then((_) {
            fetchEntities();
          });
        } else if (value == 'delete') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Confirm Deletion'),
                content:
                    const Text('Are you sure you want to delete ListBuilder?'),
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
        } else if (value == 'WHO') {
          _showAdditionalFieldsDialog(context, entity);
        }
      },
    );
  }

  // Function to show additional fields in a dialog
  void _showAdditionalFieldsDialog(
    BuildContext context,
    Map<String, dynamic> entity,
  ) {
    final dateFormat =
        DateFormat('yyyy-MM-dd HH:mm:ss'); // Define your desired date format

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('WHO'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  'Created At: ${_formatTimestamp(entity['createdAt'], dateFormat)}'),
              Text('Created By: ${entity['createdBy'] ?? 'N/A'}'),
              Text('Updated By: ${entity['updatedBy'] ?? 'N/A'}'),
              Text(
                  'Updated At: ${_formatTimestamp(entity['updatedAt'], dateFormat)}'),
              Text('Account ID: ${entity['accountId'] ?? 'N/A'}'),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String _formatTimestamp(dynamic timestamp, DateFormat dateFormat) {
    if (timestamp is int) {
      // If it's an integer, assume it's a Unix timestamp in milliseconds
      final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      return dateFormat.format(dateTime);
    } else if (timestamp is String) {
      // If it's a string, assume it's already formatted as a date
      return timestamp;
    } else {
      // Handle other cases here if needed
      return 'N/A';
    }
  }
}

class DropdownListBuilderModel {
  String? lb_name;
  int? id;

  DropdownListBuilderModel({this.lb_name, this.id});

  DropdownListBuilderModel.fromJson(Map<String, dynamic> json) {
    lb_name = json['lb_name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lb_name'] = this.lb_name;
    data['id'] = this.id;
    return data;
  }
}

class DropdownBackendModel {
  String? backend_service_name;
  int? id;

  DropdownBackendModel({this.backend_service_name, this.id});

  DropdownBackendModel.fromJson(Map<String, dynamic> json) {
    backend_service_name = json['backend_service_name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['backend_service_name'] = this.backend_service_name;
    data['id'] = this.id;
    return data;
  }
}
