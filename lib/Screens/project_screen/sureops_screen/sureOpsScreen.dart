// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:authsec_flutter/screens/project_screen/sureops_screen/sure_farm_screen.dart';
import 'package:authsec_flutter/screens/project_screen/sureops_screen/sure_image_screen.dart';
import 'package:authsec_flutter/screens/project_screen/sureops_screen/surepipe_screen/sure_pipe_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

// class SureOpsScreen extends StatelessWidget {
//   final Map<String, dynamic> project; // Add projectId parameter
//   final String type;
//   final Map<String, dynamic> userData;
//   SureOpsScreen(
//       {required this.project,
//       required this.type,
//       required this.userData}); // Initialize projectId
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2, // Number of tabs/sections
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('SureOps'),
//           bottom: const TabBar(
//             tabs: [
//               Tab(text: 'SurePipe'),
//               Tab(text: 'SureFarm'),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             // SurePipe Content
//             SurePipeContent(project: project, type: type, userData: userData),
//             SureFarmContent(projectId: project['id']),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

import '../../../providers/token_manager.dart';
import '../../../resources/api_constants.dart';
import '../project_service.dart';

class SureOpsScreen extends StatefulWidget {
  final Map<String, dynamic> project;
  final String type;
  final Map<String, dynamic> userData;

  SureOpsScreen({
    required this.project,
    required this.type,
    required this.userData,
  });

  @override
  _SureOpsScreenState createState() => _SureOpsScreenState();
}

class _SureOpsScreenState extends State<SureOpsScreen> {
  void _onBottomNavigationBarItemTapped(int index) {
    switch (index) {
      case 0:
        if (widget.type == 'myproject') {
          _showVersionPopup(context);
        } else {
          Fluttertoast.showToast(
            msg: 'Unauthorized access',
            backgroundColor: Colors.red,
          );
        }
        break;
      case 1:
        if (widget.type == 'myproject') {
          _openHealthCheckup(context, 'create_deployment').then((result) {
            if (result == true) {
              _buildImage(context).then((value) => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SureOpsScreen(
                                project: widget.project,
                                type: widget.type,
                                userData: widget.userData)))
                  });
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SureOpsScreen(
                          project: widget.project,
                          type: widget.type,
                          userData: widget.userData)));
            }
          });
        } else {
          Fluttertoast.showToast(
            msg: 'Unauthorized access',
            backgroundColor: Colors.red,
          );
        }
        break;
      case 2:
        if (widget.type == 'myproject') {
          showDialog(
            context: context,
            builder: (context) {
              return BuildImageInfoPopup(projectId: widget.project['id']);
            },
          );
        } else {
          Fluttertoast.showToast(
            msg: 'Unauthorized access',
            backgroundColor: Colors.red,
          );
        }
        break;
      case 3:
        if (widget.type == 'myproject') {
          _openHealthCheckup(context, 'deploy_app').then((result) {
            if (result == true) {
              _deployImage(context).then((value) => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SureOpsScreen(
                                project: widget.project,
                                type: widget.type,
                                userData: widget.userData)))
                  });
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SureOpsScreen(
                          project: widget.project,
                          type: widget.type,
                          userData: widget.userData)));
            }
          });
        } else {
          Fluttertoast.showToast(
            msg: 'Unauthorized access',
            backgroundColor: Colors.red,
          );
        }
        break;
      default:
        break;
    }
  }

  ProjectApiService apiService = ProjectApiService();

  Future<Map<String, dynamic>> _buildImageApiCall() async {
    int projectId = widget.project['id'];
    final token = await TokenManager.getToken();
    const String baseUrlSureOps = ApiConstants.baseUrlSureOps;
    final String apiUrl = '$baseUrlSureOps/sureops/deployapp/$projectId/3';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token', // Attach the token as a Bearer token
      },
    );

    if (response.statusCode <= 209) {
      const String baseUrlbuildBackedn = ApiConstants.baseUrlBuildBackend;
      int userid = widget.userData['userId'];
      print(userid);
      final String message =
          widget.project['projectName'] + ' Build Image Successful';
      final String apiUrl2 = '$baseUrlbuildBackedn/saveemailbyuserid/$userid';
      final response2 = await http.post(Uri.parse(apiUrl2),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: json.encode({"message": message, "token": token}));
      if (response2.statusCode <= 209) {
        print("email sent success");
      }
      return {
        "status": "success",
      };
    } else {
      return {
        "status": "unsuccessful",
      };
    }
  }

  Future<bool?> _buildImage(BuildContext context) async {
    final result = await showDialog<bool?>(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder(
          future: _buildImageApiCall(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show a progress indicator while checking health
              return AlertDialog(
                title: Text('Work in progress...'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    Text('Please wait while Build Image.'),
                  ],
                ),
              );
            } else if (snapshot.hasData) {
              final healthStatus = snapshot.data?["status"];
              final isHealthy = healthStatus == "success";

              return AlertDialog(
                title: Text('Build Image Status'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isHealthy ? Icons.check_circle : Icons.cancel,
                      color: isHealthy ? Colors.green : Colors.red,
                      size: 48.0,
                    ),
                    Text(isHealthy
                        ? 'Build Image Success'
                        : 'Unable to Build Image'),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context,
                            isHealthy); // Return true for Proceed, false for Cancel
                      },
                      child: Text(isHealthy ? 'Close' : 'Cancel'),
                    ),
                  ],
                ),
              );
            } else {
              return AlertDialog(
                title: Text('Error'),
                content: Text('An error occurred while Build Image.'),
              );
            }
          },
        );
      },
    );
    return result;
  }

  Future<Map<String, dynamic>> _deployImageApiCall() async {
    int projectId = widget.project['id'];
    final token = await TokenManager.getToken();
    final String baseUrlSureOps = ApiConstants.baseUrlSureOps;
    final String apiUrl = '$baseUrlSureOps/sureops/deployimage/$projectId';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token', // Attach the token as a Bearer token
      },
    );

    if (response.statusCode <= 209) {
      const String baseUrlbuildBackedn = ApiConstants.baseUrlBuildBackend;
      print(widget.userData);
      int userid = widget.userData['userId'];
      final String message =
          widget.project['projectName'] + ' Deploy Image Successful';
      final String apiUrl2 = '$baseUrlbuildBackedn/saveemailbyuserid/$userid';
      final response2 = await http.post(Uri.parse(apiUrl2),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: json.encode({"message": message, "token": token}));
      if (response2.statusCode <= 209) {
        print("email sent success");
      }
      return {
        "status": "success",
      };
    } else {
      return {
        "status": "unsuccessful",
      };
    }
  }

  Future<bool?> _deployImage(BuildContext context) async {
    final result = await showDialog<bool?>(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder(
          future: _deployImageApiCall(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return AlertDialog(
                title: Text('Work in progress...'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    Text('Please wait while Deploy Image.'),
                  ],
                ),
              );
            } else if (snapshot.hasData) {
              final healthStatus = snapshot.data?["status"];
              final isHealthy = healthStatus == "success";

              return AlertDialog(
                title: Text('Build Image Status'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isHealthy ? Icons.check_circle : Icons.cancel,
                      color: isHealthy ? Colors.green : Colors.red,
                      size: 48.0,
                    ),
                    Text(isHealthy
                        ? 'Deploy Image Success'
                        : 'Unable to Deploy Image'),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context,
                            isHealthy); // Return true for Proceed, false for Cancel
                      },
                      child: Text(isHealthy ? 'Close' : 'Cancel'),
                    ),
                  ],
                ),
              );
            } else {
              return AlertDialog(
                title: Text('Error'),
                content: Text('An error occurred while deploy Image.'),
              );
            }
          },
        );
      },
    );
    return result;
  }

  Future<bool?> _openHealthCheckup(
      BuildContext context, String checkparam) async {
    final result = await showDialog<bool?>(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder(
          future: _checkHealth(checkparam),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show a progress indicator while checking health
              return AlertDialog(
                title: Text('Checking Health...'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    Text(
                        'Please wait while we check the health of your services.'),
                  ],
                ),
              );
            } else if (snapshot.hasData) {
              final healthStatus = snapshot.data?["status"];
              final isHealthy = healthStatus == "healthy";
              final List<String>? unhealthyServices =
                  snapshot.data?["unhealthyServices"];

              return AlertDialog(
                title: Text('Health Check'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isHealthy ? Icons.check_circle : Icons.cancel,
                      color: isHealthy ? Colors.green : Colors.red,
                      size: 48.0,
                    ),
                    Text(isHealthy
                        ? 'All services are running properly.'
                        : 'Some services are not running properly: ${unhealthyServices?.join(", ")}'),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context,
                            isHealthy); // Return true for Proceed, false for Cancel
                      },
                      child: Text(isHealthy ? 'Proceed' : 'Cancel'),
                    ),
                  ],
                ),
              );
            } else {
              // Error occurred during health check
              return AlertDialog(
                title: Text('Error'),
                content: Text('An error occurred while checking health.'),
              );
            }
          },
        );
      },
    );

    return result; // Return the result obtained from the dialog
  }

  Future<Map<String, dynamic>> _buildAppApiCall(
      int majorversion, int minorversion) async {
    int projectId = widget.project['id'];
    final token = await TokenManager.getToken();
    const String baseUrlSureOps = ApiConstants.baseUrlBuildBackend;
    final String apiUrl =
        '$baseUrlSureOps/entityBuilder/BuildByProject/$projectId/$majorversion/$minorversion';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token', // Attach the token as a Bearer token
      },
    );
    //final Map<String, dynamic> healthData = response;
    // print('health data $healthData');
    if (response.statusCode <= 209) {
      const String baseUrlbuildBackedn = ApiConstants.baseUrlBuildBackend;
      int userid = widget.userData['userId'];
      final String message =
          widget.project['projectName'] + ' Build App Successful';
      final String apiUrl2 = '$baseUrlbuildBackedn/saveemailbyuserid/$userid';
      final response2 = await http.post(Uri.parse(apiUrl2),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: json.encode({"message": message, "token": token}));
      if (response2.statusCode <= 209) {
        print("email sent success");
      }
      return {
        "status": "success",
      };
    } else {
      return {
        "status": "unsuccessful",
      };
    }
  }

  Future<bool?> _buildApp(
      BuildContext context, int majorversion, int minorversion) async {
    final result = await showDialog<bool?>(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder(
          future: _buildAppApiCall(majorversion, minorversion),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return AlertDialog(
                title: Text('Work In Process...'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    Text('Please wait while work in process.'),
                  ],
                ),
              );
            } else if (snapshot.hasData) {
              final healthStatus = snapshot.data?["status"];
              final isHealthy = healthStatus == "success";

              return AlertDialog(
                title: Text('Build App'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isHealthy ? Icons.check_circle : Icons.cancel,
                      color: isHealthy ? Colors.green : Colors.red,
                      size: 48.0,
                    ),
                    Text(isHealthy
                        ? 'Build App Successfull'
                        : 'Some Issue While Build App'),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context,
                            isHealthy); // Return true for Proceed, false for Cancel
                      },
                      child: Text(isHealthy ? 'Close' : 'Cancel'),
                    ),
                  ],
                ),
              );
            } else {
              // Error occurred during health check
              return AlertDialog(
                title: Text('Error'),
                content: Text('An error occurred while checking health.'),
              );
            }
          },
        );
      },
    );
    return result;
  }

  Future<Map<String, dynamic>> _checkHealth(String paramreq) async {
    final token = await TokenManager.getToken();
    final response = await apiService.getHealth(
        token!, paramreq); // Implement this method in your code
    final Map<String, dynamic> healthData = response;
    print('health data $healthData');
    List<String> notRunningServices =
        healthData['notRunningServices'].cast<String>();

    print(notRunningServices.toString());
    if (notRunningServices.isEmpty) {
      return {
        "status": "healthy",
      };
    } else {
      return {
        "status": "unhealthy",
        "unhealthyServices": notRunningServices,
      };
    }
  }

  TextEditingController majorVersionController = TextEditingController();
  TextEditingController minorVersionController = TextEditingController();
  // bool isBuildingApp = false;
  // void _showVersionPopup(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text("Enter Version Numbers"),
  //         content: Column(
  //           children: <Widget>[
  //             TextField(
  //               controller: majorVersionController,
  //               keyboardType: TextInputType.number,
  //               decoration: const InputDecoration(labelText: "Major Version"),
  //             ),
  //             TextField(
  //               controller: minorVersionController,
  //               keyboardType: TextInputType.number,
  //               decoration: const InputDecoration(labelText: "Minor Version"),
  //             ),
  //           ],
  //         ),
  //         actions: <Widget>[
  //           ElevatedButton(
  //             onPressed: () {
  //               _openHealthCheckup(context).then((result) {
  //                 if (result == true) {
  //                   int majorVersion =
  //                       int.tryParse(majorVersionController.text) ?? 0;
  //                   int minorVersion =
  //                       int.tryParse(minorVersionController.text) ?? 0;
  //                   _buildApp(context, majorVersion, minorVersion).then((_) {
  //                     Navigator.of(context).pop();
  //                   });
  //                   Navigator.of(context).pop();
  //                 } else {
  //                   Navigator.of(context).pop();
  //                 }
  //               });
  //             },
  //             child: const Text("BUILD APP"),
  //           )
  //
  //       ],
  //       );
  //     },
  //   );
  // }

  void _showVersionPopup(BuildContext context) {
    // bool isBuildingApp = false; // Add this boolean to track the build app operation within the dialog

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext builderContext, StateSetter setState) {
            return AlertDialog(
              title: const Text("Enter Version Numbers"),
              content: Column(
                children: <Widget>[
                  TextField(
                    controller: majorVersionController,
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(labelText: "Major Version"),
                  ),
                  TextField(
                    controller: minorVersionController,
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(labelText: "Minor Version"),
                  ),
                ],
              ),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    _openHealthCheckup(builderContext, 'build_project')
                        .then((result) {
                      if (result == true) {
                        int majorVersion =
                            int.tryParse(majorVersionController.text) ?? 0;
                        int minorVersion =
                            int.tryParse(minorVersionController.text) ?? 0;
                        _buildApp(builderContext, majorVersion, minorVersion)
                            .then((value) => {
                                  if (value == true)
                                    {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SureOpsScreen(
                                                      project: widget.project,
                                                      type: widget.type,
                                                      userData:
                                                          widget.userData)))
                                    }
                                  else
                                    {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SureOpsScreen(
                                                      project: widget.project,
                                                      type: widget.type,
                                                      userData:
                                                          widget.userData)))
                                    }
                                });
                      } else {
                        Navigator.of(context).pop();
                      }
                    });
                  },
                  child: const Text("BUILD APP"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showAlertDialog(
      BuildContext context, String title, String message) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void refreshWorkflowScreen() {
    setState(() {});
  }

  // Define the bottom navigation items
  final List<BottomNavigationBarItem> _bottomNavigationItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.settings_applications_rounded),
      label: 'BUILD APP',
      backgroundColor: Colors.blue,
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.hexagon_rounded),
      label: 'BUILD IMAGE',
      backgroundColor: Colors.blue,
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.info),
      label: 'ALL BUILD IMAGES',
      backgroundColor: Colors.blue,
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.cloud_sync_rounded),
      label: 'DEPLOY IMAGE',
      backgroundColor: Colors.blue,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('SureOps'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'SurePipe'),
              Tab(text: 'SureFarm'),
              Tab(text: 'SureImage'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SurePipeContent(
                project: widget.project,
                type: widget.type,
                userData: widget.userData),
            SureFarmContent(projectId: widget.project['id']),
            SureImageContent(
              projectId: widget.project['id'],
              refreshCallback: refreshWorkflowScreen,
              projectName: widget.project['projectName'],
            )
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: _bottomNavigationItems,
          onTap: _onBottomNavigationBarItemTapped,
          showSelectedLabels: true, // Show labels for selected items
          showUnselectedLabels: true, // Show labels for unselected items
        ),
      ),
    );
  }
}

class BuildImageInfoPopup extends StatefulWidget {
  final int projectId;

  BuildImageInfoPopup({required this.projectId});

  @override
  _BuildImageInfoPopupState createState() => _BuildImageInfoPopupState();
}

class _BuildImageInfoPopupState extends State<BuildImageInfoPopup> {
  String selectedVersion = '1'; // Default selected version

  Future<List<Map<String, dynamic>>> fetchData() async {
    int projectId = widget.projectId;
    final token = await TokenManager.getToken();
    final String baseUrl = ApiConstants.baseUrlSureOps;
    final url = '$baseUrl/sureops/getallimage/$projectId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization':
              'Bearer $token', // Attach the token as a Bearer token
        },
      );

      if (response.statusCode >= 200 && response.statusCode <= 209) {
        // Parse the JSON response
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Select version:'),
                  DropdownButton<String>(
                    value: selectedVersion,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedVersion = newValue!;
                      });
                    },
                    items: ['1', '2', '3', '4', '5', '6', '7']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      print('Selected version: $selectedVersion');
                    },
                    child: const Text('DEPLOY'),
                  ),
                ],
              ),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error: Server Error'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No data available.'));
                  } else {
                    return DataTable(
                      columns: const [
                        DataColumn(label: Text('ID')),
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Status')),
                        DataColumn(label: Text('Action')),
                      ],
                      rows: snapshot.data!.map((item) {
                        return DataRow(cells: [
                          DataCell(Text(item['id'].toString())),
                          DataCell(Text(item['filename'])),
                          DataCell(Text(item['status'])),
                          DataCell(
                            IconButton(
                              icon: const Icon(Icons.info),
                              onPressed: () {
                                // Add your action logic here
                              },
                            ),
                          ),
                        ]);
                      }).toList(),
                    );
                  }
                },
              ),
              const SizedBox(
                  height: 16), // Add spacing between DataTable and Close button
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the AlertDialog
                },
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
