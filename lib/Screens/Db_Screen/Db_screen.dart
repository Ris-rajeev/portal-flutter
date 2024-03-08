import 'package:authsec_flutter/screens/Db_Screen/CreateDb.dart';
import 'package:authsec_flutter/screens/Db_Screen/Db_service.dart';
import 'package:authsec_flutter/screens/Db_Screen/UpdateDatabase.dart';
import 'package:flutter/material.dart';
import 'package:authsec_flutter/providers/token_manager.dart';

class Db_screen extends StatefulWidget {
  final int projectId;

  Db_screen({required this.projectId});

  @override
  // ignore: library_private_types_in_public_api
  _Db_screenState createState() => _Db_screenState();
}

class _Db_screenState extends State<Db_screen> {
  final DbApiService dbService = DbApiService();
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
        final fetchedEntities =
            await dbService.getDbByprojectId(token!, widget.projectId);
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
      await dbService.delete_db(token!, entity['id']);
      setState(() {
        entities.remove(entity);
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to delete db: $e'),
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
      appBar: AppBar(title: const Text('Database List')),
      body: entities.isEmpty
          ? const Center(
              child: Text('No Database found.'),
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
                      Text(entity['db_name'] ?? 'No name provided'),
                      const SizedBox(height: 4),
                      Text(entity['techstack'] ?? 'No techstack provided'),
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
                                builder: (context) => UpdateDatabseScreen(
                                    projectId: widget.projectId,
                                    entity: entity))).then((_) {
                          fetchEntities();
                        });
                        ;
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
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateDbScreen(projectId: widget.projectId),
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
