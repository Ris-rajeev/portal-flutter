import 'dart:convert';

import 'package:flutter/material.dart';

import '../../providers/token_manager.dart';
import '../../resources/api_constants.dart';
import 'package:http/http.dart' as http;

import '../Login Screen/login_screen.dart';

class ResetPasswordScreen extends StatelessWidget {
  final String userEmail;

  final Map<String, dynamic> userData;

  ResetPasswordScreen({required this.userEmail, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Please Reset Your Password'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              "You're signed in as $userEmail",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ResetPasswordForm(userData: userData, userEmail: userEmail),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false, // Remove all routes from the stack
                );
              },
              child: Text(
                'Wrong account? Log in instead.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResetPasswordForm extends StatefulWidget {
  final String userEmail;

  final Map<String, dynamic> userData;

  ResetPasswordForm({required this.userEmail, required this.userData});

  @override
  _ResetPasswordFormState createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController reEnterNewPasswordController =
      TextEditingController();

  var responseMessage;
  var isVisible = false;
  bool issuccess = false;

  bool isOldPasswordVisible = false;
  bool isNewPasswordVisible = false;
  bool isReEnterNewPasswordVisible = false;

  bool _isPasswordValid1 = true;
  void _validatePassword1(String password) {
    setState(() {
      _isPasswordValid1 = password.isNotEmpty;
    });
  }

  bool _isPasswordValid2 = true;
  void _validatePassword2(String password) {
    setState(() {
      _isPasswordValid2 = password.isNotEmpty;
    });
  }

  bool _isPasswordValid3 = true;
  void _validatePassword3(String password) {
    setState(() {
      _isPasswordValid3 =
          password.isNotEmpty && password == newPasswordController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        isVisible
            ? Text(responseMessage,
                style: TextStyle(
                  color: issuccess
                      ? Colors.green
                      : Colors.red, // Set the text color to red
                ))
            : Text(''),
        TextFormField(
          controller: oldPasswordController,
          obscureText: !isOldPasswordVisible,
          decoration: InputDecoration(
            labelText: 'Enter Old Password',
            suffixIcon: IconButton(
              icon: Icon(
                isOldPasswordVisible ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  isOldPasswordVisible = !isOldPasswordVisible;
                });
              },
            ),
            errorText:
                _isPasswordValid1 ? null : 'Please enter your old password',
          ),
          onChanged: _validatePassword1,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter your old password';
            }
            return null; // Return null to indicate no error
          },
        ),
        TextFormField(
          controller: newPasswordController,
          obscureText: !isNewPasswordVisible,
          decoration: InputDecoration(
            labelText: 'Enter New Password',
            suffixIcon: IconButton(
              icon: Icon(
                isNewPasswordVisible ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  isNewPasswordVisible = !isNewPasswordVisible;
                });
              },
            ),
            errorText:
                _isPasswordValid2 ? null : 'Please enter your new password',
          ),
          onChanged: _validatePassword2,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter your new password';
            }
            return null;
          },
        ),
        TextFormField(
          controller: reEnterNewPasswordController,
          obscureText: !isReEnterNewPasswordVisible,
          decoration: InputDecoration(
            labelText: 'Re-Enter New Password',
            suffixIcon: IconButton(
              icon: Icon(
                isReEnterNewPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  isReEnterNewPasswordVisible = !isReEnterNewPasswordVisible;
                });
              },
            ),
            errorText:
                _isPasswordValid3 ? null : 'Please re-enter your new password',
          ),
          onChanged: _validatePassword3,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please re-enter your new password';
            }
            if (value != newPasswordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            if (oldPasswordController.text.isEmpty ||
                newPasswordController.text.isEmpty ||
                reEnterNewPasswordController.text.isEmpty) {
              print(oldPasswordController.text);
              print(newPasswordController.text);
              print(reEnterNewPasswordController.text);
            } else {
              Map<String, dynamic> passwordData = {
                "userId": widget.userData['userId'],
                "oldPassword": oldPasswordController.text,
                "newPassword": newPasswordController.text,
                "confirmPassword": reEnterNewPasswordController.text,
              };
              final token = await TokenManager.getToken();
              final String baseUrl = ApiConstants.baseUrl;
              final String apiUrl = '$baseUrl/api/reset_password';

              try {
                final response = await http.post(Uri.parse(apiUrl),
                    headers: {
                      'Authorization': 'Bearer $token',
                      'Content-Type': 'application/json',
                    },
                    body: json.encode(passwordData));

                if (response.statusCode <= 209) {
                  setState(() {
                    isVisible = true;
                    issuccess = true;
                    responseMessage = "Password Changes Successfully";
                  });
                  print("success");
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (route) => false,
                  );
                } else {
                  setState(() {
                    isVisible = true;
                    responseMessage = "Incorrect Password";
                  });
                  print(response.statusCode);
                }
              } catch (e) {
                throw Exception('Failed to Update: $e');
              }
            }
          },
          child: Text('Continue'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    reEnterNewPasswordController.dispose();
    super.dispose();
  }
}
