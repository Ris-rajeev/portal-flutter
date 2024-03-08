// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// import '../../../providers/token_manager.dart';
// import '../../../resources/api_constants.dart';
//
// class UserContent extends StatelessWidget {
//   // final int projectId;
//   //
//   // const SureFarmContent({Key? key, required this.projectId}) : super(key: key);
//
//   Future<List<Map<String, dynamic>>> fetchData() async {
//     final token = await TokenManager.getToken();
//     final String baseUrl = ApiConstants.baseUrl;
//     final String apiUrl = '$baseUrl/User_workSpace/GetAllUser';
//
//     try {
//       final response = await http.get(
//         Uri.parse(apiUrl),
//         headers: {
//           'Authorization': 'Bearer $token',
//         },
//       );
//
//       if (response.statusCode >= 200 && response.statusCode <= 209) {
//         final List<dynamic> jsonData = json.decode(response.body);
//         print(jsonData.cast<Map<String, dynamic>>());
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
//     return SingleChildScrollView(
//       child: FutureBuilder<List<Map<String, dynamic>>>(
//         future: fetchData(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No data available.'));
//           } else {
//             return SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child:DataTable(
//                   columns: const [
//                     DataColumn(label: Text('Name')),
//                     DataColumn(label: Text('Account Type')),
//                     DataColumn(label: Text('Status')),
//                     DataColumn(label: Text('Action')),
//                   ],
//                   rows: snapshot.data!.map((item) {
//                     return DataRow(cells: [
//                       DataCell(Text(item['fullName']?.toString() ?? 'N/A')),//item['fullName']!.toString() +" : "+item['username']!.toString()+" : "+item['email']!.toString())),
//                       DataCell(Text(" ")),
//                       DataCell(Text(item['status']?.toString() ?? 'N/A')),
//                       DataCell(
//                         IconButton(
//                           icon: Icon(Icons.info),
//                           onPressed: () {
//                             // Add your action logic here
//                           },
//                         ),
//                       ),
//                     ]);
//                   }).toList(),
//                 )
//             );
//           }
//         },
//       ),
//     );
//   }
// }
//
// class InvitePeoplePopup extends StatelessWidget {
//   final VoidCallback onClose;
//   final VoidCallback onInvite;
//
//   InvitePeoplePopup({required this.onClose, required this.onInvite});
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text("Invite People To REALITS-WS"),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Text("To:"),
//           TextFormField(
//             // Your text field configuration
//           ),
//           ElevatedButton(
//             onPressed: () {
//               // Add your API call logic here
//               onInvite();
//             },
//             child: Text("Submit"),
//           ),
//           TextButton(
//             onPressed: () {
//               onClose();
//             },
//             child: Text("Cancel"),
//           ),
//           TextButton(
//             onPressed: () {
//               // Add your logic to copy invite link here
//             },
//             child: Text("Copy Invite Link"),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../providers/token_manager.dart';
import '../../../resources/api_constants.dart';

class UserContent extends StatefulWidget {
  @override
  _UserContentState createState() => _UserContentState();
}

class _UserContentState extends State<UserContent> {
  Future<List<Map<String, dynamic>>> fetchData() async {
    final token = await TokenManager.getToken();
    final String baseUrl = ApiConstants.baseUrl;
    final String apiUrl = '$baseUrl/User_workSpace/GetAllUser';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode >= 200 && response.statusCode <= 209) {
        final List<dynamic> jsonData = json.decode(response.body);
        print(jsonData.cast<Map<String, dynamic>>());
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
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('User Content'),
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No data available.'));
                } else {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Account Type')),
                        DataColumn(label: Text('Status')),
                        DataColumn(label: Text('Action')),
                      ],
                      rows: snapshot.data!.map((item) {
                        return DataRow(cells: [
                          DataCell(
                            Column(
                              children: [
                                Text(item['fullName']?.toString() ?? 'N/A'),
                                Text(item['username']?.toString() ?? 'N/A'),
                                Text(item['email']?.toString() ?? 'N/A'),
                              ],
                            ),
                          ),
                          DataCell(Text(" ")),
                          DataCell(
                            Text(item['status']?.toString() ?? 'N/A'),
                          ),
                          DataCell(
                            IconButton(
                              icon: Icon(Icons.info),
                              onPressed: () {
                                // Add your action logic here
                              },
                            ),
                          ),
                        ]);
                      }).toList(),
                    ),
                  );
                }
              },
            ),
            ElevatedButton(
              onPressed: _openInvitePeoplePopup,
              child: Text('Add User'),
            ),
          ],
        ),
      ),
    );
  }

  // Open the Invite People Popup
  void _openInvitePeoplePopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return InvitePeoplePopup(
          onClose: _closeInvitePeoplePopup,
          onInvite: _handleInvite,
        );
      },
    );
  }

  // Close the Invite People Popup
  void _closeInvitePeoplePopup() {
    Navigator.of(context).pop();
  }

  // Handle the Invite action (Replace with your API call logic)
  void _handleInvite() async {
    // Replace with your API call logic
    // After the API call is done, close the popup
    _closeInvitePeoplePopup();
  }
}

class InvitePeoplePopup extends StatefulWidget {
  final VoidCallback onClose;
  final VoidCallback onInvite;

  InvitePeoplePopup({required this.onClose, required this.onInvite});

  @override
  _InvitePeoplePopupState createState() => _InvitePeoplePopupState();
}

class _InvitePeoplePopupState extends State<InvitePeoplePopup> {
  final TextEditingController _toController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Invite People To REALITS-WS"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("To:"),
          TextFormField(
            controller: _toController,
            decoration: InputDecoration(
              hintText: "name@dakatc.com",
              filled: true,
              fillColor: Colors.grey[200], // Shaded background color
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              String toText = _toController.text;
              print("To: $toText");
              final token = await TokenManager.getToken();
              final String baseUrl = ApiConstants.baseUrl;
              final String apiUrl = '$baseUrl/api/userviaadmin?email=$toText';

              try {
                final response = await http.post(
                  Uri.parse(apiUrl),
                  headers: {
                    'Authorization': 'Bearer $token',
                  },
                );

                if (response.statusCode >= 200 && response.statusCode <= 209) {
                  print("success");
                } else {
                  throw Exception(
                      'Failed to load data: ${response.statusCode}');
                }
              } catch (e) {
                throw Exception('Failed to load data: $e');
              }
              widget.onInvite();
            },
            child: Text("Submit"),
          ),
          TextButton(
            onPressed: widget.onClose,
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              // Add your logic to copy invite link here
            },
            child: Text("Copy Invite Link"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _toController.dispose();
    super.dispose();
  }
}
