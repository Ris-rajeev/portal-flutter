import 'package:authsec_flutter/screens/Components/Dashboard/DashboardScreen.dart';
import 'package:authsec_flutter/screens/Components/List%20Builder/ListBuilderScreen.dart';
import 'package:authsec_flutter/screens/Components/Wireframes/WireframeScreen.dart';
import 'package:flutter/material.dart';

import 'ReportBuilder/ReportBuilderScreen.dart';

class ComponentsScreen extends StatelessWidget {
  final int projId;
  final int moduleId;
  final String type;

  ComponentsScreen(
      {required this.projId,
      required this.moduleId,
      required this.type,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample data for cards
    final List<String> cardNames = [
      'Wireframe',
      'List Builder',
      'Dashboard',
      'Report Builder'
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Components'),
      ),
      body: ListView.builder(
        itemCount: (cardNames.length / 2).ceil(), // Number of rows
        itemBuilder: (BuildContext context, int row) {
          final int startIndex = row * 2;
          final int endIndex = startIndex + 2;

          return Row(
            children: [
              for (int index = startIndex; index < endIndex; index++)
                if (index < cardNames.length)
                  Expanded(
                    child: ComponentCard(
                      componentName: cardNames[index],
                      onTap: () {
                        // Navigate to the corresponding widget
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              if (index == 0) {
                                return Wireframe_screen(
                                    projId: projId,
                                    moduleId: moduleId,
                                    type: type);
                              } else if (index == 1 && type == 'myproject') {
                                return ListBuilder_screen(
                                    projId: projId, moduleId: moduleId);
                              } else if (index == 2 && type == 'myproject') {
                                return Dashboard_screen(
                                    projId: projId, moduleId: moduleId);
                              } else if (index == 3 && type == 'myproject') {
                                return ReportPage(); //ReportBuilder();
                              } else {
                                return Placeholder(); // Replace with your widget
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
            ],
          );
        },
      ),
    );
  }
}

class ComponentCard extends StatelessWidget {
  final String componentName;
  final VoidCallback onTap;

  ComponentCard({
    required this.componentName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Center-align the text vertically
            children: [
              Text(
                componentName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign:
                    TextAlign.center, // Center-align the text horizontally
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Replace the following widget placeholders with your actual wireframe and list builder widgets.

class ListBuilderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Builder Widget'),
      ),
      body: const Center(
        child: Text('Your List Builder Content Here'),
      ),
    );
  }
}
