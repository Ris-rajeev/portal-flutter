import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../providers/token_manager.dart';
import '../../resources/api_constants.dart';

class ShareProject extends StatefulWidget {
  final int projectid;
  ShareProject(this.projectid);

  @override
  _ShareProjectState createState() => _ShareProjectState();
}

class _ShareProjectState extends State<ShareProject> {
  var selectedValuesAllUsers;
  var selectedValuesguests;
  var selectedValuesteam;

  List<dynamic> allusers = [];

  @override
  void initState() {
    super.initState();
    _fetchAllUsers();
  }

  Future<List<DropdownModelshared>> _fetchAllUsers() async {
    final token = await TokenManager.getToken();
    String baseUrl = ApiConstants.baseUrl;
    final apiUrl = '$baseUrl/api/getAllAppUser';

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
          return DropdownModelshared(
              userId: map['userId'], username: map['username']);
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

  void _ShareProject(String userid) async {
    String baseUrl = ApiConstants.baseUrl;
    int projid = widget.projectid;
    int duration = 300;
    final token = await TokenManager.getToken();
    final apiUrl =
        '$baseUrl/workspace/secworkspaceuser/add_workspace/users/$userid/$projid/$duration';
    print(apiUrl);
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({}),
      );
      print(response.statusCode);
      if (response.statusCode <= 209) {
        Fluttertoast.showToast(
          msg: "Shared successfull",
          backgroundColor: Colors.green,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Unable to share",
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

  void _ShareProjectTeam(String teamid) async {
    String baseUrl = ApiConstants.baseUrl;
    int projid = widget.projectid;
    int duration = 300;
    final token = await TokenManager.getToken();
    final apiUrl =
        '$baseUrl/workspace/secworkspaceuser/addteam/$projid/$teamid';
    print(apiUrl);
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({}),
      );

      if (response.statusCode <= 209) {
        Fluttertoast.showToast(
          msg: "Shared successfull",
          backgroundColor: Colors.green,
        );
      } else {
        Fluttertoast.showToast(
          msg: "share failed",
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

  String? selectedOption;
  TextEditingController usernameController = TextEditingController();

  Future<List<DropdownModelshared>> _fetchTeamUsers() async {
    final token = await TokenManager.getToken();
    String baseUrl = ApiConstants.baseUrl;
    final apiUrl = '$baseUrl/Workspace_team/SecTeam';

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
          return DropdownModelshared(userId: map['id'], username: map['name']);
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

  Future<List<DropdownModelshared>> _fetchGuests() async {
    final token = await TokenManager.getToken();
    String baseUrl = ApiConstants.baseUrl;
    final apiUrl = '$baseUrl/User_workSpace/GetAllGuest';

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
          return DropdownModelshared(
              userId: map['userId'], username: map['username']);
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select an Option'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: "Users",
            onPressed: () {
              setState(() {
                selectedOption = 'User';
              });
            },
            icon: Icon(Icons.supervised_user_circle),
          ),
          IconButton(
            tooltip: "Guests",
            onPressed: () {
              setState(() {
                selectedOption = 'Guest';
              });
            },
            icon: Icon(Icons.person),
          ),
          IconButton(
            tooltip: "Team",
            onPressed: () {
              setState(() {
                selectedOption = 'Team';
              });
            },
            icon: Icon(Icons.people_alt_rounded),
          ),
          if (selectedOption == 'User')
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<List<DropdownModelshared>>(
                future: _fetchAllUsers(),
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
                      value: selectedValuesAllUsers,
                      hint: const Text("Select User"),
                      items: snapshot.data!.map((e) {
                        return DropdownMenuItem(
                          value: e.userId.toString(),
                          child: Text(e.username.toString()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          selectedValuesAllUsers = value;
                        });
                      },
                    );
                  }
                },
              ),
            ),
          if (selectedOption == 'Guest')
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<List<DropdownModelshared>>(
                future: _fetchGuests(),
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
                      value: selectedValuesguests,
                      hint: const Text("Select Guest"),
                      items: snapshot.data!.map((e) {
                        return DropdownMenuItem(
                          value: e.userId.toString(),
                          child: Text(e.username.toString()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          selectedValuesguests = value;
                        });
                      },
                    );
                  }
                },
              ),
            ),
          if (selectedOption == 'Team')
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<List<DropdownModelshared>>(
                future: _fetchTeamUsers(),
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
                      value: selectedValuesteam,
                      hint: const Text("Select Team"),
                      items: snapshot.data!.map((e) {
                        return DropdownMenuItem(
                          value: e.userId.toString(),
                          child: Text(e.username.toString()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          selectedValuesteam = value;
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
            if (selectedOption == 'User') {
              _ShareProject(selectedValuesAllUsers);
            } else if (selectedOption == 'Guest') {
              _ShareProject(selectedValuesguests);
            } else if (selectedOption == 'Team') {
              _ShareProjectTeam(selectedValuesteam);
            }
            //Navigator.of(context).pop();
          },
          child: Text('Submit'),
        ),
      ],
    );
  }
}

// To show the dialog:

// To show the dialog:

class DropdownModelshared {
  int? userId;
  String? username;

  DropdownModelshared({this.userId, this.username});

  DropdownModelshared.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['projectName'] = this.username;
    return data;
  }
}
