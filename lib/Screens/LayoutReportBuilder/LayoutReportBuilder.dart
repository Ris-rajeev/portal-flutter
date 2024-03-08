import 'package:flutter/material.dart';
import 'dart:convert';

// class ReportEditor extends StatefulWidget {
//   @override
//   _ReportEditorState createState() => _ReportEditorState();
// }
//
// class _ReportEditorState extends State<ReportEditor> {
//   List<Map<String, dynamic>> droppedFields = [];
//   GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
//   TextEditingController keyController = TextEditingController();
//   TextEditingController valueController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: AppBar(title: Text('Report Editor')),
//       body: Row(
//         children: <Widget>[
//           Container(
//             width: 200,
//             padding: EdgeInsets.all(10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Text('Drag and Drop Fields:'),
//                 Draggable<String>(
//                   data: 'Title',
//                   child: DragField(text: 'Title'),
//                   feedback: DragField(text: 'Title'),
//                 ),
//                 Draggable<String>(
//                   data: 'Phone Number',
//                   child: DragField(text: 'Phone Number'),
//                   feedback: DragField(text: 'Phone Number'),
//                 ),
//                 Draggable<String>(
//                   data: 'Date',
//                   child: DragField(text: 'Date'),
//                   feedback: DragField(text: 'Date'),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: SingleChildScrollView(
//               child: Container(
//                 color: Colors.white,
//                 child: Stack(
//                   children: [
//                     Container(
//                       margin: EdgeInsets.all(10),
//                       width: 793, // A4 width
//                       height: 1122, // A4 height
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                           color: Colors.black,
//                           width: 1.0,
//                         ),
//                       ),
//                     ),
//                     Align(
//                       alignment: Alignment.bottomRight,
//                       child: Text('Scale Bar Report Editor'),
//                     ),
//                     ...droppedFields.asMap().entries.map((entry) {
//                       final index = entry.key;
//                       final field = entry.value;
//                       return DraggableField(
//                         key: Key(index.toString()),
//                         field: field,
//                         onDrag: (Offset position) {
//                           setState(() {
//                             droppedFields[index]['left'] = position.dx;
//                             droppedFields[index]['top'] = position.dy;
//                           });
//                         },
//                         onEdit: (String key, String value) {
//                           setState(() {
//                             droppedFields[index]['key'] = key;
//                             droppedFields[index]['value'] = value;
//                           });
//                         },
//
//                       );
//                     }).toList(),
//                     DraggableTarget(
//                       onAccept: (String field) {
//                         final RenderBox renderBox = context.findRenderObject() as RenderBox;
//                         final offset = renderBox.localToGlobal(Offset.zero);
// print(offset.dx);
//                         setState(() {
//                           droppedFields.add({
//                             'type': field,
//                             'left': offset.dx, // Set left coordinate
//                             'top': offset.dy, // Set top coordinate
//                             'key': field,
//                             'value': '',
//                             'isEditing': true, // Set the newly dropped field to be in edit mode
//                           });
//                         });
//                       },
//                     ),
//
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           _submitReport();
//         },
//         child: Icon(Icons.save),
//       ),
//     );
//   }
//
//   void _submitReport() {
//     final reportJson = jsonEncode(droppedFields);
//     print(reportJson);
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Report JSON created and printed!'),
//       ),
//     );
//   }
// }
//
// class DragField extends StatelessWidget {
//   final String text;
//
//   DragField({required this.text});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 120,
//       padding: EdgeInsets.all(8),
//       margin: EdgeInsets.symmetric(vertical: 5),
//       decoration: BoxDecoration(
//         color: Colors.blue,
//         borderRadius: BorderRadius.circular(5),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(color: Colors.white),
//       ),
//     );
//   }
// }
//
// class DraggableField extends StatefulWidget {
//   final Map<String, dynamic> field;
//   final Function(Offset) onDrag;
//   final Function(String, String) onEdit;
//
//   DraggableField({
//     required Key key,
//     required this.field,
//     required this.onDrag,
//     required this.onEdit,
//   }) : super(key: key);
//
//   @override
//   _DraggableFieldState createState() => _DraggableFieldState();
// }
//
// class _DraggableFieldState extends State<DraggableField> {
//   Offset position = Offset(0, 0);
//
//   @override
//   void initState() {
//     super.initState();
//     final left = widget.field['left'] as double;
//     final top = widget.field['top'] as double;
//     position = Offset(left, top);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       left: position.dx,
//       top: position.dy,
//       child: GestureDetector(
//         onLongPress: () {
//           widget.onEdit(widget.field['key'], widget.field['value']);
//           setState(() {
//             // Set the field to be in edit mode when long-pressed
//             widget.field['isEditing'] = true;
//           });
//         },
//         child: Draggable<String>(
//           data: widget.field['type'],
//           child: widget.field['isEditing']
//               ? EditableField(
//             key: widget.key as Key,
//             keyText: widget.field['key'],
//             valueText: widget.field['value'],
//             onEdit: widget.onEdit,
//           )
//               : DragField(text: widget.field['type']),
//           feedback: DragField(text: widget.field['type']),
//           onDragEnd: (details) {
//             setState(() {
//               position = details.offset;
//               widget.onDrag(details.offset);
//             });
//           },
//         ),
//       ),
//     );
//   }
// }
//
// class EditableField extends StatefulWidget {
//   final String keyText;
//   final String valueText;
//   final Function(String, String) onEdit;
//
//   EditableField({
//     required Key key,
//     required this.keyText,
//     required this.valueText,
//     required this.onEdit,
//   }) : super(key: key);
//
//   @override
//   _EditableFieldState createState() => _EditableFieldState();
// }
//
// class _EditableFieldState extends State<EditableField> {
//   TextEditingController keyController = TextEditingController();
//   TextEditingController valueController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     keyController.text = widget.keyText;
//     valueController.text = widget.valueText;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 120,
//       padding: EdgeInsets.all(8),
//       margin: EdgeInsets.symmetric(vertical: 5),
//       decoration: BoxDecoration(
//         color: Colors.blue,
//         borderRadius: BorderRadius.circular(5),
//       ),
//       child: Column(
//         children: [
//           TextFormField(
//             controller: keyController,
//             decoration: InputDecoration(labelText: 'Key'),
//             onChanged: (value) {
//               widget.onEdit(value, valueController.text);
//             },
//           ),
//           TextFormField(
//             controller: valueController,
//             decoration: InputDecoration(labelText: 'Value'),
//             onChanged: (value) {
//               widget.onEdit(keyController.text, value);
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class DraggableTarget extends StatelessWidget {
//   final Function(String) onAccept;
//
//   DraggableTarget({required this.onAccept});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         width: 793,
//         height: 1122,
//         child: DragTarget<String>(
//         builder: (context, candidateData, rejectedData) {
//       return Center(
//         child: Text('Drop Here', style: TextStyle(fontSize: 24)),
//       );
//     },
//     onAccept: (String field) {
//     onAccept(field);
//     },
//     ));
//   }
// }







// import 'package:flutter/material.dart';
//
// class ReportEditor extends StatefulWidget {
//   @override
//   _ReportEditorState createState() => _ReportEditorState();
// }
//
// class _ReportEditorState extends State<ReportEditor> {
//   List<Map<String, dynamic>> droppedFields = [];
//   GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
//   TextEditingController keyController = TextEditingController();
//   TextEditingController valueController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: AppBar(title: Text('Report Editor')),
//       body: Row(
//         children: <Widget>[
//           Container(
//             width: 200,
//             padding: EdgeInsets.all(10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Text('Drag and Drop Fields:'),
//                 Draggable<String>(
//                   data: 'Title',
//                   child: DragField(text: 'Title'),
//                   feedback: DragField(text: 'Title'),
//                 ),
//                 Draggable<String>(
//                   data: 'Phone Number',
//                   child: DragField(text: 'Phone Number'),
//                   feedback: DragField(text: 'Phone Number'),
//                 ),
//                 Draggable<String>(
//                   data: 'Date',
//                   child: DragField(text: 'Date'),
//                   feedback: DragField(text: 'Date'),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: SingleChildScrollView(
//               child: Container(
//                 color: Colors.white,
//                 child: Stack(
//                   children: [
//                     Container(
//                       margin: EdgeInsets.all(10),
//                       width: 793, // A4 width
//                       height: 1122, // A4 height
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                           color: Colors.black,
//                           width: 1.0,
//                         ),
//                       ),
//                     ),
//                     Align(
//                       alignment: Alignment.bottomRight,
//                       child: Text('Scale Bar Report Editor'),
//                     ),
//                     ...droppedFields.asMap().entries.map((entry) {
//                       final index = entry.key;
//                       final field = entry.value;
//                       return DraggableField(
//                         key: Key(index.toString()),
//                         field: field,
//                         onDrag: (Offset position) {
//                           setState(() {
//                             droppedFields[index]['left'] = position.dx;
//                             droppedFields[index]['top'] = position.dy;
//                           });
//                         },
//                         onEdit: (String key, String value) {
//                           setState(() {
//                             droppedFields[index]['key'] = key;
//                             droppedFields[index]['value'] = value;
//                           });
//                         },
//                         onDelete: () {
//                           setState(() {
//                             droppedFields.removeAt(index);
//                           });
//                         },
//                       );
//                     }).toList(),
//                     DraggableTarget(
//                       onAccept: (String field) {
//                         final RenderBox renderBox = context.findRenderObject() as RenderBox;
//                         final offset = renderBox.localToGlobal(Offset.zero);
//                         setState(() {
//                           droppedFields.add({
//                             'type': field,
//                             'left': offset.dx, // Set left coordinate
//                             'top': offset.dy, // Set top coordinate
//                             'key': field,
//                             'value': '',
//                             'isEditing': true, // Set the newly dropped field to be in edit mode
//                           });
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           _submitReport();
//         },
//         child: Icon(Icons.save),
//       ),
//     );
//   }
//
//   void _submitReport() {
//     final reportJson = jsonEncode(droppedFields);
//     print(reportJson);
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Report JSON created and printed!'),
//       ),
//     );
//   }
// }
//
//
// class DragField extends StatelessWidget {
//   final String text;
//
//   DragField({required this.text});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 120,
//       padding: EdgeInsets.all(8),
//       margin: EdgeInsets.symmetric(vertical: 5),
//       decoration: BoxDecoration(
//         color: Colors.blue,
//         borderRadius: BorderRadius.circular(5),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(color: Colors.white),
//       ),
//     );
//   }
// }
//
// class DraggableField extends StatefulWidget {
//   final Map<String, dynamic> field;
//   final Function(Offset) onDrag;
//   final Function(String, String) onEdit;
//   final Function onDelete;
//
//   DraggableField({
//     required Key key,
//     required this.field,
//     required this.onDrag,
//     required this.onEdit,
//     required this.onDelete,
//   }) : super(key: key);
//
//   @override
//   _DraggableFieldState createState() => _DraggableFieldState();
// }
//
// class _DraggableFieldState extends State<DraggableField> {
//   Offset position = Offset(0, 0);
//   bool isEditing = false;
//
//   @override
//   void initState() {
//     super.initState();
//     final left = widget.field['left'] as double;
//     final top = widget.field['top'] as double;
//     position = Offset(left, top);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       left: position.dx,
//       top: position.dy,
//       child: GestureDetector(
//         onLongPress: () {
//           widget.onEdit(widget.field['key'], widget.field['value']);
//           setState(() {
//             isEditing = true;
//           });
//         },
//         child: Draggable<String>(
//           data: widget.field['type'],
//           child: isEditing
//               ? EditableField(
//             key: widget.key as Key,
//             keyText: widget.field['key'],
//             valueText: widget.field['value'],
//             onEdit: widget.onEdit,
//           )
//               : Stack(
//             children: [
//               DragField(text: widget.field['type']),
//               Positioned(
//                 top: -10,
//                 right: -10,
//                 child: IconButton(
//                   icon: Icon(Icons.delete),
//                   onPressed: () {
//                     widget.onDelete();
//                   },
//                 ),
//               ),
//             ],
//           ),
//           feedback: DragField(text: widget.field['type']),
//           onDragEnd: (details) {
//             setState(() {
//               position = details.offset;
//               widget.onDrag(details.offset);
//             });
//           },
//         ),
//       ),
//     );
//   }
// }
//
// class EditableField extends StatefulWidget {
//   final String keyText;
//   final String valueText;
//   final Function(String, String) onEdit;
//
//   EditableField({
//     required Key key,
//     required this.keyText,
//     required this.valueText,
//     required this.onEdit,
//   }) : super(key: key);
//
//   @override
//   _EditableFieldState createState() => _EditableFieldState();
// }
//
// class _EditableFieldState extends State<EditableField> {
//   TextEditingController keyController = TextEditingController();
//   TextEditingController valueController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     keyController.text = widget.keyText;
//     valueController.text = widget.valueText;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 120,
//       padding: EdgeInsets.all(8),
//       margin: EdgeInsets.symmetric(vertical: 5),
//       decoration: BoxDecoration(
//         color: Colors.blue,
//         borderRadius: BorderRadius.circular(5),
//       ),
//       child: Column(
//         children: [
//           TextFormField(
//             controller: keyController,
//             decoration: InputDecoration(labelText: 'Key'),
//             onChanged: (value) {
//               widget.onEdit(value, valueController.text);
//             },
//           ),
//           TextFormField(
//             controller: valueController,
//             decoration: InputDecoration(labelText: 'Value'),
//             onChanged: (value) {
//               widget.onEdit(keyController.text, value);
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class DraggableTarget extends StatelessWidget {
//   final Function(String) onAccept;
//
//   DraggableTarget({required this.onAccept});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 793,
//       height: 1122,
//       child: DragTarget<String>(
//         builder: (context, candidateData, rejectedData) {
//           return Center(
//             child: Text('Drop Here', style: TextStyle(fontSize: 24)),
//           );
//         },
//         onAccept: (String field) {
//           onAccept(field);
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'dart:io';
import 'dart:typed_data';

class ReportEditor extends StatefulWidget {
  @override
  _ReportEditorState createState() => _ReportEditorState();
}

class _ReportEditorState extends State<ReportEditor> {
  List<Map<String, dynamic>> droppedFields = [];
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  TextEditingController keyController = TextEditingController();
  TextEditingController valueController = TextEditingController();

  Future<Uint8List> generatePdf() async {
    final pdf = pdfLib.Document();

    for (final field in droppedFields) {
      final left = field['left'] as double;
      final top = field['top'] as double;
      final type = field['type'];
      final key = field['key'];
      final value = field['value'];

      final widget = pdfLib.Container(
        child: pdfLib.Text('$type: $key - $value'),
        decoration: const pdfLib.BoxDecoration(
          border: pdfLib.Border(),
        ),
        padding: pdfLib.EdgeInsets.all(5),
      );

      pdf.addPage(
        pdfLib.Page(
          build: (context) {
            return pdfLib.Positioned(
              left: left,
              top: top,
              child: widget,
            );
          },
        ),
      );
    }

    return pdf.save();
  }

  Future<void> savePdf() async {
    final pdfBytes = await generatePdf();
    final dir = await getApplicationDocumentsDirectory();
    final pdfFile = File('${dir.path}/report.pdf');
    await pdfFile.writeAsBytes(pdfBytes);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('PDF saved to ${pdfFile.path}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Report Editor')),
      body: Row(
        children: <Widget>[
          Container(
            width: 200,
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Drag and Drop Fields:'),
                Draggable<String>(
                  data: 'Title',
                  child: DragField(text: 'Title'),
                  feedback: DragField(text: 'Title'),
                ),
                Draggable<String>(
                  data: 'Phone Number',
                  child: DragField(text: 'Phone Number'),
                  feedback: DragField(text: 'Phone Number'),
                ),
                Draggable<String>(
                  data: 'Date',
                  child: DragField(text: 'Date'),
                  feedback: DragField(text: 'Date'),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                color: Colors.white,
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.all(10),
                      width: 793, // A4 width
                      height: 1122, // A4 height
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text('Scale Bar Report Editor'),
                    ),
                    ...droppedFields.asMap().entries.map((entry) {
                      final index = entry.key;
                      final field = entry.value;
                      return DraggableField(
                        key: Key(index.toString()),
                        field: field,
                        onDrag: (Offset position) {
                          setState(() {
                            droppedFields[index]['left'] = position.dx;
                            droppedFields[index]['top'] = position.dy;
                          });
                        },
                        onEdit: (String key, String value) {
                          setState(() {
                            droppedFields[index]['key'] = key;
                            droppedFields[index]['value'] = value;
                          });
                        },
                      );
                    }).toList(),
                    DraggableTarget(
                      onAccept: (String field) {
                        final RenderBox renderBox =
                        context.findRenderObject() as RenderBox;
                        final offset = renderBox.localToGlobal(Offset.zero);

                        setState(() {
                          droppedFields.add({
                            'type': field,
                            'left': offset.dx,
                            'top': offset.dy,
                            'key': field,
                            'value': '',
                            'isEditing': true,
                          });
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: savePdf,
        child: Icon(Icons.save),
      ),
    );
  }
}

class DragField extends StatelessWidget {
  final String text;

  DragField({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class DraggableField extends StatefulWidget {
  final Map<String, dynamic> field;
  final Function(Offset) onDrag;
  final Function(String, String) onEdit;

  DraggableField({
    required Key key,
    required this.field,
    required this.onDrag,
    required this.onEdit,
  }) : super(key: key);

  @override
  _DraggableFieldState createState() => _DraggableFieldState();
}

class _DraggableFieldState extends State<DraggableField> {
  Offset position = Offset(0, 0);

  @override
  void initState() {
    super.initState();
    final left = widget.field['left'] as double;
    final top = widget.field['top'] as double;
    position = Offset(left, top);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onLongPress: () {
          widget.onEdit(widget.field['key'], widget.field['value']);
          setState(() {
            widget.field['isEditing'] = true;
          });
        },
        child: Draggable<String>(
          data: widget.field['type'],
          child: widget.field['isEditing']
              ? EditableField(
            key: widget.key as Key,
            keyText: widget.field['key'],
            valueText: widget.field['value'],
            onEdit: widget.onEdit,
          )
              : DragField(text: widget.field['type']),
          feedback: DragField(text: widget.field['type']),
          onDragEnd: (details) {
            setState(() {
              position = details.offset;
              widget.onDrag(details.offset);
            });
          },
        ),
      ),
    );
  }
}

class EditableField extends StatefulWidget {
  final String keyText;
  final String valueText;
  final Function(String, String) onEdit;

  EditableField({
    required Key key,
    required this.keyText,
    required this.valueText,
    required this.onEdit,
  }) : super(key: key);

  @override
  _EditableFieldState createState() => _EditableFieldState();
}

class _EditableFieldState extends State<EditableField> {
  TextEditingController keyController = TextEditingController();
  TextEditingController valueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    keyController.text = widget.keyText;
    valueController.text = widget.valueText;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          TextFormField(
            controller: keyController,
            decoration: InputDecoration(labelText: 'Key'),
            onChanged: (value) {
              widget.onEdit(value, valueController.text);
            },
          ),
          TextFormField(
            controller: valueController,
            decoration: InputDecoration(labelText: 'Value'),
            onChanged: (value) {
              widget.onEdit(keyController.text, value);
            },
          ),
        ],
      ),
    );
  }
}

class DraggableTarget extends StatelessWidget {
  final Function(String) onAccept;

  DraggableTarget({required this.onAccept});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 793,
      height: 1122,
      child: DragTarget<String>(
        builder: (context, candidateData, rejectedData) {
          return Center(
            child: Text('Drop Here', style: TextStyle(fontSize: 24)),
          );
        },
        onAccept: (String field) {
          onAccept(field);
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ReportEditor(),
  ));
}


