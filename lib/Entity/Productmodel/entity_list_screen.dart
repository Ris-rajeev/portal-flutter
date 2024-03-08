import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:authsec_flutter/Entity/Productmodel/Product.dart';
import 'package:authsec_flutter/Entity/Productmodel/api_service.dart';
import 'package:authsec_flutter/Entity/Productmodel/create_entity_screen.dart';
import 'package:authsec_flutter/Entity/Productmodel/update_entity_screen.dart';
import 'package:authsec_flutter/providers/token_manager.dart';

class EntityListScreen extends StatefulWidget {
  static const String routeName = '/entity-list';

  @override
  _EntityListScreenState createState() => _EntityListScreenState();
}

class _EntityListScreenState extends State<EntityListScreen> {
  final ApiService apiService = ApiService();
  List<Product> entities = [];

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

  Future<void> deleteEntity(Product entity) async {
    try {
      final token = await TokenManager.getToken();
      await apiService.deleteEntity(token!, entity.id);
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
          ? Center(
              child: Text('No entities found.'),
            )
          : ListView.builder(
              itemCount: entities.length,
              itemBuilder: (BuildContext context, int index) {
                final entity = entities[index];
                return ListTile(
                  title: Text(entity.productId.toString()),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(entity.name ?? 'No name provided'),
                      const SizedBox(height: 4),
                      Text(entity.description ?? 'No description provided'),
                      const SizedBox(height: 4),
                      Text(entity.address ?? 'No address provided'),
                      const SizedBox(height: 4),
                      Text(entity.mobno ?? 'No mobno provided'),
                      const SizedBox(height: 4),
                      Text(entity.email ?? 'No email provided'),
                      const SizedBox(height: 4),
                      Text(entity.mobno ?? 'No mobno provided'),
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
