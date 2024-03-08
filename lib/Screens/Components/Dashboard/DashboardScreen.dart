import 'dart:math';

import 'package:authsec_flutter/screens/Components/Dashboard/CreateDashboard.dart';
import 'package:authsec_flutter/screens/Components/Dashboard/DashboardLine.dart';
import 'package:authsec_flutter/screens/Components/Dashboard/Dashboard_Service.dart';
import 'package:authsec_flutter/screens/Components/Dashboard/UpdateDashboard.dart';
import 'package:authsec_flutter/screens/main_app_screen/CustomizeFooter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:authsec_flutter/providers/token_manager.dart';

class Dashboard_screen extends StatefulWidget {
  final int projId;
  final int moduleId; // Pass the moduleId to this screen

  Dashboard_screen({required this.projId, required this.moduleId});

  static const String routeName = '/dashboard';

  @override
  // ignore: library_private_types_in_public_api
  _Dashboard_screenState createState() => _Dashboard_screenState();
}

class _Dashboard_screenState extends State<Dashboard_screen> {
  final DashboardApiService dashService = DashboardApiService();
  List<Map<String, dynamic>> entities = [];
  bool showCardView = true; // Add this variable to control the view mode

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
            await dashService.getdashboardBymoduleId(token, widget.moduleId);
        setState(() {
          entities = fetchedEntities;
          print('dash is ... $entities');
        });
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to fetch Dashboard: $e'),
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
      await dashService.deletedashboard(token!, entity['id']);
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

  // Future<List<DropdownWireFrameModel>> _fetchLibraryWireFrame() async {
  //   final token = await TokenManager.getToken();
  //   String baseUrl = ApiConstants.baseUrl;
  //   final apiUrl = '$baseUrl/wflibrary/copylib/getall_wf_lib';

  //   try {
  //     final response = await http.get(
  //       Uri.parse(apiUrl),
  //       headers: {
  //         'Authorization': 'Bearer $token', // Include the token in the headers
  //       },
  //     );
  //     final List<dynamic> responseData = json.decode(response.body);
  //     if (response.statusCode <= 209) {
  //       return responseData.map((e) {
  //         final map = e as Map<String, dynamic>;
  //         return DropdownWireFrameModel(id: map['id'], uiName: map['uiName']);
  //       }).toList();
  //     } else {
  //       Fluttertoast.showToast(
  //         msg: 'Failed to fetch projects',
  //         backgroundColor: Colors.red,
  //       );
  //       throw Exception("Failed");
  //     }
  //   } catch (error) {
  //     Fluttertoast.showToast(
  //       msg: 'Error: $error',
  //       backgroundColor: Colors.red,
  //     );
  //     throw Exception("Failed");
  //   }
  // }

  // void _openPopup(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           // StatefulBuilder is used to allow updating the dialog's state.

  //           return AlertDialog(
  //             title: const Text('Select a Wireframe'),
  //             content: FutureBuilder<List<DropdownWireFrameModel>>(
  //               future: _fetchLibraryWireFrame(),
  //               builder: (context, snapshot) {
  //                 if (snapshot.connectionState == ConnectionState.waiting) {
  //                   return CircularProgressIndicator();
  //                 } else if (snapshot.hasError) {
  //                   return Text('Error loading data: ${snapshot.error}');
  //                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
  //                   return Text('No data available.');
  //                 } else {
  //                   return DropdownButton<String>(
  //                     isExpanded: true,
  //                     value: selectedValues,
  //                     hint: const Text("Select Library Wireframe"),
  //                     items: snapshot.data!.map((e) {
  //                       return DropdownMenuItem(
  //                         value: e.id.toString(),
  //                         child: Text(e.uiName.toString()),
  //                       );
  //                     }).toList(),
  //                     onChanged: (value) {
  //                       print(value);
  //                       setState(() {
  //                         selectedValues = value;
  //                       });
  //                     },
  //                   );
  //                 }
  //               },
  //             ),
  //             actions: [
  //               TextButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //                 child: Text('Cancel'),
  //               ),
  //               ElevatedButton(
  //                 onPressed: () {
  //                   if (selectedValues != null) {
  //                     print(selectedValues);
  //                     _copyWireFrame();
  //                     fetchEntities();
  //                     Navigator.of(context).pop();
  //                   } else {
  //                     print('No Wireframe selected.');
  //                   }
  //                 },
  //                 child: Text('Submit'),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  // void _copyWireFrame() async {
  //   int moduleid = widget.moduleId;

  //   String baseUrl = ApiConstants.baseUrl;
  //   final token = await TokenManager.getToken();
  //   final apiUrl =
  //       '$baseUrl/wflibrary/copylib/copy_library/$selectedValues/$moduleid';
  //   print(apiUrl);
  //   try {
  //     final response = await http.get(
  //       Uri.parse(apiUrl),
  //       headers: {
  //         'Authorization': 'Bearer $token', // Include the token in the headers
  //       },
  //     );
  //     if (response.statusCode <= 209) {
  //       setState(() {
  //         entities.add(json.decode((response.body)));
  //       });
  //       Fluttertoast.showToast(
  //         msg: 'Copy successful',
  //         backgroundColor: Colors.green,
  //       );
  //     } else {
  //       Fluttertoast.showToast(
  //         msg: 'Copy failed',
  //         backgroundColor: Colors.red,
  //       );
  //     }
  //   } catch (error) {
  //     Fluttertoast.showToast(
  //       msg: 'Error: $error',
  //       backgroundColor: Colors.red,
  //     );
  //   }
  // }

  // Future<void> _addtoWireFrameLibrary(int wireframeId) async {
  //   String baseUrl = ApiConstants.baseUrl;
  //   final token = await TokenManager.getToken();
  //   final apiUrl = '$baseUrl/wflibrary/copylib/copy_library/$wireframeId';
  //   try {
  //     final response = await http.get(
  //       Uri.parse(apiUrl),
  //       headers: {
  //         'Authorization': 'Bearer $token', // Include the token in the headers
  //       },
  //     );

  //     if (response.statusCode! <= 209) {
  //       Fluttertoast.showToast(
  //         msg: 'Copy successful',
  //         backgroundColor: Colors.green,
  //       );
  //     } else {
  //       Fluttertoast.showToast(
  //         msg: 'Copy failed',
  //         backgroundColor: Colors.red,
  //       );
  //     }
  //   } catch (error) {
  //     Fluttertoast.showToast(
  //       msg: 'Error: $error',
  //       backgroundColor: Colors.red,
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entity List'),
        actions: [
          // Add a switch in the app bar to toggle between card view and normal view
          Switch(
            activeColor: Colors.greenAccent,
            inactiveThumbColor: Colors.white,
            value: showCardView,
            onChanged: (value) {
              setState(() {
                showCardView = value;
              });
            },
          ),
        ],
      ),
      body: entities.isEmpty
          ? const Center(
              child: Text('No Dashboards found.'),
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
              builder: (context) => CreateDashboardScreen(
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
        labels: const ['Home', 'Dashboard', 'Add'],
        onTapActions: [
          () {
            // Navigate to Home
            print('Navigate to Home');
          },
          () {
            fetchEntities();
            print(' Dashboard List');
          },
          () {
            // Navigate to Add
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateDashboardScreen(
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
          Text(entity['dashboard_name'] ?? 'No Name provided'),
          const SizedBox(height: 4),
          Text(entity['secuirity_profile'] ?? 'No Secuirity Profile'),
          const SizedBox(height: 4),
          Text(entity['testing'].toString()),
          const SizedBox(height: 4),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DashboardLineBuilder(
                        entity: entity['dashbord1_Line'][0],
                      ),
                    ),
                  );

                  print('dash line is ...' + entity['dashbord1_Line'][0]);
                },
                child: const Text('Dashboard Line'),
              ),
              // IconButton(
              //   icon: const Icon(Icons.library_add_outlined),
              //   tooltip: 'Add Wireframe to Library',
              //   onPressed: () {
              //     final wireframeid = entity['id'];
              //     _addtoWireFrameLibrary(wireframeid);
              //   },
              // )
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
              builder: (context) => UpdateDashboardScreen(
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
                    const Text('Are you sure you want to delete Dashboard?'),
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
          title: const Text('Additional Fields'),
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
