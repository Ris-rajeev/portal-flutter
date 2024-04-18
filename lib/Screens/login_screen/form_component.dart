import 'package:authsec_flutter/providers/token_manager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:authsec_flutter/screens/main_app_screen/tabbed_layout_component.dart';
import 'package:authsec_flutter/utilities/make_api_request.dart';

class LoginFormComponent extends StatefulWidget {
  const LoginFormComponent({Key? key}) : super(key: key);

  @override
  LoginFormComponentState createState() {
    return LoginFormComponentState();
  }
}

class LoginFormComponentState extends State<LoginFormComponent> {
  final _formKey = GlobalKey<FormState>();
  String errorMessage1 = "";
  String errorMessage2 = "";
  String userInput = "";
  String password = "";
  bool isPasswordVisible = false;
  bool stayLoggedIn = false;

  void errorMessageSetter(int fieldNumber, String message) {
    setState(() {
      if (fieldNumber == 1) {
        errorMessage1 = message;
      } else {
        errorMessage2 = message;
      }
    });
  }

  void tryLoggingIn() async {
    final dataReceived = await sendData(
      urlPath: "/token/session",
      data: {"email": userInput, "password": password},
    );

    if (dataReceived.containsValue('ERROR')) {
      var error = dataReceived['operationMessage'].toString();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(
            content: Text(error),
            backgroundColor: Colors.redAccent,
          ))
          .closed;
    } else {
      var token = dataReceived['item']['token'];
      var user = dataReceived['item'];
      await TokenManager.setToken(token);

      if (stayLoggedIn) {
        await _saveLoggedInUserData(token, user);
      }
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(
            content: Text("Login Successful"),
            backgroundColor: Colors.green,
          ))
          .closed
          .then(
            (value) => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => TabbedLayoutComponent(
                  userData: dataReceived['item'],
                ),
              ),
              (route) => false,
            ),
          );

      print('after login');
    }
  }

  Future<bool> _saveLoggedInUserData(
      String loggedInUserAuthKey, Map<String, dynamic> user) async {
    try {
      var userId = user['userId'].toString();
      var firstName = user['firstName'].toString();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userData', user.toString());
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('token', loggedInUserAuthKey);

      print('userId ....$userId');
      print('firstName ....$firstName');

      if (mounted) {
        debugPrint("user data saved");
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 1.0, color: const Color(0xFFF5F7FA)),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                const BoxShadow(
                  blurRadius: 6.18,
                  spreadRadius: 0.618,
                  offset: Offset(-4, -4),
                  color: Color(0xFFF5F7FA),
                ),
                BoxShadow(
                  blurRadius: 6.18,
                  spreadRadius: 0.618,
                  offset: const Offset(4, 4),
                  color: Colors.blueGrey.shade100,
                ),
              ],
            ),
            child: TextFormField(
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  errorMessageSetter(
                      1, 'You must provide an email or username');
                } else {
                  errorMessageSetter(1, "");

                  setState(() {
                    userInput = value;
                  });
                }

                return null;
              },
              autocorrect: false,
              decoration: const InputDecoration(
                fillColor: Colors.white,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding:
                    EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                hintText: "Username or email address",
                hintStyle: TextStyle(fontSize: 16, color: Color(0xFF929BAB)),
              ),
              style: const TextStyle(fontSize: 16, color: Color(0xFF929BAB)),
            ),
          ),
          if (errorMessage1 != '')
            Container(
              margin: const EdgeInsets.all(2),
              padding: const EdgeInsets.all(2),
              child: Text(
                "\t\t\t\t$errorMessage1",
                style: const TextStyle(fontSize: 10, color: Colors.red),
              ),
            ),
          Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(width: 1.0, color: const Color(0xFFF5F7FA)),
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [
                const BoxShadow(
                  spreadRadius: 0.618,
                  blurRadius: 6.18,
                  offset: Offset(-4, -4),
                  color: Color(0xFFF5F7FA),
                ),
                BoxShadow(
                  blurRadius: 6.18,
                  spreadRadius: 0.618,
                  offset: const Offset(4, 4),
                  color: Colors.blueGrey.shade100,
                ),
              ],
            ),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (value) => _validateLoginDetails(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  errorMessageSetter(2, 'Password cannot be empty');
                } else {
                  errorMessageSetter(2, "");
                  setState(() {
                    password = value;
                  });
                }
                return null;
              },
              obscureText: !isPasswordVisible,
              enableSuggestions: false,
              autocorrect: false,
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: const EdgeInsets.only(
                    left: 15, bottom: 11, top: 11, right: 15),
                hintText: "Password",
                hintStyle:
                    const TextStyle(fontSize: 16, color: Color(0xFF929BAB)),
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
          ),
          if (errorMessage2 != '')
            Container(
              margin: const EdgeInsets.all(2),
              padding: const EdgeInsets.all(2),
              child: Text(
                "\t\t\t\t$errorMessage2",
                style: const TextStyle(fontSize: 10, color: Colors.red),
              ),
            ),
          CheckboxListTile(
            title: const Text('Stay Logged In'),
            value: stayLoggedIn,
            onChanged: (value) {
              setState(() {
                stayLoggedIn = value!;
              });
            },
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16.0),
            width: double.infinity,
            height: 64,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey.shade100,
                  offset: const Offset(0, 4),
                  blurRadius: 5.0,
                ),
              ],
              gradient: const RadialGradient(
                colors: [Color(0xff0070BA), Color(0xff1546A0)],
                radius: 8.4,
                center: Alignment(-0.24, -0.36),
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ElevatedButton(
              onPressed: _validateLoginDetails,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Log in',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _validateLoginDetails() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_formKey.currentState!.validate()) {
      if (errorMessage1 != "" || errorMessage2 != "") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please provide all required details'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            onVisible: tryLoggingIn,
            content: const Text('Processing...'),
            backgroundColor: Colors.blue,
          ),
        );
      }
    }
  }
}
