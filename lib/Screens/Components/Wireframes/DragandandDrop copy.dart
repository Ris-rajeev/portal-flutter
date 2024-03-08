import 'dart:convert';
import 'package:flutter/material.dart';

class DragAndDrop1FormBuilder extends StatefulWidget {
  final int headerId; // Pass the headerId to this screen

  DragAndDrop1FormBuilder({required this.headerId});
  @override
  _DragAndDrop1FormBuilderState createState() =>
      _DragAndDrop1FormBuilderState();
}

class _DragAndDrop1FormBuilderState extends State<DragAndDrop1FormBuilder> {
  List<Map<String, dynamic>> formFields = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController labelController = TextEditingController();
  List<Map<String, String>> basicFields = [
    {'label': 'Text', 'type': 'Text'},
    {'label': 'Email', 'type': 'Email'},
    {'label': 'Password', 'type': 'Password'},
  ];
  List<Map<String, String>> advFields = [
    {'label': 'Phone', 'type': 'Phone'},
    {'label': 'Number', 'type': 'Number'},
    {'label': 'Date', 'type': 'Date'},
    {'label': 'Datetime', 'type': 'Datetime'},
    {'label': 'Textarea', 'type': 'Textarea'},
    {'label': 'Paragraph', 'type': 'Paragraph'},
    {'label': 'Checkbox', 'type': 'Checkbox'},
  ];
  bool showChartFields = false;
  bool showOtherFields = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Builder'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 400,
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () {
                // Show a dialog to add fields (basic, advanced, chart, or other)
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Add Field'),
                      contentPadding: EdgeInsets.all(24),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: labelController,
                            decoration: const InputDecoration(
                              labelText: 'Add fields',
                            ),
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _customElevatedButton(
                                  text: 'Basic',
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    setState(() {
                                      formFields.addAll(basicFields);
                                    });
                                  },
                                ),
                                _customElevatedButton(
                                  text: 'Adv.',
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    setState(() {
                                      formFields.addAll(advFields);
                                    });
                                  },
                                ),
                                _customElevatedButton(
                                  text: 'Chart',
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    setState(() {
                                      showChartFields = true;
                                      showOtherFields = false;
                                      formFields.clear();
                                    });
                                  },
                                ),
                                _customElevatedButton(
                                  text: 'Other',
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    setState(() {
                                      showChartFields = false;
                                      showOtherFields = true;
                                      formFields.clear();
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (showChartFields) ...[
                            // Handle chart fields here
                          ] else if (showOtherFields) ...[
                            // Handle other fields here
                          ],
                        ],
                      ),
                    );
                  },
                );
              },
              child: const Text('Add Field'),
            ),
            ElevatedButton(
              onPressed: () {
                // Convert the form configuration to JSON
                final name = nameController.text;
                final description = descriptionController.text;
                final jsonConfig = jsonEncode({
                  'name': name,
                  'description': description,
                  'attributes': formFields,
                });
                print(jsonConfig);
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _customElevatedButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
        style: ElevatedButton.styleFrom(
          primary: Colors.blue[900],
        ),
      ),
    );
  }

  Widget _buildDraggableFormField(Map<String, dynamic> field, int index) {
    final fieldType = field['type'];
    final fieldLabel = field['label'];
    return Card(
      key: ValueKey<int>(index),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ListTile(
        title: Text('$fieldLabel - $fieldType'),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            setState(() {
              formFields.removeAt(index);
            });
          },
        ),
      ),
    );
  }
}
