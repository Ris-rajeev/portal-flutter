// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:authsec_flutter/screens/Module_screen/ModulesScreen.dart';
import 'package:authsec_flutter/screens/main_app_screen/tabbed_layout_component.dart';
import 'package:authsec_flutter/screens/project_screen/Add_project.dart';
import 'package:authsec_flutter/screens/project_screen/project_edit_screen.dart';
import 'package:authsec_flutter/screens/project_screen/search_fuctionality.dart';
import 'package:authsec_flutter/screens/project_screen/shredwithmeprojects.dart';
import 'package:authsec_flutter/screens/project_screen/sureops_screen/sureOpsScreen.dart';
import 'package:authsec_flutter/hadwin_components.dart';
import 'package:authsec_flutter/providers/token_manager.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../main_app_screen/CustomizeFooter.dart';
import 'ProjectCard.dart';
import 'project_service.dart';

class ProjectListScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  final String type;
  const ProjectListScreen(
      {required this.userData, required this.type, Key? key})
      : super(key: key);
  @override
  _ProjectListScreenState createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  late List<Map<String, dynamic>> projects = []; // Initialize as an empty list
  final ProjectApiService projectApiService = ProjectApiService();
  List<Map<String, dynamic>> libraryprojects = [];
  int currentTabIndex = 1; // Set the initial tab index to 0
  ProjectApiService apiService = ProjectApiService();

  void handleTabChange(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  var selectedValues;
  var selectedValuesPub;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    print(widget.userData);
    if (widget.type == 'myproject') {
      _loadMyProjects();
    } else if (widget.type == 'sharedproject') {
      _loadSharedProject();
    } else if (widget.type == 'allproject') {
      _loadAllProjects();
    }
  }

  Future<void> _loadSharedProject() async {
    final token = await TokenManager.getToken();
    try {
      final projectData = await projectApiService.getsharedproject(token!);
      setState(() {
        projects = projectData;
        isLoading = true;
      });
    } catch (e) {
      setState(() {
        isLoading = true;
      });
      print('Failed to load projects: $e');
    }
  }

  Future<void> _loadAllProjects() async {
    final token = await TokenManager.getToken();
    try {
      final projectData = await projectApiService.getallproject(token!);
      setState(() {
        projects = projectData;
        isLoading = true;
      });
    } catch (e) {
      setState(() {
        isLoading = true;
      });
      print('Failed to load projects: $e');
    }
  }

  Future<void> _loadMyProjects() async {
    final token = await TokenManager.getToken();
    try {
      final projectData = await projectApiService.getproject(token!);
      setState(() {
        projects = projectData;
        isLoading = true;
      });
    } catch (e) {
      setState(() {
        isLoading = true;
      });
      print('Failed to load projects: $e');
    }
  }

  Future<void> deleteEntity(Map<String, dynamic> entity) async {
    try {
      final token = await TokenManager.getToken();
      await projectApiService.deleteProject(token!, entity['id']);
      setState(() {
        projects.remove(entity);
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

  Future<List<DropdownModel>> _fetchLibraryProjects() async {
    final token = await TokenManager.getToken();
    String baseUrl = ApiConstants.baseUrl;
    final apiUrl = '$baseUrl/projectlibrary/getall_projectlibrary';

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
          return DropdownModel(id: map['id'], projectName: map['projectName']);
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

  void _openPopupPublicProj(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // StatefulBuilder is used to allow updating the dialog's state.

            return AlertDialog(
              title: const Text('Select a Project'),
              content: FutureBuilder<List<DropdownModel>>(
                future: _fetchPublicProjects(),
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
                      value: selectedValuesPub,
                      hint: const Text("Select Public Project"),
                      items: snapshot.data!.map((e) {
                        return DropdownMenuItem(
                          value: e.id.toString(),
                          child: Text(e.projectName.toString()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          selectedValuesPub = value;
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
                    if (selectedValuesPub != null) {
                      print(selectedValuesPub);
                      _openHealthCheckup(context, widget.userData, "myproject")
                          .then((result) {
                        if (result == true) {
                          _copyPublicProject();
                          Navigator.of(context).pop();
                        } else {
                          Navigator.of(context).pop();
                        }
                      });
                    } else {
                      print('No project selected.');
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

  void _openPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // StatefulBuilder is used to allow updating the dialog's state.

            return AlertDialog(
              title: const Text('Select a Project'),
              content: FutureBuilder<List<DropdownModel>>(
                future: _fetchLibraryProjects(),
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
                      hint: const Text("Select Library Project"),
                      items: snapshot.data!.map((e) {
                        return DropdownMenuItem(
                          value: e.id.toString(),
                          child: Text(e.projectName.toString()),
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
                      _openHealthCheckup(context, widget.userData, "myproject")
                          .then((result) {
                        if (result == true) {
                          print("working");
                          _copyProject();
                          Navigator.of(context).pop();
                        } else {
                          Navigator.of(context).pop();
                        }
                      });
                    } else {
                      print('No project selected.');
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

  void _copyProject() async {
    String baseUrl = ApiConstants.baseUrl;
    final token = await TokenManager.getToken();
    final apiUrl =
        '$baseUrl/projectlibrary/copyfromprojectlibrary/$selectedValues';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token', // Include the token in the headers
        },
      );

      if (response.statusCode <= 209) {
        // setState(() {
        projects.add(json.decode(response.body));
        // });
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

//--------------------------------------------------------------------------------------------------
  Future<List<DropdownModel>> _fetchPublicProjects() async {
    final token = await TokenManager.getToken();
    String baseUrl = ApiConstants.baseUrl;
    final apiUrl = '$baseUrl/fnd/project/getall_public_project';

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
          return DropdownModel(id: map['id'], projectName: map['projectName']);
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

  void _copyPublicProject() async {
    String baseUrl = ApiConstants.baseUrl;
    final token = await TokenManager.getToken();
    final apiUrl = '$baseUrl/fnd/project/copypublic_proj/$selectedValuesPub';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token', // Include the token in the headers
        },
      );

      if (response.statusCode <= 209) {
        setState(() {
          projects.add(json.decode(response.body));
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

  void _addToAwesome(dynamic project, bool is_stared) async {
    final token = await TokenManager.getToken();
    if (is_stared) {
      Response response = await apiService.removeAwesome(token!, project['id']);
      if (response.statusCode! >= 200 && response.statusCode! <= 209) {
        // Success popup
        Fluttertoast.showToast(
          msg: 'Remove From Awesome',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP_RIGHT,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
        );
      } else {
        // Error popup
        Fluttertoast.showToast(
          msg: 'Failed to Remove',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } else {
      Response response = await apiService.addAwesome(token!, project);
      if (response.statusCode! >= 200 && response.statusCode! <= 209) {
        // Success popup
        Fluttertoast.showToast(
          msg: 'Add to Awesome',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP_RIGHT,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
        );
      } else {
        // Error popup
        Fluttertoast.showToast(
          msg: 'Failed to Add',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
    setState(() {
      if (widget.type == 'myproject') {
        _loadMyProjects();
      } else if (widget.type == 'sharedproject') {
        _loadSharedProject();
      } else if (widget.type == 'allproject') {
        _loadAllProjects();
      }
    });
  }

  //_addToWatchlist
  void _addToWatchlist(dynamic project, bool isWatchlist) async {
    final token = await TokenManager.getToken();
    if (isWatchlist) {
      Response response =
          await apiService.removeWatchlist(token!, project['id']);
      if (response.statusCode! >= 200 && response.statusCode! <= 209) {
        // Success popup
        Fluttertoast.showToast(
          msg: 'Remove From Watchlist',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP_RIGHT,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
        );
      } else {
        // Error popup
        Fluttertoast.showToast(
          msg: 'Failed to Remove',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } else {
      Response response = await apiService.addWatchlist(token!, project);
      if (response.statusCode! >= 200 && response.statusCode! <= 209) {
        // Success popup
        Fluttertoast.showToast(
          msg: 'Add to Watchlist',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP_RIGHT,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
        );
      } else {
        // Error popup
        Fluttertoast.showToast(
          msg: 'Failed to Add',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
    setState(() {
      if (widget.type == 'myproject') {
        _loadMyProjects();
      } else if (widget.type == 'sharedproject') {
        _loadSharedProject();
      } else if (widget.type == 'allproject') {
        _loadAllProjects();
      }
    });
  }
//_addToFavourite

  void _addToFavourite(dynamic project, bool isWatchlist) async {
    final token = await TokenManager.getToken();
    if (isWatchlist) {
      Response response =
          await apiService.removeFavourite(token!, project['id']);
      if (response.statusCode! >= 200 && response.statusCode! <= 209) {
        // Success popup
        Fluttertoast.showToast(
          msg: 'Remove From Favourite',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP_RIGHT,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
        );
      } else {
        // Error popup
        Fluttertoast.showToast(
          msg: 'Failed to Remove',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } else {
      Response response = await apiService.addFavourite(token!, project);
      if (response.statusCode! >= 200 && response.statusCode! <= 209) {
        // Success popup
        Fluttertoast.showToast(
          msg: 'Add to Favourite',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP_RIGHT,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
        );
      } else {
        // Error popup
        Fluttertoast.showToast(
          msg: 'Failed to Add',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
    setState(() {
      if (widget.type == 'myproject') {
        _loadMyProjects();
      } else if (widget.type == 'sharedproject') {
        _loadSharedProject();
      } else if (widget.type == 'allproject') {
        _loadAllProjects();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.search_sharp),
              tooltip: 'Search',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchScreen(),
                  ),
                ).then((_) {
                  if (widget.type == 'myproject') {
                    _loadMyProjects();
                  } else if (widget.type == 'sharedproject') {
                    _loadSharedProject();
                  } else if (widget.type == 'allproject') {
                    _loadAllProjects();
                  }
                });
              },
            ),
          ],
          leading: IconButton(
            icon: const Icon(Icons.arrow_back), // Add a back button icon
            onPressed: () {
              // Navigate to the "Add Modules" screen
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              TabbedLayoutComponent(userData: widget.userData)))
                  .then((_) {
                if (widget.type == 'myproject') {
                  _loadMyProjects();
                } else if (widget.type == 'sharedproject') {
                  _loadSharedProject();
                } else if (widget.type == 'allproject') {
                  _loadAllProjects();
                }
              });
            },
          ),
          title: const Text('Project List'),
        ),
        body: IndexedStack(
          index: currentTabIndex, // Switch to the selected tab content
          children: <Widget>[
            Text(''),
            isLoading == false
                ? const Center(child: CircularProgressIndicator())
                : projects.isEmpty
                    ? const Center(
                        child: Text(
                          'No projects available.',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : ListView.builder(
                        itemCount: projects.length,
                        itemBuilder: (context, index) {
                          final project = projects[index];
                          return ProjectCard(
                              type: widget.type,
                              projectName:
                                  project['projectName'].toString() ?? 'empty',
                              description:
                                  project['description'.toString() ?? 'empty'],
                              is_stared: project['is_stared'] ?? false,
                              is_watchlisted:
                                  project['is_watchlisted'] ?? false,
                              is_fav: project['is_fav'] ?? false,
                              project: project,
                              onEditPressed: () {
                                print("Edit clicked");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CreateEditProjectScreen(
                                              project: project),
                                    )).then((_) {
                                  if (widget.type == 'myproject') {
                                    _loadMyProjects();
                                  } else if (widget.type == 'sharedproject') {
                                    _loadSharedProject();
                                  } else if (widget.type == 'allproject') {
                                    _loadAllProjects();
                                  }
                                });
                              },
                              onSureOpsPressed: () {
                                int Projectid = project['id'];
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SureOpsScreen(
                                      project: project,
                                      type: widget.type,
                                      userData: widget.userData,
                                    ),
                                  ),
                                );
                              },
                              onModulesPressed: () {
                                final mod = project['modules'];
                                print('modules fetched ... ');

                                // Handle Modules button pressed for this project
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ModuleScreen(
                                          projectId: project['id'],
                                          type: widget.type)),
                                );
                              },
                              onDeletePressed: () {
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
                                            deleteEntity(project);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              onAddAwesome: () {
                                _addToAwesome(project, project['is_stared']);
                              },
                              onAddWatchListed: () {
                                _addToWatchlist(
                                    project, project['is_watchlisted']);
                              },
                              onAddFavourite: () {
                                _addToFavourite(project, project['is_fav']);
                              },
                              onShareProject: () {
                                print("clicked share");

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ShareProject(project['id']),
                                    ));
                              });
                        },
                      ),
          ],
        ),
        bottomNavigationBar: CustomizedFooter(
          homeIcon: Icons.home,
          squareIcon: Icons.apps,
          addIcon: Icons.add,
          labels: const ['Home', 'Projects', 'Add'],
          onTapActions: [
            () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          TabbedLayoutComponent(userData: widget.userData)));
            },
            () {
              if (widget.type == 'myproject') {
                _loadMyProjects();
              } else if (widget.type == 'sharedproject') {
                _loadSharedProject();
              } else if (widget.type == 'allproject') {
                _loadAllProjects();
              }
            },
            () {
              if (widget.type == 'myproject') {
                _openHealthCheckup(context, widget.userData, "myproject")
                    .then((result) {
                  print("result...........$result");
                  if (result == true) {
                    _openCreateProjectScreen(
                        context, widget.userData, widget.type);
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProjectListScreen(
                                userData: widget.userData, type: widget.type)));
                  }
                });
              } else {
                Fluttertoast.showToast(
                  msg: 'Unauthorized access',
                  backgroundColor: Colors.red,
                );
              }
            },
          ],
        ),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          overlayColor: Colors.black,
          overlayOpacity: 0.5,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.local_library),
              backgroundColor: Colors.blue,
              label: 'Copy From Library',
              onTap: () {
                if (widget.type == 'myproject') {
                  _openPopup(context);
                  setState(() {
                    if (widget.type == 'myproject') {
                      _loadMyProjects();
                    } else if (widget.type == 'sharedproject') {
                      _loadSharedProject();
                    } else if (widget.type == 'allproject') {
                      _loadAllProjects();
                    }
                  });
                } else {
                  Fluttertoast.showToast(
                    msg: 'Unauthorized access',
                    backgroundColor: Colors.red,
                  );
                }
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.public),
              backgroundColor: Colors.green,
              label: 'Copy Public Project',
              onTap: () {
                if (widget.type == 'myproject') {
                  _openPopupPublicProj(context);
                } else {
                  Fluttertoast.showToast(
                    msg: 'Unauthorized access',
                    backgroundColor: Colors.red,
                  );
                }
              },
            ),
          ],
        ));
  }

  void _openCreateProjectScreen(BuildContext context,
      final Map<String, dynamic> userData, String type) async {
    String selectedAccessibility = 'false'; // Initialize with 'false'

    selectedAccessibility = (await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Accessibility'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text('Public'),
                value: 'false',
                groupValue: selectedAccessibility,
                onChanged: (value) {
                  Navigator.pop(context, value);
                },
              ),
              RadioListTile<String>(
                title: const Text('Private'),
                value: 'true',
                groupValue: selectedAccessibility,
                onChanged: (value) {
                  Navigator.pop(context, value);
                },
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, selectedAccessibility);
                },
                child: const Text('Continue'),
              ),
            ],
          ),
        );
      },
    ))!;

    if (selectedAccessibility != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateProjectScreen(
            userData: userData,
            type: type,
            selectedAccessibility: selectedAccessibility,
          ),
        ),
      ).then((_) {
        if (widget.type == 'myproject') {
          _loadMyProjects();
        } else if (widget.type == 'sharedproject') {
          _loadSharedProject();
        } else if (widget.type == 'allproject') {
          _loadAllProjects();
        }
      });
    }
  }

  Future<bool?> _openHealthCheckup(BuildContext context,
      final Map<String, dynamic> userData, String type) async {
    final result = await showDialog<bool?>(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder(
          future: _checkHealth(),
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

  Future<Map<String, dynamic>> _checkHealth() async {
    final token = await TokenManager.getToken();
    final response = await apiService.getHealth(
        token!, 'create_project'); // Implement this method in your code
    final Map<String, dynamic> healthData = response;
    print('health data $healthData');
    if (healthData["runningServices"][0] == 'SureOps' &&
        healthData["runningServices"][1] == 'SureJobPro' &&
        healthData["runningServices"][2] == 'SureNode') {
      return {
        "status": "healthy",
      };
    } else {
      final List<String> unhealthyServices = [];
      if (!healthData["runningServices"].contains("SureOps")) {
        unhealthyServices.add("SureOps");
      }
      if (!healthData["runningServices"].contains("SureJobPro")) {
        unhealthyServices.add("SureJobPro");
      }
      if (!healthData["runningServices"].contains("SureNode")) {
        unhealthyServices.add("SureNode");
      }

      return {
        "status": "unhealthy",
        "unhealthyServices": unhealthyServices,
      };
    }
  }
}

class DropdownModel {
  int? id;
  String? projectName;

  DropdownModel({this.id, this.projectName});

  DropdownModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    projectName = json['projectName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['projectName'] = this.projectName;
    return data;
  }
}
