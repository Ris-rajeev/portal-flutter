import 'package:flutter/material.dart';

import 'SignUpService.dart';

class CreateUserScreen extends StatefulWidget {
  CreateUserScreen({Key? key}) : super(key: key);

  @override
  _CreateUserScreenState createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  int _currentStep = 0;

  // Create a global key for each step
  final GlobalKey<StepCreateAccountState> createAccountKey =
      GlobalKey<StepCreateAccountState>();

  final GlobalKey<StepGetEmailVerificationState> emailVerificationKey =
      GlobalKey<StepGetEmailVerificationState>();

  final GlobalKey<StepGetRegistrationState> registrationKey =
      GlobalKey<StepGetRegistrationState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up - Step ${_currentStep + 1}'),
      ),
      body: Column(
        children: [
          // Display the current step
          Expanded(
            child: _buildStep(_currentStep),
          ),

          // Navigation buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentStep > 0)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentStep--;
                    });
                  },
                  child: const Text('Previous'),
                ),
              if (_currentStep < 2)
                ElevatedButton(
                  onPressed: () {
                    _proceedToNextStep();
                  },
                  child: const Text('Next'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // Function to build the appropriate step based on the current step index
  Widget _buildStep(int stepIndex) {
    switch (stepIndex) {
      case 0:
        return StepCreateAccount(
          key: createAccountKey,
          onNext: () {
            _proceedToNextStep();
          },
        );
      case 1:
        return StepGetEmailVerification(
          key: emailVerificationKey,
          onNext: () {
            _proceedToNextStep();
          },
        );
      case 2:
        return StepGetRegistration(
          key: registrationKey,
          onNext: () {
            _proceedToNextStep();
          },
        );
      default:
        return Container(); // Return an empty container by default
    }
  }

  // Function to proceed to the next step
  void _proceedToNextStep() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
    }
  }
}

// Define your individual step widgets here

class StepCreateAccount extends StatefulWidget {
  final Function onNext;

  const StepCreateAccount({Key? key, required this.onNext}) : super(key: key);

  @override
  StepCreateAccountState createState() => StepCreateAccountState();
}

class StepCreateAccountState extends State<StepCreateAccount> {
  // Add your state variables for this step here
  String? accountId;
  final Map<String, dynamic> formData = {};
  final _formKey = GlobalKey<FormState>();
  final SignUpApiService userService = SignUpApiService();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          const Text('Step 1: Create Account'),
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
            decoration: const InputDecoration(labelText: 'Email'),
            onSaved: (value) => formData['email'] = value,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter Email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
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

                      accountId = response['account_id'].toString();
                      print('after create account account id is $accountId');
                      // ignore: use_build_context_synchronously
                      // Navigator.pop(
                      //     _context, accountId); // Pop with account_id

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
          if (accountId != null) Text('Selected Account ID: $accountId'),
        ],
      ),
    );
  }
}

class StepGetEmailVerification extends StatefulWidget {
  final Function onNext;

  const StepGetEmailVerification({Key? key, required this.onNext})
      : super(key: key);

  @override
  StepGetEmailVerificationState createState() =>
      StepGetEmailVerificationState();
}

class StepGetEmailVerificationState extends State<StepGetEmailVerification> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text('Step 2: Get Email Verification'),
    );
  }
}

class StepGetRegistration extends StatefulWidget {
  final Function onNext;

  const StepGetRegistration({Key? key, required this.onNext}) : super(key: key);

  @override
  StepGetRegistrationState createState() => StepGetRegistrationState();
}

class StepGetRegistrationState extends State<StepGetRegistration> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text('Step 3: Get Registration'),
    );
  }
}

// Example of a dialog to create an account
class CreateAccountDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Create Account'),
      content: Text('Account created successfully!'),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop('12345'); // Pass the created account ID
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}
