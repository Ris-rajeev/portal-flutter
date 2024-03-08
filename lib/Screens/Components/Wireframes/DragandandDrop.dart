import 'dart:convert';
import 'package:authsec_flutter/screens/Components/List%20Builder/ListBuilderService.dart';
import 'package:authsec_flutter/screens/Components/Wireframes/Wireframe_Service.dart';
import 'package:authsec_flutter/providers/token_manager.dart';
import 'package:flutter/material.dart';

class DragAndDropFormBuilder extends StatefulWidget {
  final int projId;
  final int headerId; // Pass the headerId to this screen
  final int moduleId;
  final int backendId;

  DragAndDropFormBuilder(
      {super.key,
      required this.projId,
      required this.headerId,
      required this.moduleId,
      required this.backendId});
  @override
  _DragAndDropFormBuilderState createState() => _DragAndDropFormBuilderState();
}

class _DragAndDropFormBuilderState extends State<DragAndDropFormBuilder> {
  final WireframeApiService wfService = WireframeApiService();
  final ListBuilderApiService lbService = ListBuilderApiService();

  var selectchildWf; // Use nullable type
  List<dynamic> childwfData = [];
  List<dynamic> LbTableList = [];
  List<dynamic> LbColumnList = [];
  List<dynamic> lookUpTypeList = [];

  var slecttRealtionship;
  var dynamicList;
  var selectActionType;
  var masterName;
  var lookupType;

  int? editedFieldIndex;
  List<Map<String, dynamic>> formFields = [];
  List<Map<String, dynamic>> workflowfield = [];

  String model = '';
  late Map<String, dynamic> jsonData;
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String? selectedCategory;
  Map<String, dynamic> wfline = {};

  // ignore: non_constant_identifier_names
  TextEditingController chartTitleController = TextEditingController();

  final TextEditingController descriptionTextController =
      TextEditingController();
  final TextEditingController placeholderController = TextEditingController();
  final TextEditingController subtypeController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();
  final TextEditingController regexController = TextEditingController();
  final TextEditingController divNameController = TextEditingController();
  final TextEditingController tooltipMsgController = TextEditingController();
  final TextEditingController maxCharactersController = TextEditingController();
  final TextEditingController visibilityController = TextEditingController();
  final TextEditingController duplicateValController = TextEditingController();
  final TextEditingController encryptDataController = TextEditingController();
  final TextEditingController gridLineNameController = TextEditingController();

  final TextEditingController name1Controller = TextEditingController();
  final TextEditingController ddSelectController = TextEditingController();
  final TextEditingController ddController = TextEditingController();
  final TextEditingController dropdownTypeController = TextEditingController();

  FocusNode nameFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();

  Map<String, List<Map<String, dynamic>>> categoriesFields = {
    'BASIC': [
      {"name": "Text Field", "type": "Text"},
      {"name": "Email Field", "type": "Email"},
      {"name": "Password Field", "type": "Password"},
      {"name": "Phone Field", "type": "phone"},
      {"name": "Date Field", "type": "Date"},
      {"name": "Datetime Field", "type": "Datetime"},
      {"name": "Number Field", "type": "Number"},
      {"name": "Textarea Field", "type": "Textarea"},
      {"type": "Paragraph", "name": "Paragraph Field"},
      {"name": "URL Field", "type": "url"},
      {"name": "Decimal Field", "type": "decimal"},
      {"name": "Percent Field", "type": "percent"},
      {"name": "Toggle Switch", "type": "toggle_switch"},
      {"type": "recaptcha", "name": "Recaptcha"},
    ],
    'ADVANCED': [
      // {"type": "checkbox", "name": "checkbox"},
      {"name": "Survey", "type": "survey"},
      {"name": "Field Group", "type": "field_group"},
      {"name": "Currency", "type": "currency"},
      {"name": "Dropdown Field", "type": "select"},
      {"name": "Radio Field", "type": "Radio"},
      {"name": "RelationShip Field", "type": "RelationShip"},
      {"type": "Button", "name": "Button"},
      {"type": "file", "name": "File Upload"},
      {"name": "Image", "type": "image"},
      {"name": "Value List", "type": "value_list"},
    ],
    'PREMIUM': [
      {"name": "QR Code", "type": "qr_code"},
      {"name": "BAR Code", "type": "bar_code"},
      {"name": "QR Code Scanner", "type": "qr_code_scanner"},
      {"name": "BAR Code Scanner", "type": "bar_code_scanner"},
      {"name": "Calculated Field", "type": "calculated_field"},
      {"name": "Communication", "type": "communication"},
      {"name": "Approval", "type": "approved"},
      {"type": "payment", "name": "Payment"},
      // {"type": "video", "name": "video"},
      // {"type": "audio", "name": "audio"}
    ],
    'OTHER': [
      {'charttitle': 'Other', 'type': 'Other', "name": "other"},
    ],
  };

  Future<void> _fetchModelData() async {
    try {
      chartTitleController.text = 'test';
      final token = await TokenManager.getToken();
      final modelData =
          await wfService.get_wflinebyheaderid(token!, widget.headerId);

      if (modelData.isNotEmpty) {
        setState(() {
          model = modelData['model'].toString();
        });

        jsonData = json.decode(model);
        nameController.text = jsonData['name'];
        descriptionController.text = jsonData['description'];

        if (jsonData['dashboard'] != null) {
          formFields = List<Map<String, dynamic>>.from(jsonData['dashboard']);
        }
        // Set the selectedCategory to "BASIC" when initializing
        selectedCategory = 'BASIC';
        print('cat is .. $selectedCategory');
      }
    } catch (e) {
      print('Error fetching or decoding model data: $e');
    }
  }

  Future<void> _fetchWf() async {
    final token = await TokenManager.getToken();
    final data =
        await wfService.getwfForchild(token!, widget.projId, widget.headerId);
    if (data.isNotEmpty) {
      childwfData = data;
      print('child api data is ... $childwfData');
    }
  }

  Future<void> _fetchListName() async {
    final token = await TokenManager.getToken();
    final data = await lbService.getAllList(token!, widget.headerId);
    if (data.isNotEmpty) {
      LbTableList = data;

      print('lbtable is ... $LbTableList');
    }
  }

  Future<void> _fetchListColumn(String listName) async {
    // LbColumnList.clear();
    // print('LbColumnList after clear is ... $LbColumnList');

    final token = await TokenManager.getToken();
    final data =
        await lbService.getAllListColumns(token!, widget.moduleId, listName);
    if (data.isNotEmpty) {
      setState(() {
        // LbColumnList.clear();
        LbColumnList = data;
      });
      LbColumnList = data;
      print('LbColumnList is ... $LbColumnList');
    }
  }

  Future<void> _fetchLookuptype() async {
    final token = await TokenManager.getToken();
    final data = await wfService.getlookuptype(token!);
    if (data.isNotEmpty) {
      lookUpTypeList = data;
      print('lookuptype is ... $lookUpTypeList');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchModelData();
    _fetchWf();
    _fetchListName();
    _fetchLookuptype();

    print('selecttable is $dynamicList');
    if (dynamicList != null && dynamicList != '') {
      _fetchListColumn(dynamicList);
    }
  }

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
                  TextFormField(
                    controller: nameController, // Use the controller here
                    onChanged: (value) {
                      // You can remove this onChanged if it's not needed
                    },
                    decoration: const InputDecoration(
                      labelText: 'Name',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller:
                        descriptionController, // Use the controller here
                    onChanged: (value) {
                      // You can remove this onChanged if it's not needed
                    },
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
                // Show a dialog to add fields (basic or advanced)
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    final double screenWidth =
                        MediaQuery.of(context).size.width;

                    return StatefulBuilder(
                      builder: (context, setState) {
                        return AlertDialog(
                          // title: const Text('Add Field'),
                          contentPadding: const EdgeInsets.all(24),
                          content: SizedBox(
                            width: screenWidth > 600
                                ? 600
                                : screenWidth, // Adjust the maximum width as needed

                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  DropdownButton<String>(
                                    value: selectedCategory,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedCategory = newValue;
                                      });
                                    },
                                    items: categoriesFields.keys
                                        .map<DropdownMenuItem<String>>(
                                      (String category) {
                                        return DropdownMenuItem<String>(
                                          value: category,
                                          child: Text(category),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                  if (selectedCategory != null)
                                    Wrap(
                                      spacing:
                                          16.0, // Add spacing between fields
                                      runSpacing:
                                          8.0, // Add vertical spacing between rows
                                      children:
                                          categoriesFields[selectedCategory]!
                                              .map<Widget>((field) {
                                        return ElevatedButton(
                                          onPressed: () {
                                            _addField(
                                              chartTitleController.text,
                                              field['type']!,
                                            );
                                            Navigator.of(context);
                                          },
                                          child: SizedBox(
                                            width:
                                                100, // Set a fixed width for each field button
                                            child: Center(
                                                child: Text(field['name']!)),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                ],
                              ),
                            ),
                          ),

                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Close'))
                          ],
                        );
                      },
                    );
                  },
                );
              },
              child: const Text('Add Field'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Convert the form configuration to JSON
                final name = nameController.text;
                final description = descriptionController.text;
                final jsonConfig = jsonEncode({
                  'name': name,
                  'description': description,
                  'dashboard': formFields,
                });
                wfline['model'] = jsonConfig.toString();

                final token = await TokenManager.getToken();
                try {
                  await wfService.updateWf_model(
                      token!,
                      widget
                          .headerId, // Assuming 'id' is the key in your entity map
                      wfline);
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                } catch (e) {
                  // ignore: use_build_context_synchronously
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: Text('Failed to update Workflow: $e'),
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
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _addField(String fieldLabel, String fieldType) {
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
      if (fieldType == 'RelationShip') {
        newchart = 'OneToOne';
      } else if (fieldType == 'communication') {
        newchart = 'Static';
      }

      // Increment the maximum chartid to generate a unique chartid
      final newChartId = maxChartId + 1;
      // Set the label field with the same value as the type field
      formFields.add({
        'charttitle': newchart,
        'type': fieldType,
        "cols": 8,
        "rows": 2,
        "x": 0,
        "y": 0,
        "chartid": newChartId,
        "component": '$fieldType Field',
        "name": '$fieldType Field',
        'description': descriptionTextController.text,
        'placeholder': placeholderController.text,
        'className': 'form-control',
        'subtype': subtypeController.text,
        'size': sizeController.text,
        'regex': regexController.text,
        'div_name': divNameController.text,
        'tooltipmsg': tooltipMsgController.text,
        'maxcharacters': maxCharactersController.text,
        'visibility': visibilityController.text,
        'duplicateVal': duplicateValController.text,
        'encryptData': encryptDataController.text,
        'gridLine_name': gridLineNameController.text,
        "dropdown_type": dropdownTypeController.text,
      });
    });
  }

  Widget _buildDraggableFormField(Map<String, dynamic> field, int index) {
    final TextEditingController charttitlecontroller = TextEditingController(
      text: field['charttitle'],
    );

    charttitlecontroller.addListener(() {
      // Update the label in formFields when text is edited
      formFields[index]['charttitle'] = charttitlecontroller.text;
    });

    final fieldType = field['type'];

    return Card(
      key: ValueKey<int>(index),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ListTile(
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
    );
  }

// Function to handle editing a field
  Future<void> _editField(int index) async {
    editedFieldIndex = index;
    final field = formFields[index];
    var chartTitleController = TextEditingController(
      text: field['charttitle'],
    );

    // Function to update the external UI label
    void updateExternalLabel() {
      setState(() {
        field['charttitle'] = chartTitleController.text;
      });
    }

    chartTitleController.addListener(updateExternalLabel);

    final descriptionTextController = TextEditingController(
      text: field['descriptionText'] ?? '',
    );
    final placeholderController = TextEditingController(
      text: field['placeholder'] ?? '',
    );

    final masterController = TextEditingController();

    final name1Controller = TextEditingController(
      text: field['name'] ?? '',
    );
    final subtypeController = TextEditingController(
      text: field['subtype'] ?? '',
    );
    final sizeController = TextEditingController(
      text: field['size'] ?? '',
    );
    final regexController = TextEditingController(
      text: field['regex'] ?? '',
    );
    final divNameController = TextEditingController(
      text: field['div_name'] ?? '',
    );
    final tooltipMsgController = TextEditingController(
      text: field['tooltipmsg'] ?? '',
    );
    final maxCharactersController = TextEditingController(
      text: field['maxcharacters'] ?? '',
    );
    final visibilityController = TextEditingController(
      text: field['visibility'] ?? '',
    );
    final duplicateValController = TextEditingController(
      text: field['duplicateVal'] ?? '',
    );
    final encryptDataController = TextEditingController(
      text: field['encryptData'] ?? '',
    );

    final TextEditingController gridLineNameController = TextEditingController(
      text: field['gridLine_name'] ?? '',
    );

    var toWireframeController = TextEditingController(
      text: field['toWireframe'] ?? '',
    );
    if (toWireframeController.text.isEmpty && childwfData.isNotEmpty) {
      toWireframeController.text = childwfData[0];
      print('child is $childwfData[0]');
    } else if (toWireframeController.text.isEmpty && childwfData.isEmpty) {
      toWireframeController.text = 'no value';
    }

    var sentToController = TextEditingController(
      text: field['sendTo'] ?? '',
    );

    final TextEditingController bodyController = TextEditingController(
      text: field['body'] ?? '',
    );

    var actiontypeController = TextEditingController(
      text: field['actiontype'] ?? '',
    );
    if (actiontypeController.text.isEmpty) {
      actiontypeController.text = 'update';
    }

    var dropdownTypeController = TextEditingController(
      text: field['dropdown_type'] ?? '',
    );

    if (dropdownTypeController.text.isEmpty) {
      dropdownTypeController.text = 'Static';
    }

    final TextEditingController entity1Controller = TextEditingController(
      text: field['entity1'] ?? '',
    );
    final TextEditingController entity2Controller = TextEditingController(
      text: field['entity2'] ?? '',
    );
    final TextEditingController entity3Controller = TextEditingController(
      text: field['entity3'] ?? '',
    );
    final TextEditingController body1Controller = TextEditingController(
      text: field['body1'] ?? '',
    );
    final TextEditingController body2Controller = TextEditingController(
      text: field['body2'] ?? '',
    );
    final TextEditingController body3Controller = TextEditingController(
      text: field['body3'] ?? '',
    );
    final TextEditingController endpoint1Controller = TextEditingController(
      text: field['endpoint1'] ?? '',
    );
    final TextEditingController endpoint2Controller = TextEditingController(
      text: field['endpoint2'] ?? '',
    );
    final TextEditingController endpoint3Controller = TextEditingController(
      text: field['endpoint3'] ?? '',
    );

    var dynamicListController = TextEditingController(
      text: field['dynamicList'] ?? '',
    );
    final TextEditingController ddSelectController = TextEditingController(
      text: field['ddDisplay'] ?? '',
    );
    final TextEditingController ddDisplayController = TextEditingController(
      text: field['ddSelect'] ?? '',
    );

    // Create a list of values from the field's "values" property
    final List<Map<String, dynamic>> values = List<Map<String, dynamic>>.from(
      field['values'] ?? [],
    );

    // Add missing boolean properties with default value false
    field['personalHealthInfo'] ??= false;
    field['handle'] ??= false;
    field['personalInfo'] ??= false;
    field['showDescription'] ??= false;
    field['required'] ??= false;
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
                    if (field['type'] == 'RelationShip') ...[
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                            labelText: 'Select RelationShip'),
                        value: chartTitleController.text,
                        items: ['OneToOne', 'OneToMany', 'ManyToMany']
                            .map((Category) {
                          return DropdownMenuItem<String>(
                            value: Category,
                            child: Text(Category),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            chartTitleController.text = value!;
                          });
                        },
                        onSaved: (value) {
                          field['charttitle'] = value;
                        },
                      ),

                      // Dropdown for "toWireframe" field
                      DropdownButtonFormField<String>(
                        decoration:
                            const InputDecoration(labelText: 'To Wireframe'),
                        value: toWireframeController.text,
                        items: [
                          ...childwfData.map<DropdownMenuItem<String>>(
                            (item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Text(item),
                              );
                            },
                          ),
                        ],
                        onChanged: (value) {
                          print('selected child : $value');
                          setState(() {
                            selectchildWf = value!;
                            field['toWireframe'] = selectchildWf;
                          });
                        },
                      ),

                      const SizedBox(height: 16),
                    ] else if (field['type'] == 'communication') ...[
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                            labelText: 'Select Communication Type'),
                        value: chartTitleController.text,
                        items: ['Static', 'Dynamic'].map((Category) {
                          return DropdownMenuItem<String>(
                            value: Category,
                            child: Text(Category),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            chartTitleController.text = value!;
                          });
                        },
                        onSaved: (value) {
                          field['charttitle'] = value;
                        },
                      ),
                      TextFormField(
                        controller: sentToController,
                        decoration: const InputDecoration(labelText: 'Send To'),
                        onChanged: (newValue) {
                          field['sendTo'] = newValue;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Send To';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: bodyController,
                        decoration: const InputDecoration(labelText: 'Body'),
                        onChanged: (newValue) {
                          field['body'] = newValue;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Body';
                          }
                          return null;
                        },
                      ),
                    ] else ...[
                      TextFormField(
                        controller: chartTitleController,
                        decoration: const InputDecoration(labelText: 'Label'),
                        onChanged: (newValue) {
                          field['charttitle'] = newValue;
                        },
                      ),
                    ],

                    TextFormField(
                      controller: descriptionTextController,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      onChanged: (newValue) {
                        field['descriptionText'] = newValue;
                      },
                    ),

                    if (field['type'] == 'select') ...[
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                            labelText: 'Select Dropdown type'),
                        value: dropdownTypeController.text,
                        items: [
                          'Static',
                          'Dynamic',
                          'Static Multiselect',
                          'Dynamic Multiselect',
                          'Autocomplete',
                          'Autocomplete Multiselect',
                        ].map((category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            field['dropdown_type'] = value;
                          });
                        },
                        onSaved: (value) => field['dropdown_type'] = value,
                      ),
                      const SizedBox(height: 16),
                      //  LOOK UPTYPE //
                      DropdownButton<String>(
                        value: lookupType,
                        items: lookUpTypeList.map((category) {
                          return DropdownMenuItem<String>(
                            value: category['id'].toString() ?? 'null',
                            child:
                                Text(category['lb_name'].toString() ?? 'null'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            lookupType = value;
                          });
                        },
                        hint: const Text('Select lookuptype type'),
                      ),

                      const SizedBox(height: 16),

                      ElevatedButton(
                          onPressed: () async {
                            final token = await TokenManager.getToken();

                            wfService
                                .createlookUptype(token!, lookupType,
                                    widget.moduleId, widget.backendId)
                                .then((_) => _fetchListName());

                            print('create Lookuptype');
                          },
                          child: const Text('create Lookuptype')),
                      const SizedBox(
                        height: 6,
                      ),

                      //  CREATE MASTER

                      TextFormField(
                        controller: masterController,
                        decoration:
                            const InputDecoration(labelText: 'Create Master'),
                        onChanged: (value) {
                          setState(() {
                            masterName = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                          onPressed: () async {
                            final token = await TokenManager.getToken();

                            wfService
                                .createmaster(token!, widget.moduleId,
                                    widget.backendId, masterName)
                                .then((_) => _fetchListName());

                            print('create master');
                          },
                          child: const Text('create master')),
                      const SizedBox(
                        height: 6,
                      ),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                            labelText: 'Select List Name'),
                        value: field[
                            'dynamicList'], // Use the selected value from the field
                        items: [
                          ...LbTableList.map<DropdownMenuItem<String>>(
                            (item) {
                              return DropdownMenuItem<String>(
                                value: item.toString(),
                                child: Text(item),
                              );
                            },
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            field['dynamicList'] = value;
                            dynamicList = value;
                            dynamicListController.text = dynamicList;

                            // Clear and reload LbColumnList
                            // LbColumnList.clear();
                            print(
                                'ColumnList after clear is ... $LbColumnList');
                            _fetchListColumn(dynamicList);
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Choose List Name';
                          }
                          return null;
                        },
                      ),

// Dropdown for dd select
                      DropdownButton<String>(
                        value: field[
                            'ddSelect'], // Use the selected value from the field
                        items: [
                          ...LbColumnList.map<DropdownMenuItem<String>>(
                            (item) {
                              return DropdownMenuItem<String>(
                                value: item.toString(),
                                child: Text(item),
                              );
                            },
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            field['ddSelect'] = value;
                          });
                        },
                        hint: const Text('Select Dd Select'),
                      ),

                      const SizedBox(
                        height: 6,
                      ),

// Dropdown for dd display
                      DropdownButton<String>(
                        value: field['ddDisplay'],
                        items: [
                          ...LbColumnList.map<DropdownMenuItem<String>>(
                            (item) {
                              return DropdownMenuItem<String>(
                                value: item.toString(),
                                child: Text(item),
                              );
                            },
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            field['ddDisplay'] = value;
                          });
                        },
                        hint: const Text('Select DD Display'),
                      ),
                    ],

                    TextFormField(
                      controller: placeholderController,
                      decoration:
                          const InputDecoration(labelText: 'Placeholder'),
                      onChanged: (newValue) {
                        field['placeholder'] = newValue;
                      },
                    ),

                    if (field['type'] == 'Button') ...[
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                            labelText: 'Select Actiontype'),
                        value: actiontypeController.text,
                        items: ['insert', 'update'].map((Category) {
                          return DropdownMenuItem<String>(
                            value: Category,
                            child: Text(Category),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            field['actiontype'] = value;
                          });
                        },
                      ),
                      TextFormField(
                        controller: entity1Controller,
                        decoration: const InputDecoration(labelText: 'entity1'),
                        onChanged: (newValue) {
                          setState(() {
                            field['entity1'] = newValue;
                          });
                        },
                      ),
                      TextFormField(
                        controller: entity2Controller,
                        decoration: const InputDecoration(labelText: 'entity2'),
                        onChanged: (newValue) {
                          field['entity2'] = newValue;
                        },
                      ),
                      TextFormField(
                        controller: entity3Controller,
                        decoration: const InputDecoration(labelText: 'entity3'),
                        onChanged: (newValue) {
                          field['entity3'] = newValue;
                        },
                      ),
                      TextFormField(
                        controller: body1Controller,
                        decoration: const InputDecoration(labelText: 'body1'),
                        onChanged: (newValue) {
                          field['body1'] = newValue;
                        },
                      ),
                      TextFormField(
                        controller: body2Controller,
                        decoration: const InputDecoration(labelText: 'body2'),
                        onChanged: (newValue) {
                          field['body2'] = newValue;
                        },
                      ),
                      TextFormField(
                        controller: body3Controller,
                        decoration: const InputDecoration(labelText: 'body3'),
                        onChanged: (newValue) {
                          field['body3'] = newValue;
                        },
                      ),
                      TextFormField(
                        controller: endpoint1Controller,
                        decoration:
                            const InputDecoration(labelText: 'endpoint1'),
                        onChanged: (newValue) {
                          field['endpoint1'] = newValue;
                        },
                      ),
                      TextFormField(
                        controller: endpoint2Controller,
                        decoration:
                            const InputDecoration(labelText: 'endpoint2'),
                        onChanged: (newValue) {
                          field['endpoint2'] = newValue;
                        },
                      ),
                      TextFormField(
                        controller: endpoint3Controller,
                        decoration:
                            const InputDecoration(labelText: 'endpoint3'),
                        onChanged: (newValue) {
                          field['endpoint3'] = newValue;
                        },
                      ),
                    ],
                    TextFormField(
                      controller: subtypeController,
                      decoration: const InputDecoration(labelText: 'Subtype'),
                      onChanged: (newValue) {
                        field['subtype'] = newValue;
                      },
                    ),

                    TextFormField(
                      controller: regexController,
                      decoration: const InputDecoration(labelText: 'Regex'),
                      onChanged: (newValue) {
                        field['regex'] = newValue;
                      },
                    ),
                    TextFormField(
                      controller: divNameController,
                      decoration: const InputDecoration(labelText: 'Div Name'),
                      onChanged: (newValue) {
                        field['div_name'] = newValue;
                      },
                    ),
                    TextFormField(
                      controller: tooltipMsgController,
                      decoration:
                          const InputDecoration(labelText: 'Tooltip Message'),
                      onChanged: (newValue) {
                        field['tooltipmsg'] = newValue;
                      },
                    ),
                    TextFormField(
                      controller: maxCharactersController,
                      decoration:
                          const InputDecoration(labelText: 'Max Characters'),
                      onChanged: (newValue) {
                        field['maxcharacters'] = newValue;
                      },
                    ),
                    TextFormField(
                      controller: visibilityController,
                      decoration:
                          const InputDecoration(labelText: 'Visibility'),
                      onChanged: (newValue) {
                        field['visibility'] = newValue;
                      },
                    ),
                    TextFormField(
                      controller: duplicateValController,
                      decoration:
                          const InputDecoration(labelText: 'Duplicate Value'),
                      onChanged: (newValue) {
                        field['duplicateVal'] = newValue;
                      },
                    ),
                    TextFormField(
                      controller: encryptDataController,
                      decoration:
                          const InputDecoration(labelText: 'Encrypt Data'),
                      onChanged: (newValue) {
                        field['encryptData'] = newValue;
                      },
                    ),
                    TextFormField(
                      controller: gridLineNameController,
                      decoration:
                          const InputDecoration(labelText: 'Grid Line Name'),
                      onChanged: (newValue) {
                        field['gridLine_name'] = newValue;
                      },
                    ),

                    // TextFormField(
                    //   controller: name1Controller,
                    //   decoration: const InputDecoration(labelText: 'Name'),
                    //   onChanged: (newValue) {
                    //     field['name'] = newValue;
                    //   },
                    // ),

                    Row(
                      children: [
                        const Text('Personal Health Info:'),
                        Switch(
                          value: field['personalHealthInfo'],
                          onChanged: (value) {
                            setState(() {
                              field['personalHealthInfo'] = value;
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Handle:'),
                        Switch(
                          value: field['handle'],
                          onChanged: (value) {
                            setState(() {
                              field['handle'] = value;
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Personal Info:'),
                        Switch(
                          value: field['personalInfo'],
                          onChanged: (value) {
                            setState(() {
                              field['personalInfo'] = value;
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Show Description:'),
                        Switch(
                          value: field['showDescription'],
                          onChanged: (value) {
                            setState(() {
                              field['showDescription'] = value;
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Required:'),
                        Switch(
                          value: field['required'],
                          onChanged: (value) {
                            setState(() {
                              field['required'] = value;
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Read Only:'),
                        Switch(
                          value: field['Read Only'],
                          onChanged: (value) {
                            setState(() {
                              field['Read Only'] = value;
                            });
                          },
                        ),
                      ],
                    ),
                    // Add code to edit other properties as needed

                    // Values section
                    const SizedBox(height: 10),
                    const Text('Values:'),
                    for (int i = 0; i < values.length; i++)
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              initialValue: values[i]['label'],
                              decoration: const InputDecoration(
                                labelText: 'Label',
                              ),
                              onChanged: (newValue) {
                                values[i]['label'] = newValue;
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              initialValue: values[i]['value'],
                              decoration: const InputDecoration(
                                labelText: 'Value',
                              ),
                              onChanged: (newValue) {
                                values[i]['value'] = newValue;
                              },
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  values.removeAt(i);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          values.add({'label': '', 'value': ''});
                        });
                      },
                      child: const Text('Add Value'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('Save'),
                  onPressed: () {
                    setState(() {
                      // Update the field properties with edited values
                      field['charttitle'] = chartTitleController.text;
                      field['description'] = descriptionTextController.text;
                      field['placeholder'] = placeholderController.text;
                      // field['className'] = classNameController.text;
                      field['subtype'] = subtypeController.text;
                      field['size'] = sizeController.text;
                      field['regex'] = regexController.text;
                      field['div_name'] = divNameController.text;
                      field['tooltipmsg'] = tooltipMsgController.text;
                      field['maxcharacters'] = maxCharactersController.text;
                      field['visibility'] = visibilityController.text;
                      field['duplicateVal'] = duplicateValController.text;
                      field['encryptData'] = encryptDataController.text;
                      field['gridLine_name'] = gridLineNameController.text;
                      field['name'] = name1Controller.text;
                      field['values'] = values;

                      field['toWireframe'] = selectchildWf;
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
