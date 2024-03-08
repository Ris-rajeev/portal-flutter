import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:authsec_flutter/Entity/test1/Gtest12/Gtest12_api_service.dart';
import 'dart:math';
import 'package:authsec_flutter/providers/token_manager.dart';

import 'package:flutter/services.dart';

class UpdateEntityScreen extends StatefulWidget {
  final Map<String, dynamic> entity;

  UpdateEntityScreen({required this.entity});

  @override
  _UpdateEntityScreenState createState() => _UpdateEntityScreenState();
}

class _UpdateEntityScreenState extends State<UpdateEntityScreen> {
  final ApiService apiService = ApiService();
  final _formKey = GlobalKey<FormState>();

  bool _passwordVisible = false;
  bool _isPasswordValid = true;
  void _validatePassword(String password) {
    setState(() {
      _isPasswordValid = password.isNotEmpty;
    });
  }

  bool _isEmailValid = true;
  void _validateEmail(String email) {
    setState(() {
      _isEmailValid =
          RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(email);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Gtest12')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  initialValue: widget.entity['fname'],
                  decoration: const InputDecoration(labelText: 'fname'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a fname';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    widget.entity['fname'] = value;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: widget.entity['number_field'].toString(),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                  ],
                  decoration: const InputDecoration(
                    labelText: 'number_field',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a number_field';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    widget.entity['number_field'] = value;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: widget.entity['password_field'],
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                    errorText:
                        _isPasswordValid ? null : 'Please enter a password',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password_field';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    widget.entity['password_field'] = value;
                  },
                  onChanged: _validatePassword,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: widget.entity['email_field'],
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'email_field',
                    errorText:
                        _isEmailValid ? null : 'Please enter a valid email',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a email_field';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    widget.entity['email_field'] = value;
                  },
                  onChanged: _validateEmail,
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
                        }
                      }
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
        ),
      ),
    );
  }
}
