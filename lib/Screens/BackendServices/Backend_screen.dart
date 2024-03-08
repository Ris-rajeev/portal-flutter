import 'package:authsec_flutter/screens/BackendServices/BackendService.dart';
import 'package:authsec_flutter/screens/BackendServices/CreateBackend.dart';
import 'package:authsec_flutter/screens/BackendServices/UpdateBackend.dart';
import 'package:flutter/material.dart';
import 'package:authsec_flutter/providers/token_manager.dart';

class Backend_screen extends StatefulWidget {
  final int projectId;

  Backend_screen({required this.projectId});

  @override
  // ignore: library_private_types_in_public_api
  _Backend_screenState createState() => _Backend_screenState();
}

class _Backend_screenState extends State<Backend_screen> {
  final backendApiService backendService = backendApiService();
  List<Map<String, dynamic>> entities = [];

  @override
  void initState() {
    super.initState();
    fetchEntities();
  }

  Future<void> fetchEntities() async {
    try {
      final token = await TokenManager.getToken();

      if (token != null) {
        // apiService.setToken(token);
        final fetchedEntities = await backendService.getBackendByprojectId(
            token!, widget.projectId);
        setState(() {
          entities = fetchedEntities;
          print(entities);
        });
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to fetch entities: $e'),
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
      await backendService.delete_Backend(token!, entity['id']);
      setState(() {
        entities.remove(entity);
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to delete Backend: $e'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Backend List')),
      body: entities == null
          ? const Center(child: CircularProgressIndicator())
          : entities.isEmpty
              ? const Center(
                  child: Text('No backend available.'),
                )
              : ListView.builder(
                  itemCount: entities.length,
                  itemBuilder: (BuildContext context, int index) {
                    final entity = entities[index];
                    return Card(
                      // Wrap the list item in a Card widget
                      elevation: 2, // You can adjust the elevation as needed
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16), // Add margin
                      child: ListTile(
                        title: Text(entity['id'].toString()),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(entity['backend_service_name'] ??
                                'No name provided'),
                            const SizedBox(height: 4),
                            Text(entity['techstack'] ??
                                'No Technology provided'),
                            const SizedBox(height: 4),
                            // Added address text
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
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
                            ];
                          },
                          onSelected: (String value) {
                            if (value == 'edit') {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UpdateBackendScreen(
                                          projectId: widget.projectId,
                                          entity: entity))).then((_) {
                                fetchEntities();
                              });
                            } else if (value == 'delete') {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Confirm Deletion'),
                                    content: const Text(
                                        'Are you sure you want to delete?'),
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
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add new Backend",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CreateBackendScreen(projectId: widget.projectId),
            ),
          ).then((_) {
            fetchEntities();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
