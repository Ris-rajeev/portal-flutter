import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:authsec_flutter/Entity/test2/Gtest2/Gtest2_api_service.dart';
import 'package:authsec_flutter/Entity/test2/Gtest2/Gtest2_create_entity_screen.dart';
import 'package:authsec_flutter/Entity/test2/Gtest2/Gtest2_update_entity_screen.dart';
import 'package:authsec_flutter/providers/token_manager.dart';
import 'package:flutter/services.dart';

class gtest2_entity_list_screen extends StatefulWidget {
  static const String routeName = '/entity-list';

  @override
  _gtest2_entity_list_screenState createState() =>
      _gtest2_entity_list_screenState();
}

class _gtest2_entity_list_screenState extends State<gtest2_entity_list_screen> {
  final ApiService apiService = ApiService();
  List<Map<String, dynamic>> entities = [];

  @override
  void initState() {
    super.initState();
    fetchEntities();
  }

  Future<void> fetchEntities() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // final token = prefs.getString('token');
      final token = await TokenManager.getToken();

      if (token != null) {
        // apiService.setToken(token);
        final fetchedEntities = await apiService.getEntities(token!);
        setState(() {
          entities = fetchedEntities;
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
      await apiService.deleteEntity(token!, entity['id']);
      setState(() {
        entities.remove(entity);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Entity List')),
      body: entities.isEmpty
          ? const Center(
              child: Text('No entities found.'),
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
                        Text(entity['name'] ?? 'No name provided'),
                        const SizedBox(height: 4),
                        Text(entity['testcheck'].toString() ??
                            'No testcheck provided'),
                        const SizedBox(height: 4),
                        Text(entity['ddtest'] ?? 'No ddtest provided'),
                        const SizedBox(height: 4), // Added address text
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
                              builder: (context) =>
                                  UpdateEntityScreen(entity: entity),
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateEntityScreen(),
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
