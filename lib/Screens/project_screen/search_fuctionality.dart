import 'dart:convert';
import 'package:authsec_flutter/screens/project_screen/project_edit_screen.dart';
import 'package:authsec_flutter/screens/project_screen/project_service.dart';
import 'package:authsec_flutter/screens/project_screen/sureops_screen/sureOpsScreen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../../providers/token_manager.dart';
import '../../resources/api_constants.dart';
import '../BackendServices/BackendService.dart';
import '../Components/componentscreen.dart';
import '../Module_screen/ModulesScreen.dart';
import '../Module_screen/UpdateModule.dart';
import '../Module_screen/module_service.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  ProjectApiService apiService = ProjectApiService();
  final ProjectApiService projectApiService = ProjectApiService();
  List<dynamic> headers = [];
  List<dynamic> projects = [];
  List<dynamic> Services = [];
  List<dynamic> users = [];
  bool isLoading = false;

  Future<void> searchApi(String keyword) async {
    setState(() {
      isLoading = true;
    });

    final token = await TokenManager.getToken();
    String baseUrl = ApiConstants.baseUrl;
    final apiUrl = '$baseUrl/fnd/project/search/$keyword';
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        headers = jsonData['headers'];
        projects = jsonData['projects'];
        Services = jsonData['modules'];
        users = jsonData['users'];
        isLoading = false;
      });
    } else {
      // Handle API error
      print('API Error: ${response.statusCode}');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          // Set the background color of the AppBar
          backgroundColor: Theme.of(context).primaryColor,
          // Set the elevation to add a shadow if needed
          elevation: 0, // You can adjust this value if you want a shadow

          // Customize the size of the back arrow icon
          iconTheme: IconThemeData(
            size: 2, // Adjust the size as needed
            color: Colors.white, // You can change the color if desired
          ),

          // The flexibleSpace property allows you to customize the content within the AppBar
          flexibleSpace: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Container(
              // Adjust the padding to position the TabBar correctly within the AppBar
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              // Align the TabBar to the bottom of the AppBar
              alignment: Alignment.bottomCenter,
              child: TabBar(
                tabs: [
                  Tab(text: 'Headers'),
                  Tab(text: 'Projects'),
                  Tab(text: 'Services'),
                  Tab(text: 'Users'),
                ],
              ),
            ),
          ),
        ),

        // PreferredSize(
        //   preferredSize: Size.fromHeight(kToolbarHeight),
        //   child: Container(
        //     color: Theme.of(context).primaryColor,
        //     child: TabBar(
        //       tabs: [
        //         Tab(text: 'Headers'),
        //         Tab(text: 'Projects'),
        //         Tab(text: 'Services'),
        //         Tab(text: 'Users'),
        //       ],
        //     ),
        //   ),
        // ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Enter keyword',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      String keyword = _searchController.text;
                      searchApi(keyword);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  buildHeadersTab(),
                  buildProjectsTab(),
                  buildServicesTab(),
                  buildUsersTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeadersTab() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (headers.isEmpty) {
      return Center(child: Text('No data available'));
    }

    return ListView.builder(
      itemCount: headers.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(headers[index]['headerName'] ?? ''),
        );
      },
    );
  }

//-------------------------------------------------------------------------------------------------------
  Widget buildProjectsTab() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (projects.isEmpty) {
      return Center(child: Text('No data available'));
    }

    return ListView.builder(
      itemCount: projects.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 4,
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      projects[index]['projectName'] ?? '',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Tooltip(
                          message: 'Add to Library', // Tooltip message
                          child: GestureDetector(
                            onTap: () {
                              //_addToLibrary();
                              print("working");
                            },
                            child: const Icon(
                              Icons.library_add_outlined,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(
                            width: 10), // Adjust the negative width for overlap
                        Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(
                            width: 10), // Adjust the negative width for overlap
                        Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Stack(
                  children: [
                    Text(
                      projects[index]['description'] ?? '',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Container(
                    color: Colors.grey[200],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          tooltip: 'Edit',
                          onPressed: () {
                            Fluttertoast.showToast(
                              msg: 'Unauthorized access',
                              backgroundColor: Colors.red,
                            );
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) =>
                            //           CreateEditProjectScreen(project: projects[index]),
                            //     )).then((_) {
                            //   //_loadProjects();
                            // });
                          },
                          icon: const Icon(
                            Icons.edit_outlined,
                            color: Colors.grey,
                          ),
                        ),
                        IconButton(
                          tooltip: 'Sureops',
                          onPressed: () {
                            int Projectid = projects[index]['id'];
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SureOpsScreen(
                                  project: projects[index],
                                  type: 'search',
                                  userData: {},
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.all_inclusive_sharp),
                        ),
                        IconButton(
                          tooltip: 'Modules',
                          onPressed: () {
                            final mod = projects[index]['modules'];
                            print('modules fetched ... ');

                            // Handle Modules button pressed for this project
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ModuleScreen(
                                        projectId: projects[index]['id'],
                                        type: 'search',
                                      )),
                            );
                          },
                          icon: const Icon(Icons.hexagon_outlined),
                        ),
                        IconButton(
                          tooltip: 'Delete',
                          onPressed: () {
                            Fluttertoast.showToast(
                              msg: 'Unauthorized access',
                              backgroundColor: Colors.red,
                            );
                            // showDialog(
                            //   context: context,
                            //   builder: (BuildContext context) {
                            //     return AlertDialog(
                            //       title: const Text('Confirm Deletion'),
                            //       content: const Text(
                            //           'Are you sure you want to delete this entity?'),
                            //       actions: [
                            //         TextButton(
                            //           child: const Text('Cancel'),
                            //           onPressed: () {
                            //             Navigator.of(context).pop();
                            //           },
                            //         ),
                            //         TextButton(
                            //           child: const Text('Delete'),
                            //           onPressed: () {
                            //             Navigator.of(context).pop();
                            //             deleteEntity(projects[index]);
                            //           },
                            //         ),
                            //       ],
                            //     );
                            //   },
                            // );
                          },
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
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

//-----------------------------------------------------------------------------------------------------------
  late List<dynamic> backend_config = [];
  late List<dynamic> db_config = [];
  late List<Map<String, dynamic>> backends = [];
  late Map<String, dynamic> mod = {};
  late List<dynamic> backendconfigs = [];
  late Map<String, List<dynamic>> allconfigs = {};
  final ModuleApiService moduleApiService = ModuleApiService();
  final backendApiService backendservice = backendApiService();

  Future<void> _loadconfigs(int moduleId) async {
    final token = await TokenManager.getToken();
    try {
      final configs =
          await moduleApiService.getAllConfigByModuleId(token!, moduleId);
      setState(() {
        allconfigs = configs;

        // allconfigs = configs;
        // backend_config = configs['backend']!;
        db_config = configs['dbconfig']!;

        print('bac and db is $backend_config  and $db_config');
      });
    } catch (e) {
      print('Failed to load configs: $e');
    }
  }

  Future<void> deleteService(Map<String, dynamic> entity) async {
    try {
      final token = await TokenManager.getToken();
      await moduleApiService.deletemodule(token!, entity['id']);
      setState(() {
        Services.remove(entity);
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

  Future<void> _addtomoduleLibrary(int moduleId) async {
    final token = await TokenManager.getToken();

    try {
      final response =
          await moduleApiService.moduleaddtolibrary(token!, moduleId);

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

  Future<void> _callBackendAPI(int backendId, int moduleId) async {
    final token = await TokenManager.getToken();
    try {
      // Replace 'YOUR_API_ENDPOINT' with your actual API endpoint to call the API.
      final backend = await backendservice.getBackendById(
        token!,
        backendId,
      );

      final module = await moduleApiService.getModuleById(token!, moduleId);

      mod = module;

      backendconfigs = mod['backendConfig_ts'];
      backendconfigs.add(backend);

      mod['backendConfig_ts'] = backendconfigs;

      await moduleApiService.updatemodule(token!, moduleId, mod);

      // Process the API response as needed.
      print('API Response: $backend');
    } catch (e) {
      print('Failed to call backend API: $e');
    }
  }

  Future<void> _fetchBackendData(dynamic module) async {
    final token = await TokenManager.getToken();
    try {
      // Replace 'YOUR_API_ENDPOINT' with your actual API endpoint to fetch backend data.
      final backendData = await backendservice.getBackendByprojectId(
        token!,
        module['projectId'],
      );
      setState(() {
        backends = backendData;
      });

      // Show the data in a dialog or another widget as per your requirement.
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Backend Data'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  for (var backend in backends)
                    ListTile(
                      title: Text(backend['backend_service_name'] ?? 'N/A'),
                      subtitle: Text(backend['techstack'] ?? 'N/A'),
                      trailing: ElevatedButton(
                        onPressed: () {
                          // Call the API for this specific backend item
                          _callBackendAPI(backend['id'], module['id'])
                              .then((_) {
                            //_loadModules();
                          });
                        },
                        child: const Text('Add In Module'),
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Failed to fetch backend data: $e');
    }
  }

  Widget buildServicesTab() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (Services.isEmpty) {
      return Center(child: Text('No data available'));
    }

    return ListView.builder(
      itemCount: Services.length,
      itemBuilder: (context, index) {
        final module = Services[index];
        //_loadconfigs(module['id']);
        return Card(
          elevation: 4,
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.star,
                    color: Colors.red, // Use your desired color
                  ),
                  title: Text(
                    '${module['moduleName'] ?? 'N/A'}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const SizedBox(height: 8),
                Container(
                  color: Colors.grey[200],
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      for (var config in module['backendConfig_ts'])
                        ListTile(
                          leading: const Icon(
                            Icons.splitscreen_sharp, // Use the Spring Boot icon
                            color: Colors.green, // Use your desired color
                          ),
                          title: Text(
                            config['backend_service_name'].toString() ?? 'N/A',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  color: Colors.grey[200],
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      for (var config in backend_config)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            config.toString(),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  color: Colors.grey[200],
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      for (var config in db_config)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            config.toString(),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Container(
                    color: Colors.grey[200],
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              IconButton(
                                tooltip: 'Edit',
                                onPressed: () {
                                  Fluttertoast.showToast(
                                    msg: 'Unauthorized access',
                                    backgroundColor: Colors.red,
                                  );
                                },
                                icon: const Icon(
                                  Icons.edit_outlined,
                                  color: Colors.grey,
                                ),
                              ),
                              const Text(
                                'Edit', // Add the label
                                style: TextStyle(
                                  color: Colors
                                      .black54, // Set the text color to white
                                  fontSize: 8, // Adjust the font size as needed
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                tooltip: 'components',
                                onPressed: () {
                                  final moduleid = module['id'];
                                  print('moduleid is $moduleid');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ComponentsScreen(
                                        projId: module['projectId'],
                                        moduleId: moduleid,
                                        type: 'search',
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                    Icons.miscellaneous_services_sharp),
                              ),
                              const Text(
                                'Components', // Add the label
                                style: TextStyle(
                                  color: Colors
                                      .black54, // Set the text color to white
                                  fontSize: 8, // Adjust the font size as needed
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                tooltip: 'backend',
                                onPressed: () {
                                  _fetchBackendData(module);
                                },
                                icon: const Icon(Icons.data_usage),
                              ),
                              const Text(
                                'Backend', // Add the label
                                style: TextStyle(
                                  color: Colors
                                      .black54, // Set the text color to white
                                  fontSize: 8, // Adjust the font size as needed
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                tooltip: 'Add to service Library',
                                onPressed: () {
                                  Fluttertoast.showToast(
                                    msg: 'Unauthorized access',
                                    backgroundColor: Colors.red,
                                  );
                                },
                                icon: const Icon(
                                  Icons.library_add,
                                  color: Colors.grey,
                                ),
                              ),
                              const Text(
                                'Add to Service Library', // Add the label
                                style: TextStyle(
                                  color: Colors
                                      .black54, // Set the text color to white
                                  fontSize: 8, // Adjust the font size as needed
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                tooltip: 'delete',
                                onPressed: () {
                                  Fluttertoast.showToast(
                                    msg: 'Unauthorized access',
                                    backgroundColor: Colors.red,
                                  );
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.grey,
                                ),
                              ),
                              const Text(
                                'Delete', // Add the label
                                style: TextStyle(
                                  color: Colors
                                      .black54, // Set the text color to white
                                  fontSize: 8, // Adjust the font size as needed
                                ),
                              ),
                            ],
                          ),
                        ]),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  //-----------------------------------------------------------------------------

  Widget buildUsersTab() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (users.isEmpty) {
      return Center(child: Text('No data available'));
    }

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(users[index]['fullName'] ?? ''),
        );
      },
    );
  }
}
