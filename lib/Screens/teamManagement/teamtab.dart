import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../providers/token_manager.dart';
import '../../../resources/api_constants.dart';

class TeamContent extends StatefulWidget {
  @override
  _TeamContentState createState() => _TeamContentState();
}

class _TeamContentState extends State<TeamContent> {
  List<Map<String, dynamic>> _tableData = [];

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch data when the widget is initialized
  }
  // Future<List<Map<String, dynamic>>> fetchData() async {
  //   final token = await TokenManager.getToken();
  //   final String baseUrl = ApiConstants.baseUrl;
  //   final String apiUrl = '$baseUrl/Workspace_team/SecTeam';
  //
  //   try {
  //     final response = await http.get(
  //       Uri.parse(apiUrl),
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //       },
  //     );
  //
  //     if (response.statusCode >= 200 && response.statusCode <= 209) {
  //       final List<dynamic> jsonData = json.decode(response.body);
  //       print(jsonData.cast<Map<String, dynamic>>());
  //       return jsonData.cast<Map<String, dynamic>>();
  //     } else {
  //       throw Exception('Failed to load data: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     throw Exception('Failed to load data: $e');
  //   }
  // }

  Future<void> fetchData() async {
    final token = await TokenManager.getToken();
    final String baseUrl = ApiConstants.baseUrl;
    final String apiUrl = '$baseUrl/Workspace_team/SecTeam';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode >= 200 && response.statusCode <= 209) {
        final List<dynamic> jsonData = json.decode(response.body);
        final List<Map<String, dynamic>> newData =
            jsonData.cast<Map<String, dynamic>>();
        setState(() {
          _tableData = newData; // Update the data source
        });
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  int i = 0;

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: SingleChildScrollView(
  //       child: Column(
  //         children: [
  //           FutureBuilder<List<Map<String, dynamic>>>(
  //             future: fetchData(),
  //             builder: (context, snapshot) {
  //               if (snapshot.connectionState == ConnectionState.waiting) {
  //                 return Center(child: CircularProgressIndicator());
  //               } else if (snapshot.hasError) {
  //                 return Center(child: Text('Error: ${snapshot.error}'));
  //               } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
  //                 return Center(child: Text('No data available.'));
  //               } else {
  //                 return SingleChildScrollView(
  //                   scrollDirection: Axis.horizontal,
  //                   child: DataTable(
  //                     columns: const [
  //                       DataColumn(label: Text('No')),
  //                       DataColumn(label: Text('Team Name')),
  //                       DataColumn(label: Text('Owner')),
  //                       DataColumn(label: Text('Count')),
  //                       DataColumn(label: Text('Members')),
  //                       DataColumn(label: Text('Actions')),
  //                     ],
  //                     rows: _tableData.map((item) {
  //                       i++;
  //                       return DataRow(cells: [
  //                         DataCell(
  //                           Text(i?.toString() ?? 'N/A'),
  //                         ),
  //                         DataCell(
  //                           Text(item['name']?.toString() ?? 'N/A'),
  //                         ),
  //                         DataCell(Text(item['owner_id']?.toString() ?? 'N/A')),
  //                         DataCell(
  //                           Text(3.toString()),
  //                         ),
  //                         DataCell(
  //                           Row(
  //                             children: [
  //                               Icon(Icons.person),
  //                               Icon(Icons.person),
  //                               Icon(Icons.person)
  //                             ],
  //                           )
  //                         ),
  //                         DataCell(
  //                           IconButton(
  //                             icon: Icon(Icons.info),
  //                             onPressed: () {
  //                               // Add your action logic here
  //                             },
  //                           ),
  //                         ),
  //                       ]);
  //                     }).toList(),
  //                   ),
  //                 );
  //               }
  //             },
  //           ),
  //           ElevatedButton(
  //             onPressed: _openInvitePeoplePopup,
  //             child: Text('Add Team'),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_tableData.isEmpty)
              Center(child: Text('No data available.'))
            else
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('No')),
                    DataColumn(label: Text('Team Name')),
                    DataColumn(label: Text('Owner')),
                    DataColumn(label: Text('Count')),
                    DataColumn(label: Text('Members')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: _tableData.map((item) {
                    i++;
                    return DataRow(cells: [
                      DataCell(
                        Text(i?.toString() ?? 'N/A'),
                      ),
                      DataCell(
                        Text(item['name']?.toString() ?? 'N/A'),
                      ),
                      DataCell(Text(item['owner_id']?.toString() ?? 'N/A')),
                      DataCell(
                        Text(3.toString()),
                      ),
                      DataCell(
                        Row(
                          children: [
                            Icon(Icons.person),
                            Icon(Icons.person),
                            Icon(Icons.person),
                          ],
                        ),
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
              ),
            ElevatedButton(
              onPressed: _openInvitePeoplePopup,
              child: Text('Add Team'),
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
    // Navigator.of(context).pushReplacement(MaterialPageRoute(
    //   builder: (BuildContext context) => TeamContent(),
    //));
  }

  // Handle the Invite action (Replace with your API call logic)
  void _handleInvite() async {
    // Replace with your API call logic
    // After the API call is done, close the popup
    _closeInvitePeoplePopup();
    await fetchData();
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
          Text("Add A Team To Real It Solutions"),
          TextFormField(
            controller: _toController,
            decoration: InputDecoration(
              hintText: "name",
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
              final String apiUrl = '$baseUrl/Workspace_team/SecTeam';

              try {
                final response = await http.post(
                  Uri.parse(apiUrl),
                  headers: {
                    'Authorization': 'Bearer $token',
                    'Content-Type': 'application/json',
                  },
                  body: jsonEncode({
                    "name": toText,
                  }),
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
