import 'package:authsec_flutter/screens/sign_up_screen/CreateAccount.dart';
import 'package:authsec_flutter/screens/sign_up_screen/SignUpService.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import '../../providers/token_manager.dart';
import '../Login Screen/login_screen.dart';

class RegistrationDetailsScreen extends StatefulWidget {
  var email;
  RegistrationDetailsScreen({required this.email});

  @override
  _RegistrationDetailsScreenState createState() =>
      _RegistrationDetailsScreenState();
}

class _RegistrationDetailsScreenState extends State<RegistrationDetailsScreen> {
  final SignUpApiService userService = SignUpApiService();

  final Map<String, dynamic> formData = {};
  final _formKey = GlobalKey<FormState>();

  late BuildContext _context; // Store the current context
  var account_id = null; // Initialize with null
  var selectedAccount; // Use nullable type

  var newPassword = ''; // Store the value of the confirm password field
  var confirmPassword = ''; // Store the value of the confirm password field
// Validate that the passwords match
  String? _validatePasswordMatch(String value) {
    if (value != newPassword) {
      print('value is $value and new is $newPassword');
      return 'Passwords do not match';
    }
    return null;
  }

  bool _newpasswordVisible = false;
  bool _confirmpasswordVisible = false;

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

  void showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  void showErrorMessage(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _context = context; // Store the context

    return Scaffold(
      appBar: AppBar(title: const Text('Registration')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Container(
              height: 500,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'First Name'),
                    onSaved: (value) => formData['first_name'] = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter  First Name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Last Name'),
                    onSaved: (value) => formData['last_name'] = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Last Name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Mobile Number'),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                    ],
                    onSaved: (value) => formData['mob_no'] = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Mobile Number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    obscureText: !_newpasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _newpasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _newpasswordVisible = !_newpasswordVisible;
                          });
                        },
                      ),
                      errorText:
                          _isPasswordValid ? null : 'Please enter a password',
                    ),
                    onSaved: (value) => formData['new_password'] = value,
                    onChanged: (value) {
                      setState(() {
                        newPassword = value; // Update newPassword
                      });
                      _validatePassword;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    obscureText: !_confirmpasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      errorText: _validatePasswordMatch(confirmPassword),
                    ),
                    onSaved: (value) => formData['confirm_password'] = value,
                    onChanged: (value) {
                      setState(() {
                        confirmPassword = value; // Update confirmPassword
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Password';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // ADD COMPANY DETAIL

                  Row(
                    children: [
                      const Expanded(
                        child: Text('Add Account'),
                      ),
                      IconButton(
                        onPressed: () async {
                          final accountId = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateAccountScreen(),
                            ),
                          );

                          if (accountId != null) {
                            setState(() {
                              selectedAccount = accountId;
                              formData['account_id'] = accountId;
                              account_id =
                                  accountId; // Update the account_id here
                            });
                          }
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),

                  if (account_id != null)
                    Container(
                      margin:
                          const EdgeInsets.symmetric(vertical: 5), // Add margin
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();

                            print('formdata is $formData');

                            formData['usrGrpId'] = 46;
                            formData['account_id'] = account_id;
                            formData['email'] = widget.email;

                            {
                              final token = await TokenManager.getToken();
                              try {
                                print(formData);

                                await userService
                                    .createuser(token!, formData)
                                    .then((_) => {
                                          const LoginScreen(),
                                        });

                                await Future.delayed(
                                    const Duration(seconds: 5));

                                showSuccessMessage('User created successfully');
                                // ignore: use_build_context_synchronously
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen()));
                                // moveToNextStep();
                              } catch (e) {
                                showErrorMessage('Failed to create User: $e');
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
      ),
    );
  }
}
