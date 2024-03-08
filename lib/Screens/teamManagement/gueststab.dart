import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../providers/token_manager.dart';
import '../../../resources/api_constants.dart';

class GuestContent extends StatefulWidget {
  @override
  _GuestContentState createState() => _GuestContentState();
}

class _GuestContentState extends State<GuestContent> {
  Future<List<Map<String, dynamic>>> fetchData() async {
    final token = await TokenManager.getToken();
    final String baseUrl = ApiConstants.baseUrl;
    final String apiUrl = '$baseUrl/User_workSpace/GetAllGuest';

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

  int i = 0;

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
                        DataColumn(label: Text('No')),
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Account Type')),
                        DataColumn(label: Text('Status')),
                        DataColumn(label: Text('Access Till')),
                        DataColumn(label: Text('Action')),
                      ],
                      rows: snapshot.data!.map((item) {
                        i++;
                        return DataRow(cells: [
                          DataCell(
                            Text(i?.toString() ?? 'N/A'),
                          ),
                          DataCell(
                            Text(item['fullName']?.toString() ?? 'N/A'),
                          ),
                          DataCell(Text(item['roles'][0]['description'])),
                          DataCell(
                            Text(item['status']?.toString() ?? 'N/A'),
                          ),
                          //access_duration
                          DataCell(
                            Text(item['access_duration']?.toString() ?? 'N/A'),
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
              child: Text('Add Guest'),
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
  String _selectedDuration = "30 days"; // Default selection

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Invite Guest To REALITS-WS"),
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
          DropdownButton<String>(
            value: _selectedDuration,
            items: ["30 days", "60 days", "90 days"].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedDuration = newValue!;
              });
            },
          ),
          ElevatedButton(
            onPressed: () async {
              String toText = _toController.text;
              print("To: $toText");
              print("Duration: $_selectedDuration"); // Print selected duration
              final token = await TokenManager.getToken();
              final String baseUrl = ApiConstants.baseUrl;
              final String apiUrl =
                  '$baseUrl/api/guest_via_admin?email=$toText&access_duration=$_selectedDuration';

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
