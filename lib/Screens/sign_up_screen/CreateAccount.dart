import 'package:authsec_flutter/screens/sign_up_screen/SignUpService.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

class CreateAccountScreen extends StatefulWidget {
  CreateAccountScreen({Key? key}) : super(key: key);

  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final SignUpApiService userService = SignUpApiService();

  final Map<String, dynamic> formData = {};
  final _formKey = GlobalKey<FormState>();

  late BuildContext _context; // Store the current context
  late var account_id; // Store the account_id

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
    _context = context; // Store the context

    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Company Name'),
                  onSaved: (value) => formData['companyName'] = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter  Company Name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    errorText:
                        _isEmailValid ? null : 'Please enter a valid email',
                  ),
                  onSaved: (value) => formData['email'] = value,
                  onChanged: _validateEmail,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                  ],
                  decoration: const InputDecoration(labelText: 'Mobile No'),
                  onSaved: (value) => formData['mobile'] = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Mob No';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Workspace'),
                  onSaved: (value) => formData['workspace'] = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Workspace';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Gst Number'),
                  onSaved: (value) => formData['gstNumber'] = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Gst Number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'pancard'),
                  onSaved: (value) => formData['pancard'] = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Pancard';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Working'),
                  onSaved: (value) => formData['working'] = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Working';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5), // Add margin
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        {
                          try {
                            print('form data is $formData');

                            final response =
                                await userService.createAccount(formData);

                            account_id = response['account_id'].toString();
                            print(
                                'after create account account id is $account_id');
                            // ignore: use_build_context_synchronously
                            Navigator.pop(
                                _context, account_id); // Pop with account_id

                            // Navigator.pop(context);
                          } catch (e) {
                            // ignore: use_build_context_synchronously
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Error'),
                                  content: Text('Account Creation Failed: $e'),
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
                      }
                    },
                    child: const SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Center(
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
        ),
      ),
    );
  }
}
