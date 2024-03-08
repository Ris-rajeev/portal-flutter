// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:authsec_flutter/resources/api_constants.dart';
import 'package:http/http.dart' as http;

import '../screens/Login Screen/login_screen.dart';

class LogoutButton extends StatefulWidget {
  @override
  _LogoutButtonState createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _logoutUser();
      },
      child: const Text('Logout'),
    );
  }

  Future<void> _logoutUser() async {
    try {
      // Perform API logout request here
      // Replace `apiLogoutEndpoint` with the actual logout endpoint URL
      String logouturl = "${ApiConstants.baseUrl}" + "/token/logout";
      var response = await http.post(Uri.parse(logouturl));

      // Handle logout success
      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      } else {
        // Handle logout failure
        // Display an error message or take appropriate action
      }
    } catch (error) {
      // Handle any exceptions or errors that occur during the logout process
    }
  }
}
