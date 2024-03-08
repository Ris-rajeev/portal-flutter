import 'package:authsec_flutter/screens/sign_up_screen/CreateAccount.dart';
import 'package:authsec_flutter/screens/sign_up_screen/RegistrationDetails.dart';
import 'package:authsec_flutter/screens/sign_up_screen/SignUpService.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

enum RegistrationStep {
  SendOTP,
  VerifyOTP,
  EnterUserInfo,
  SelectAccount,
}

class SignUpUserScreen extends StatefulWidget {
  SignUpUserScreen({Key? key}) : super(key: key);

  @override
  _SignUpUserScreenState createState() => _SignUpUserScreenState();
}

class _SignUpUserScreenState extends State<SignUpUserScreen> {
  final SignUpApiService userService = SignUpApiService();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Map<String, dynamic> formData = {};
  final _formKey = GlobalKey<FormState>();

  var selectedAccount;
  var email;
  var otp;
  var confirmPassword;

  bool _passwordVisible = false;
  bool _isPasswordValid = true;
  void _validatePassword(String password) {
    setState(() {
      _isPasswordValid = password.isNotEmpty;
    });
  }

  RegistrationStep currentStep = RegistrationStep.SendOTP;

  void moveToNextStep() {
    setState(() {
      if (currentStep == RegistrationStep.SendOTP) {
        currentStep = RegistrationStep.VerifyOTP;
      } else if (currentStep == RegistrationStep.VerifyOTP) {
        currentStep = RegistrationStep.EnterUserInfo;
      } else if (currentStep == RegistrationStep.EnterUserInfo) {
        currentStep = RegistrationStep.SelectAccount;
      }
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
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Create User'),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.5, // Use 50% of the screen height
                  child: ListView.builder(
                    itemCount: 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (currentStep == RegistrationStep.SendOTP) {
                        return Column(
                          children: [
                            const SizedBox(height: 16),
                            TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'Email'),
                              keyboardType: TextInputType.emailAddress,
                              onSaved: (value) => email = value,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();

                                    formData['usrGrpId'] = 46;
                                    formData['email'] = email;
                                    try {
                                      print('send email data is $formData');

                                      await userService.sendEmail(formData);

                                      await Future.delayed(
                                          const Duration(seconds: 2));

                                      moveToNextStep();
                                    } catch (e) {
                                      showErrorMessage(
                                          'Failed to send OTP: $e');
                                    }
                                  }
                                },
                                child: const SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: Center(
                                    child: Text(
                                      'Send OTP',
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
                        );
                      } else if (currentStep == RegistrationStep.VerifyOTP) {
                        return Column(
                          children: [
                            const SizedBox(height: 16),
                            TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'Email'),
                              initialValue: email,
                              readOnly: true,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Container(
                                  height: 100,
                                  width: 250,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey),
                                  ),
                                  child: TextFormField(
                                    decoration:
                                        const InputDecoration(labelText: 'OTP'),
                                    onChanged: (value) {
                                      otp = value;
                                    },
                                    onSaved: (value) => otp = value,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter OTP';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    try {
                                      await userService.resendEmail(email);

                                      await Future.delayed(
                                          const Duration(seconds: 5));
                                      showSuccessMessage('OTP RESEND');
                                    } catch (e) {
                                      showErrorMessage(
                                          'Failed to resend OTP: $e');
                                    }
                                  },
                                  child: const SizedBox(
                                    width: 100,
                                    height: 50,
                                    child: Center(
                                      child: Text(
                                        'Resend OTP',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () async {
                                try {
                                  print('email is $email and otp is $otp');
                                  await userService.otpverification(email, otp);

                                  moveToNextStep();
                                  showSuccessMessage(
                                      'Email verified successfully');
                                } catch (e) {
                                  showErrorMessage('Failed to verify OTP: $e');
                                }
                              },
                              child: const SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: Center(
                                  child: Text(
                                    'VERIFY EMAIL',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      } else if (currentStep ==
                          RegistrationStep.EnterUserInfo) {
                        return Column(
                          children: [
                            // Other widgets for user information entry
                            ElevatedButton(
                              onPressed: () async {
                                // Navigate to the RegistrationDetailsScreen when the button is pressed
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        RegistrationDetailsScreen(email: email),
                                  ),
                                );
                              },
                              child: const SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: Center(
                                  child: Text(
                                    'Go to Registration Details',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Container(); // Return an empty container if none of the conditions match
                      }
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
