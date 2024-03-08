import 'package:flutter/material.dart';
import 'package:authsec_flutter/Entity/imagemodel/Product.dart';
import 'package:authsec_flutter/Entity/imagemodel/api_service.dart';
import 'package:authsec_flutter/Entity/imagemodel/create_entity_screen.dart';
import 'package:authsec_flutter/Entity/imagemodel/update_entity_screen.dart';
import 'package:authsec_flutter/providers/token_manager.dart';

class ImageEntityListScreen extends StatefulWidget {
  static const String routeName = '/entity-list';

  @override
  _ImageEntityListScreenState createState() => _ImageEntityListScreenState();
}

class _ImageEntityListScreenState extends State<ImageEntityListScreen> {
  final ApiService apiService = ApiService();
  List<Product> entities = [];

  @override
  void initState() {
    super.initState();
    fetchEntities();
  }

  Future<void> fetchEntities() async {
    try {
      final token = await TokenManager.getToken();
      final fetchedEntities = await apiService.getEntities(token!);
      setState(() {
        entities = fetchedEntities;
      });
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
      body: ListView.builder(
        itemCount: entities.length,
        itemBuilder: (BuildContext context, int index) {
          final entity = entities[index];
          return Card(
            // Wrap the list item in a Card widget
            elevation: 2, // You can adjust the elevation as needed
            margin: const EdgeInsets.symmetric(
                vertical: 8, horizontal: 16), // Add margin
            child: ListTile(
              title: Text(entity.productId.toString()),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(entity.name),
                  const SizedBox(height: 4),
                  Text(entity.description),
                  const SizedBox(height: 4),
                  Text(entity.address),
                  const SizedBox(
                    height: 4,
                  ),
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
