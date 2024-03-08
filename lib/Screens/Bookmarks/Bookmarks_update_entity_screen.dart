import 'package:flutter/material.dart';
import 'dart:math';
import 'package:authsec_flutter/providers/token_manager.dart';

import 'package:flutter/services.dart';

import 'Bookmarks_api_service.dart';
class UpdateEntityScreen extends StatefulWidget {
    final Map<String, dynamic> entity;


  UpdateEntityScreen({required this.entity});

  @override
  _UpdateEntityScreenState createState() => _UpdateEntityScreenState();
}

class _UpdateEntityScreenState extends State<UpdateEntityScreen> {
  final ApiService apiService = ApiService();
  final _formKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Bookmarks')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
          children: [
 
 TextFormField(
   initialValue: widget.entity['bookmark_firstletter'],
                  decoration: const InputDecoration(labelText: 'bookmark_firstletter'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a bookmark_firstletter';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    widget.entity['bookmark_firstletter'] = value;
                  },
                ),
                const SizedBox(height: 16),

 TextFormField(
   initialValue: widget.entity['bookmark_link'],
                  decoration: const InputDecoration(labelText: 'bookmark_link'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a bookmark_link';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    widget.entity['bookmark_link'] = value;
                  },
                ),
                const SizedBox(height: 16),

 TextFormField(
   initialValue: widget.entity['fileupload_field'],
                  decoration: const InputDecoration(labelText: 'fileupload_field'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a fileupload_field';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    widget.entity['fileupload_field'] = value;
                  },
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
                          await apiService.updateEntity(
                              token!,
                              widget.entity[
                                  'id'], // Assuming 'id' is the key in your entity map
                              widget.entity);   
                    Navigator.pop(context);
                  } catch (e) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: Text('Failed to update entity: $e'),
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
  }                }
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  child: const Center(
                    child: Text(
                      'UPDATE',
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