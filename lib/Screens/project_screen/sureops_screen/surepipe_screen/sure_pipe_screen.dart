import 'dart:convert';

import 'package:authsec_flutter/screens/project_screen/sureops_screen/surepipe_screen/workflow_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SurePipeContent extends StatefulWidget {
  final Map<String, dynamic> project;
  final String type;
  final Map<String, dynamic> userData;

  SurePipeContent(
      {required this.project, required this.type, required this.userData});

  @override
  _SurePipeContentState createState() => _SurePipeContentState();
}

class _SurePipeContentState extends State<SurePipeContent> {
  late final int projectId;

  @override
  void initState() {
    super.initState();
    projectId = widget.project['id'];
  }

  void refreshWorkflowScreen() {
    setState(() {});
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

  // Future<void> _buildApp(BuildContext context) async {
  //   final token = await TokenManager.getToken();
  //   const String baseUrlSureOps = ApiConstants.baseUrlBuildBackend;
  //   final String apiUrl =
  //       '$baseUrlSureOps/entityBuilder/BuildByProject/$projectId';
  //
  //   final response = await http.get(
  //     Uri.parse(apiUrl),
  //     headers: {
  //       'Authorization': 'Bearer $token', // Attach the token as a Bearer token
  //     },
  //   );
  //
  //   if (response.statusCode >= 200 && response.statusCode <= 209) {
  //     setState(() {});
  //     const String baseUrlbuildBackedn = ApiConstants.baseUrlBuildBackend;
  //     int userid = widget.userData['userId'];
  //     final String message =
  //         widget.project['projectName'] + ' Build App Successful';
  //     final String apiUrl2 = '$baseUrlbuildBackedn/saveemailbyuserid/$userid';
  //     final response2 = await http.post(Uri.parse(apiUrl2),
  //         headers: {
  //           'Authorization': 'Bearer $token',
  //           'Content-Type': 'application/json',
  //         },
  //         body: json.encode({"message": message, "token": token}));
  //     if (response2.statusCode <= 209) {
  //       print("email sent success");
  //     }
  //     _showAlertDialog(context, 'Success', 'Build App successful.');
  //   } else {
  //     // Error response
  //     _showAlertDialog(context, 'Error',
  //         'An error occurred. Status code: ${response.statusCode}');
  //   }
  // }

  // Future<void> _buildImage(BuildContext context) async {
  //   final token = await TokenManager.getToken();
  //   const String baseUrlSureOps = ApiConstants.baseUrlSureOps;
  //   final String apiUrl = '$baseUrlSureOps/sureops/deployapp/$projectId/3';
  //
  //   final response = await http.get(
  //     Uri.parse(apiUrl),
  //     headers: {
  //       'Authorization': 'Bearer $token', // Attach the token as a Bearer token
  //     },
  //   );
  //
  //   if (response.statusCode >= 200 && response.statusCode <= 209) {
  //     setState(() {});
  //     const String baseUrlbuildBackedn = ApiConstants.baseUrlBuildBackend;
  //     int userid = widget.userData['userId'];
  //     print(userid);
  //     final String message =
  //         widget.project['projectName'] + ' Build Image Successful';
  //     final String apiUrl2 = '$baseUrlbuildBackedn/saveemailbyuserid/$userid';
  //     final response2 = await http.post(Uri.parse(apiUrl2),
  //         headers: {
  //           'Authorization': 'Bearer $token',
  //           'Content-Type': 'application/json',
  //         },
  //         body: json.encode({"message": message, "token": token}));
  //     if (response2.statusCode <= 209) {
  //       print("email sent success");
  //     }
  //     _showAlertDialog(context, 'Success', 'Build image successful.');
  //   } else {
  //     // Error response
  //     _showAlertDialog(context, 'Error',
  //         'An error occurred. Status code: ${response.statusCode}');
  //   }
  // }

  // Future<void> _deployImage(BuildContext context) async {
  //   final token = await TokenManager.getToken();
  //   final String baseUrlSureOps = ApiConstants.baseUrlSureOps;
  //   final String apiUrl = '$baseUrlSureOps/sureops/deployimage/$projectId';
  //
  //   final response = await http.get(
  //     Uri.parse(apiUrl),
  //     headers: {
  //       'Authorization': 'Bearer $token', // Attach the token as a Bearer token
  //     },
  //   );
  //
  //   if (response.statusCode >= 200 && response.statusCode <= 209) {
  //     setState(() {});
  //     const String baseUrlbuildBackedn = ApiConstants.baseUrlBuildBackend;
  //     print(widget.userData);
  //     int userid = widget.userData['userId'];
  //     final String message =
  //         widget.project['projectName'] + ' Deploy Image Successful';
  //     final String apiUrl2 = '$baseUrlbuildBackedn/saveemailbyuserid/$userid';
  //     final response2 = await http.post(Uri.parse(apiUrl2),
  //         headers: {
  //           'Authorization': 'Bearer $token',
  //           'Content-Type': 'application/json',
  //         },
  //         body: json.encode({"message": message, "token": token}));
  //     if (response2.statusCode <= 209) {
  //       print("email sent success");
  //     }
  //     _showAlertDialog(context, 'Success', 'Deploy Image successful.');
  //   } else {
  //     // Error response
  //     _showAlertDialog(context, 'Error',
  //         'An error occurred. Status code: ${response.statusCode}');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20), // Add spacing at the top
                WorkFlowContent(
                    refreshCallback: refreshWorkflowScreen,
                    projectId: projectId),
                const SizedBox(
                    height: 20), // Add spacing before the action buttons
              ],
            ),
          ),
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //   children: [
        //     Expanded(
        //       child: Column(
        //         children: [
        //           widget.type == 'myproject'
        //               ? IconButton(
        //                   onPressed: () {
        //                     _buildApp(context).then((_) {
        //                       SurePipeContent(
        //                         project: widget.project,
        //                         type: widget.type,
        //                         userData: widget.userData,
        //                       );
        //                     });
        //                   },
        //                   icon: const Icon(
        //                     Icons.settings_applications_rounded,
        //                     size: 24.0,
        //                     color: Colors.black,
        //                   ),
        //                 )
        //               : IconButton(
        //                   onPressed: () {
        //                     Fluttertoast.showToast(
        //                       msg: 'Unauthorized access',
        //                       backgroundColor: Colors.red,
        //                     );
        //                   },
        //                   icon: const Icon(
        //                     Icons.settings_applications_rounded,
        //                     size: 24.0,
        //                     color: Colors.grey,
        //                   ),
        //                 ),
        //           const Text("BUILD APP"),
        //         ],
        //       ),
        //     ),
        //     Expanded(
        //       child: Column(
        //         children: [
        //           widget.type == 'myproject'
        //               ? IconButton(
        //                   onPressed: () {
        //                     _buildImage(context);
        //                   },
        //                   icon: const Icon(
        //                     Icons.hexagon_rounded,
        //                     size: 24.0,
        //                     color: Colors.black,
        //                   ),
        //                 )
        //               : IconButton(
        //                   onPressed: () {
        //                     Fluttertoast.showToast(
        //                       msg: 'Unauthorized access',
        //                       backgroundColor: Colors.red,
        //                     );
        //                   },
        //                   icon: const Icon(
        //                     Icons.hexagon_rounded,
        //                     size: 24.0,
        //                     color: Colors.grey,
        //                   ),
        //                 ),
        //           const Text("BUILD IMAGE"),
        //         ],
        //       ),
        //     ),
        //     Expanded(
        //       child: Column(
        //         children: [
        //           IconButton(
        //             onPressed: () {
        //               showDialog(
        //                 context: context,
        //                 builder: (context) {
        //                   return BuildImageInfoPopup(projectId: projectId);
        //                 },
        //               );
        //             },
        //             icon: const Icon(
        //               Icons.info,
        //               size: 15,
        //             ),
        //           ),
        //           const Text("ALL BUILD IMAGES"),
        //         ],
        //       ),
        //     ),
        //     Expanded(
        //       child: Column(
        //         children: [
        //           widget.type == 'myproject'
        //               ? IconButton(
        //                   onPressed: () {
        //                     _deployImage(context);
        //                   },
        //                   icon: const Icon(
        //                     Icons.cloud_sync_rounded,
        //                     size: 24.0,
        //                     color: Colors.black,
        //                   ),
        //                 )
        //               : IconButton(
        //                   onPressed: () {
        //                     Fluttertoast.showToast(
        //                       msg: 'Unauthorized access',
        //                       backgroundColor: Colors.red,
        //                     );
        //                   },
        //                   icon: const Icon(
        //                     Icons.cloud_sync_rounded,
        //                     size: 24.0,
        //                     color: Colors.grey,
        //                   ),
        //                 ),
        //           const Text("DEPLOY IMAGE"),
        //         ],
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}

// class BuildImageInfoPopup extends StatelessWidget {
//   final int projectId;
//
//   BuildImageInfoPopup({required this.projectId});
//
//   Future<List<Map<String, dynamic>>> fetchData() async {
//     final token = await TokenManager.getToken();
//     final String baseUrl = ApiConstants.baseUrlSureOps;
//     final url = '$baseUrl/sureops/getallimage/$projectId';
//
//     try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: {
//           'Authorization':
//               'Bearer $token', // Attach the token as a Bearer token
//         },
//       );
//
//       if (response.statusCode >= 200 && response.statusCode <= 209) {
//         // Parse the JSON response
//         final List<dynamic> jsonData = json.decode(response.body);
//         return jsonData.cast<Map<String, dynamic>>();
//       } else {
//         throw Exception('Failed to load data: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Failed to load data: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       content: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: SingleChildScrollView(
//           scrollDirection: Axis.vertical,
//           child: Column(
//             children: [
//               FutureBuilder<List<Map<String, dynamic>>>(
//                 future: fetchData(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   } else if (snapshot.hasError) {
//                     return Center(child: Text('Error: Server Error'));
//                   } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                     return const Center(child: Text('No data available.'));
//                   } else {
//                     return DataTable(
//                       columns: const [
//                         DataColumn(label: Text('ID')),
//                         DataColumn(label: Text('Name')),
//                         DataColumn(label: Text('Status')),
//                         DataColumn(label: Text('Action')),
//                       ],
//                       rows: snapshot.data!.map((item) {
//                         return DataRow(cells: [
//                           DataCell(Text(item['id'].toString())),
//                           DataCell(Text(item['filename'])),
//                           DataCell(Text(item['status'])),
//                           DataCell(
//                             IconButton(
//                               icon: const Icon(Icons.info),
//                               onPressed: () {
//                                 // Add your action logic here
//                               },
//                             ),
//                           ),
//                         ]);
//                       }).toList(),
//                     );
//                   }
//                 },
//               ),
//               const SizedBox(
//                   height: 16), // Add spacing between DataTable and Close button
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.of(context).pop(); // Close the AlertDialog
//                 },
//                 child: const Text('Close'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

// Your fetchData function remains the same.
//}
