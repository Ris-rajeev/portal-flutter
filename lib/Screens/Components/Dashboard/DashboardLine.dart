// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:authsec_flutter/screens/Components/Dashboard/Dashboard_Service.dart';
import 'package:authsec_flutter/screens/Components/Dashboard/chartlist.dart';
import 'package:authsec_flutter/screens/Components/Wireframes/Wireframe_Service.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';

import '../../../providers/token_manager.dart';

class DashboardLineBuilder extends StatefulWidget {
  final Map<String, dynamic> entity;
  // Add moduleId parameter

  DashboardLineBuilder({required this.entity, Key? key}) : super(key: key);
  @override
  _DashboardLineBuilderState createState() => _DashboardLineBuilderState();
}

class _DashboardLineBuilderState extends State<DashboardLineBuilder> {
  final DashboardApiService dashService = DashboardApiService();

  int? editedFieldIndex;
  List<Map<String, dynamic>> formFields = [];
  List<Map<String, dynamic>> workflowfield = [];

  String model = '';
  late Map<String, dynamic> jsonData;

  String? selectedCategory;

  // ignore: non_constant_identifier_names
  TextEditingController chart_titleController = TextEditingController();

  final TextEditingController charturlController = TextEditingController();
  final TextEditingController chartparameterController =
      TextEditingController();
  final TextEditingController datasourceController = TextEditingController();

  FocusNode nameFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();

  Map<String, List<Map<String, dynamic>>> categoriesFields = {
    'COMPONENTS': [
      {"name": "Bar Chart", "component": "Bar Chart"},
      {"component": "Line Chart", "name": "Line Chart"},
      {"component": "Doughnut Chart", "name": "Doughnut Chart"},
      {"component": "Pie Chart", "name": "Pie Chart"},
      {"component": "Radar Chart", "name": "Radar Chart"},
      {"component": "Polar Area Chart", "name": "Polar Area Chart"},
      {"component": "Bubble Chart", "name": "Bubble Chart"},
      {"component": "Scatter Chart", "name": "Scatter Chart"},
      {"component": "Dynamic Chart", "name": "Dynamic Chart"},
      {"component": "Financial Chart", "name": "Financial Chart"},
      {"component": "To Do Chart", "name": "To Do Chart"},
      {"component": "Grid View", "name": "Grid View"}
    ],
  };
  Future<void> _fetchModelData() async {
    final modelData = widget.entity;
    try {
      if (modelData.isNotEmpty) {
        setState(() {
          model = modelData['model'].toString();
        });

        jsonData = json.decode(model);
        print('model data is ... $jsonData');

        if (jsonData['dashboard'] != null) {
          final dynamic dashboardData = jsonData['dashboard'];

          if (dashboardData is List<dynamic>) {
            formFields = List<Map<String, dynamic>>.from(dashboardData);
          } else {
            print('Error: Dashboard data is not a List');
          }
        } else {
          print('Error: Dashboard data is missing');
        }
      }
    } catch (e) {
      print('Error fetching or decoding model data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchModelData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Builder'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              color: Colors.grey[300],
              child: ReorderableListView(
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) {
                      newIndex -= 1;
                    }
                    final item = formFields.removeAt(oldIndex);
                    formFields.insert(newIndex, item);
                  });
                },
                children: [
                  for (int index = 0; index < formFields.length; index++)
                    _buildDraggableFormField(formFields[index], index),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white, // Customize the background color
        child: Container(
          padding: const EdgeInsets.symmetric(
              vertical: 8.0), // Adjust vertical padding
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceEvenly, // Distribute buttons evenly
            children: [
              ElevatedButton(
                onPressed: () {
                  _showAddChartDialog();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0), // Adjust button padding
                ),
                child: const Text('Add Chart',
                    style: TextStyle(
                        fontSize: 16.0)), // Customize button text style
              ),
              ElevatedButton(
                onPressed: () async {
                  // Update action
                  final jsonConfig = jsonEncode({
                    'dashboard': formFields,
                  });
                  widget.entity['model'] = jsonConfig.toString();

                  final token = await TokenManager.getToken();
                  try {
                    await dashService.updatedashboardLine(
                        token!, widget.entity['id'], widget.entity);
                    Navigator.pop(context);
                  } catch (e) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: Text('Failed to update dashboardline: $e'),
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
                  print(jsonConfig);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0), // Adjust button padding
                ),
                child: const Text('Update',
                    style: TextStyle(
                        fontSize: 16.0)), // Customize button text style
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddChartDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        final double screenWidth = MediaQuery.of(context).size.width;
        return AlertDialog(
          title: const Text('Add Chart'),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: SizedBox(
              width: screenWidth > 600
                  ? 600
                  : screenWidth, // Adjust the maximum width as needed

              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // Ensure the column takes minimum space
                children: [
                  _buildAddChartButton("Bar Chart"),
                  const SizedBox(height: 16), // Add space between buttons
                  _buildAddChartButton("Line Chart"),
                  const SizedBox(height: 16),
                  _buildAddChartButton("Pie Chart"),
                  const SizedBox(height: 16),
                  _buildAddChartButton("Doughnut Chart"),
                  const SizedBox(height: 16),
                  _buildAddChartButton("Bubble Chart"),
                  const SizedBox(height: 16),
                  _buildAddChartButton("Scatter Chart"),
                  const SizedBox(height: 16),
                  _buildAddChartButton("Dynamic Chart"),
                  const SizedBox(height: 16),
                  _buildAddChartButton("Financial Chart"),
                  const SizedBox(height: 16),
                  _buildAddChartButton("To Do Chart"),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildAddChartButton(String chartType) {
    return SizedBox(
      width: double.infinity, // Make the button as wide as the parent
      child: ElevatedButton(
        onPressed: () {
          _addField(chartType);
          Navigator.of(context);
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                8), // Add border radius for a rectangular shape
          ),
        ),
        child: Text('Add $chartType'),
      ),
    );
  }

  void _addField(String fieldType) {
    setState(() {
      // Calculate the next chartid by finding the maximum chartid in existing fields
      int maxChartId = 2;
      var newchart = fieldType;
      for (final field in formFields) {
        final int chartId = field['chartid'] ?? 0;
        if (chartId > maxChartId) {
          maxChartId = chartId;
        }
      }

      // Increment the maximum chartid to generate a unique chartid
      final newChartId = maxChartId + 1;

      // Add the new chart widget to formFields (if needed)
      formFields.add({
        'charttitle': newchart,
        'type': fieldType,
        "cols": 5,
        "rows": 5,
        "x": 0,
        "y": 0,
        "chartid": newChartId,
        "component": fieldType,
        "name": fieldType,
      });
    });
  }

  Widget _buildDraggableFormField(Map<String, dynamic> field, int index) {
    final GlobalKey key = GlobalKey(); // Create a unique key

    final TextEditingController charttitlecontroller = TextEditingController(
      text: field['charttitle'],
    );

    charttitlecontroller.addListener(() {
      formFields[index]['charttitle'] = charttitlecontroller.text;
    });

    final fieldType = field['type'];

    Widget chartWidget;

    if (fieldType == 'Bar Chart') {
      chartWidget = BarChartWidget();
    } else if (fieldType == 'Line Chart') {
      chartWidget = LineChartWidget();
    } else if (fieldType == 'Doughnut Chart') {
      chartWidget = DonutChartWidget();
    } else if (fieldType == 'Pie Chart') {
      chartWidget = PieChartWidget();
    } else if (fieldType == 'Bubble Chart') {
      chartWidget = BubbleChartWidget();
    } else if (fieldType == 'Scatter Chart') {
      chartWidget = ScatterChartWidget();
    } else if (fieldType == 'Dynamic Chart') {
      chartWidget = DynamicLineChart();
    } else if (fieldType == 'Financial Chart') {
      chartWidget = FinancialChartDemo();
    } else if (fieldType == 'To Do Chart') {
      chartWidget = TodoChartWidget();
    } else {
      chartWidget = Container(); // Handle other field types if needed
    }

    return ReorderableListener(
      key: key,
      child: Column(
        children: [
          ListTile(
            title: TextFormField(
              controller: charttitlecontroller,
            ),
            subtitle: Text('$fieldType'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Implement an edit action here, e.g., show a dialog or screen
                    _editField(index);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      formFields.removeAt(index);
                    });
                  },
                ),
              ],
            ),
          ),
          chartWidget, // Replace with your chart widget
        ],
      ),
    );
  }

// Function to handle editing a field
  Future<void> _editField(int index) async {
    editedFieldIndex = index;
    final field = formFields[index];
    var chart_titleController = TextEditingController(
      text: field['charttitle'],
    );

    // Function to update the external UI label
    void updateExternalLabel() {
      setState(() {
        field['charttitle'] = chart_titleController.text;
      });
    }

    chart_titleController.addListener(updateExternalLabel);

    final charturlController = TextEditingController(
      text: field['charturl'] ?? '',
    );

    final chartparameterController = TextEditingController(
      text: field['chartparameter'] ?? '',
    );
    final datasourceController = TextEditingController(
      text: field['datasource'] ?? '',
    );

    if (datasourceController.text.isEmpty) {
      datasourceController.text = 'Deafault';
    }

    // Add missing boolean properties with default value false
    field['slices'] ??= false;
    field['donut'] ??= false;
    field['chartcolor'] ??= false;
    field['chartlegend'] ??= false;
    field['showlabel'] ??= false;
    field['Read Only'] ??= false;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit Field'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      controller: chart_titleController,
                      decoration:
                          const InputDecoration(labelText: 'Chart Title'),
                      onChanged: (newValue) {
                        field['charttitle'] = newValue;
                      },
                    ),

                    DropdownButtonFormField<String>(
                      decoration:
                          const InputDecoration(labelText: 'Data Source'),
                      value: datasourceController.text,
                      items: ['Deafault', 'Private'].map((Category) {
                        return DropdownMenuItem<String>(
                          value: Category,
                          child: Text(Category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          datasourceController.text = value!;
                        });
                      },
                      onSaved: (value) {
                        field['datasource'] = value;
                      },
                    ),

                    TextFormField(
                      controller: charturlController,
                      decoration: const InputDecoration(labelText: 'Chart Url'),
                      onChanged: (newValue) {
                        field['charturl'] = newValue;
                      },
                    ),
                    TextFormField(
                      controller: chartparameterController,
                      decoration:
                          const InputDecoration(labelText: 'Chart Parameter'),
                      onChanged: (newValue) {
                        field['chartparameter'] = newValue;
                      },
                    ),

                    Row(
                      children: [
                        const Text('Slices:'),
                        Switch(
                          value: field['slices'],
                          onChanged: (value) {
                            setState(() {
                              field['slices'] = value;
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Donut:'),
                        Switch(
                          value: field['donut'],
                          onChanged: (value) {
                            setState(() {
                              field['donut'] = value;
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Chart Color:'),
                        Switch(
                          value: field['chartcolor'],
                          onChanged: (value) {
                            setState(() {
                              field['chartcolor'] = value;
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Chart Legend:'),
                        Switch(
                          value: field['chartlegend'],
                          onChanged: (value) {
                            setState(() {
                              field['chartlegend'] = value;
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Show Label:'),
                        Switch(
                          value: field['showlabel'],
                          onChanged: (value) {
                            setState(() {
                              field['showlabel'] = value;
                            });
                          },
                        ),
                      ],
                    ),

                    // Add code to edit other properties as needed

                    // Values section
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('Save'),
                  onPressed: () {
                    setState(() {
                      // Update the field properties with edited values
                      field['charttitle'] = chart_titleController.text;
                      field['charturl'] = charturlController.text;
                      field['chartparameter'] = chartparameterController.text;
                      field['datasource'] = datasourceController.text;
                    });
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
