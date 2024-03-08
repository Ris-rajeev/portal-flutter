import 'package:flutter/material.dart';
import 'package:authsec_flutter/hadwin_components.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(45),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 30,
                  child: Image.asset('/images/hadwin_system/cldnsure.png'),
                ),
                const SizedBox(
                  height: 30,
                ),
                const SignUpSteps(), // GO TO SIGN UP FORM
                const SizedBox(
                  height: 27,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 16,
                  child: Center(
                    child: InkWell(
                      child: const Text(
                        'Already have an account? Sign in',
                        style:
                            TextStyle(fontSize: 14, color: Color(0xFF929BAB)),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 3,
                )
              ],
            ),
          ),
        ),
        onWillPop: () => Future.value(false));
  }
}
