import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:authsec_flutter/Entity/test1/Gtest12/Gtest12_api_service.dart';
import 'package:authsec_flutter/Entity/test1/Gtest12/Gtest12_create_entity_screen.dart';
import 'package:authsec_flutter/Entity/test1/Gtest12/Gtest12_update_entity_screen.dart';
import 'package:authsec_flutter/providers/token_manager.dart';
import 'package:flutter/services.dart';

class gtest12_entity_list_screen extends StatefulWidget {
  static const String routeName = '/entity-list';

  @override
  _gtest12_entity_list_screenState createState() =>
      _gtest12_entity_list_screenState();
}

class _gtest12_entity_list_screenState
    extends State<gtest12_entity_list_screen> {
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
                return ListTile(
                  title: Text(entity['id'].toString()),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(entity['fname'] ?? 'No fname provided'),
                      const SizedBox(height: 4),
                      Text(entity['number_field'].toString() ??
                          'No number_field provided'),
                      const SizedBox(height: 4),
                      Text(entity['password_field'] ??
                          'No password_field provided'),
                      const SizedBox(height: 4),
                      Text(entity['email_field'] ?? 'No email_field provided'),
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
