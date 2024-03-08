import 'package:authsec_flutter/screens/project_screen/project_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../providers/token_manager.dart';

class ProjectCard extends StatelessWidget {
  final String projectName;
  final String description;
  final String type;
  final bool is_stared;
  final bool is_watchlisted;
  final bool is_fav;
  final VoidCallback onEditPressed;
  final VoidCallback onSureOpsPressed;
  final VoidCallback onModulesPressed;
  final VoidCallback onDeletePressed;
  final VoidCallback onAddAwesome;
  final VoidCallback onAddWatchListed;
  final VoidCallback onAddFavourite;
  final VoidCallback onShareProject;
  final Map<String, dynamic> project;

  ProjectApiService apiService = ProjectApiService();

  ProjectCard({
    required this.projectName,
    required this.description,
    required this.type,
    required this.is_stared,
    required this.is_fav,
    required this.is_watchlisted,
    required this.onEditPressed,
    required this.onSureOpsPressed,
    required this.onModulesPressed,
    required this.onDeletePressed,
    required this.onAddAwesome,
    required this.onAddWatchListed,
    required this.onAddFavourite,
    required this.onShareProject,
    required this.project,
  });

  void _addToLibrary() async {
    int projectid = project['id'];
    final token = await TokenManager.getToken();
    Response response = await apiService.addProjectToLibrary(token!, projectid);
    if (response.statusCode! >= 200 && response.statusCode! <= 209) {
      // Success popup
      Fluttertoast.showToast(
        msg: 'Added to library successfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP_RIGHT,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
      );
    } else {
      // Error popup
      Fluttertoast.showToast(
        msg: 'Failed to add to library',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  projectName ?? 'empty',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    type == 'myproject'
                        ? Tooltip(
                            message: 'Add to Library', // Tooltip message
                            child: GestureDetector(
                              onTap: () {
                                _addToLibrary();
                                print("working");
                              },
                              child: const Icon(
                                Icons.library_add_outlined,
                                size: 20,
                              ),
                            ),
                          )
                        : Tooltip(
                            message: 'Add to Library', // Tooltip message
                            child: GestureDetector(
                              onTap: () {
                                Fluttertoast.showToast(
                                  msg: 'Unauthorized access',
                                  backgroundColor: Colors.red,
                                );
                              },
                              child: const Icon(
                                Icons.library_add_outlined,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ),
                          ),
                    const SizedBox(
                        width: 10), // Adjust the negative width for overlap
                    type == 'myproject'
                        ? Tooltip(
                            message: !is_stared
                                ? 'Add to Awesome'
                                : 'Remove from Awesome', // Tooltip message
                            child: GestureDetector(
                              onTap: onAddAwesome,
                              child: Container(
                                child: Icon(
                                  Icons.star,
                                  color: is_stared ? Colors.red : Colors.grey,
                                  size: 20,
                                ),
                              ),
                            ),
                          )
                        : Tooltip(
                            message: 'Add to Awesome', // Tooltip message
                            child: GestureDetector(
                              onTap: () {
                                Fluttertoast.showToast(
                                  msg: 'Unauthorized access',
                                  backgroundColor: Colors.red,
                                );
                              },
                              child: Container(
                                child: Icon(
                                  Icons.star,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(width: 10),
                    type == 'myproject'
                        ? Tooltip(
                            message: !is_watchlisted
                                ? 'Add to Watchlist'
                                : 'Remove from Watchlist', // Tooltip message
                            child: GestureDetector(
                              onTap: onAddWatchListed,
                              child: Container(
                                child: Icon(
                                  Icons.remove_red_eye,
                                  color: is_watchlisted
                                      ? Colors.blue
                                      : Colors.grey,
                                  size: 20,
                                ),
                              ),
                            ),
                          )
                        : Tooltip(
                            message: 'Add to Watchlist', // Tooltip message
                            child: GestureDetector(
                              onTap: () {
                                Fluttertoast.showToast(
                                  msg: 'Unauthorized access',
                                  backgroundColor: Colors.red,
                                );
                              },
                              child: Container(
                                child: Icon(
                                  Icons.remove_red_eye,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(width: 10),
                    type == 'myproject'
                        ? Tooltip(
                            message: !is_fav
                                ? 'Add to Favourite'
                                : 'Remove From Favourite',
                            child: GestureDetector(
                              onTap: onAddFavourite,
                              child: Container(
                                child: Icon(
                                  Icons.favorite,
                                  color:
                                      is_fav ? Colors.redAccent : Colors.grey,
                                  size: 20,
                                ),
                              ),
                            ),
                          )
                        : Tooltip(
                            message: 'Add to Favourite',
                            child: GestureDetector(
                              onTap: () {
                                Fluttertoast.showToast(
                                  msg: 'Unauthorized access',
                                  backgroundColor: Colors.red,
                                );
                              },
                              child: Container(
                                child: Icon(
                                  Icons.favorite,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(width: 10),
                    type == 'myproject'
                        ? Tooltip(
                            message: 'Share Project',
                            child: GestureDetector(
                              onTap: onShareProject,
                              child: Container(
                                child: const Icon(
                                  Icons.share,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                              ),
                            ),
                          )
                        : Tooltip(
                            message: 'Share Project',
                            child: GestureDetector(
                              onTap: () {
                                Fluttertoast.showToast(
                                  msg: 'Unauthorized access',
                                  backgroundColor: Colors.red,
                                );
                              },
                              child: Container(
                                child: const Icon(
                                  Icons.share,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                              ),
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
                  description ?? 'empty',
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
                    Column(
                      children: [
                        type == 'myproject'
                            ? IconButton(
                                tooltip: 'Edit',
                                onPressed: onEditPressed,
                                icon: const Icon(Icons.edit_outlined),
                              )
                            : IconButton(
                                tooltip: 'Edit',
                                icon: const Icon(
                                  Icons.edit_outlined,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  Fluttertoast.showToast(
                                    msg: 'Unauthorized access',
                                    backgroundColor: Colors.red,
                                  );
                                },
                              ),
                        const Text(
                          'Edit', // Add the label
                          style: TextStyle(
                            color:
                                Colors.black54, // Set the text color to white
                            fontSize: 10, // Adjust the font size as needed
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          tooltip: 'Sureops',
                          onPressed: onSureOpsPressed,
                          icon: const Icon(Icons.all_inclusive_sharp),
                        ),
                        const Text(
                          'Sureops', // Add the label
                          style: TextStyle(
                            color:
                                Colors.black54, // Set the text color to white
                            fontSize: 10, // Adjust the font size as needed
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          tooltip: 'Modules',
                          onPressed: onModulesPressed,
                          icon: const Icon(Icons.hexagon_outlined),
                        ),
                        const Text(
                          'Services', // Add the label
                          style: TextStyle(
                            color:
                                Colors.black54, // Set the text color to white
                            fontSize: 10, // Adjust the font size as needed
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        type == 'myproject'
                            ? IconButton(
                                tooltip: 'Delete',
                                onPressed: onDeletePressed,
                                icon: const Icon(Icons.delete_outline),
                              )
                            : IconButton(
                                tooltip: 'Delete',
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  Fluttertoast.showToast(
                                    msg: 'Unauthorized Access',
                                    backgroundColor: Colors.red,
                                  );
                                },
                              ),
                        const Text(
                          'Delete', // Add the label
                          style: TextStyle(
                            color:
                                Colors.black54, // Set the text color to white
                            fontSize: 10, // Adjust the font size as needed
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
