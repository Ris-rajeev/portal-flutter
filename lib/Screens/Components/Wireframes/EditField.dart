
//   import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// Widget _buildDraggableFormField(Map<String, dynamic> field, int index) {
//     final TextEditingController charttitlecontroller = TextEditingController(
//       text: field['charttitle'],
//     );

//     charttitlecontroller.addListener(() {
//       // Update the label in formFields when text is edited
//       formFields[index]['charttitle'] = charttitlecontroller.text;
//     });

//     final fieldType = field['type'];

//     return Card(
//       key: ValueKey<int>(index),
//       elevation: 3,
//       margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//       child: ListTile(
//         title: TextFormField(
//           controller: charttitlecontroller,
//         ),
//         subtitle: Text('$fieldType'),
//         trailing: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             IconButton(
//               icon: const Icon(Icons.edit),
//               onPressed: () {
//                 // Implement an edit action here, e.g., show a dialog or screen
//                 _editField(index);
//               },
//             ),
//             IconButton(
//               icon: const Icon(Icons.delete),
//               onPressed: () {
//                 setState(() {
//                   formFields.removeAt(index);
//                 });
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }