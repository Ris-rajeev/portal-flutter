import 'package:authsec_flutter/screens/Login%20Screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../providers/token_manager.dart';
import '../../resources/api_constants.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  String message = '';

  Future<void> sendForgotPasswordRequest() async {
    final email = emailController.text;
    final token = await TokenManager.getToken();
    const String baseUrl = ApiConstants.baseUrl;

    final response = await http.post(
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      Uri.parse('$baseUrl/api/resources/forgotpassword?email=$email'),
    );

    if (response.statusCode == 200) {
      setState(() {
        message = 'An email with a reset link has been sent to $email.';
      });
    } else {
      setState(() {
        message = 'Failed to send the reset link. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                sendForgotPasswordRequest();
              },
              child: Text('Send me an access link'),
            ),
            SizedBox(height: 20),
            Text(message),
            if (message.contains('An email with a reset link'))
              InkWell(
                child: Text(
                  'Click here to return to login',
                  style: TextStyle(color: Colors.blue),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
              ),
          ],
        ),
      ),
    );
  }
}
