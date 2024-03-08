import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:authsec_flutter/providers/token_manager.dart';
import 'package:flutter/services.dart';

import 'Bookmarks_api_service.dart';


class CreateEntityScreen extends StatefulWidget {
  const CreateEntityScreen({super.key});

  @override
  _CreateEntityScreenState createState() => _CreateEntityScreenState();
}

class _CreateEntityScreenState extends State<CreateEntityScreen> {
  final ApiService apiService = ApiService();
final Map<String, dynamic> formData = {};
  final _formKey = GlobalKey<FormState>();
  var selectedFileupload_Field;
 @override
  void initState() {
    super.initState();
 } 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Bookmarks')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
          children: [
 
  TextFormField(
                  decoration: const InputDecoration(labelText: 'bookmark_firstletter'),
                  onSaved: (value) => formData['bookmark_firstletter'] = value,
                ),
                const SizedBox(height: 16),

  TextFormField(
                  decoration: const InputDecoration(labelText: 'bookmark_link'),
                  onSaved: (value) => formData['bookmark_link'] = value,
                ),
                const SizedBox(height: 16),

  TextFormField(
                  decoration: const InputDecoration(labelText: 'fileupload_field'),
                  onSaved: (value) => formData['fileupload_field'] = value,
                ),
                const SizedBox(height: 16),
  Container(
              margin: const EdgeInsets.symmetric(vertical: 5), // Add margin
              child: ElevatedButton(
                onPressed: () async {
 if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save(); 
 
                        final token = await TokenManager.getToken();
                        try {
                          print("token is : $token");
                          print(formData);

await apiService.createEntity(
   token!, formData, selectedFileupload_Field); 
 
                    Navigator.pop(context);
                  } catch (e) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: Text('Failed to create entity: $e'),
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
                  } }
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  child: const Center(
                    child: Text(
                      'SUBMIT',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),), 
   );
  }
}