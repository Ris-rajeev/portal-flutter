import 'package:authsec_flutter/screens/forgot_password/forgotPasswordScreen.dart';
import 'package:authsec_flutter/screens/sign_up_screen/CreateUser.dart';
import 'package:authsec_flutter/screens/sign_up_screen/SignUpUser.dart';
import 'package:flutter/material.dart';
import 'package:authsec_flutter/hadwin_components.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    Widget helpInfoContainer = SizedBox(
      width: double.infinity,
      height: 36,
      child: Center(
        child: InkWell(
          onTap: getLoginHelp,
          child: const Text(
            'Forgot your password?',
            style: TextStyle(fontSize: 14, color: Color(0xFF929BAB)),
          ), // FOR LOGIN HELP
        ),
      ),
    );

    Widget signUpContainer = SizedBox(
      width: double.infinity,
      height: 36,
      child: Center(
        child: InkWell(
          onTap: goToSignUpScreen,
          child: const Text(
            'Sign up',
            style: TextStyle(fontSize: 14, color: Color(0xFF929BAB)),
          ), // FOR SIGN UP
        ),
      ),
    );

    List<Widget> loginScreenContents = <Widget>[
      _spacing(64),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Image.asset('/images/hadwin_system/cldnsure.png'),
      ),
      _spacing(64),
      const LoginFormComponent(), // ON LOGIN SCREEN
      _spacing(30),
      helpInfoContainer,
      _spacing(10),
      signUpContainer
    ];

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(45),
        child: Column(
          children: loginScreenContents,
        ),
      ),
    );
  }

  void getLoginHelp() {
    //ForgotPasswordPage
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ForgotPasswordPage()));
    // Navigator.push(
    //     context,
    //     SlideRightRoute(
    //         page: const HadWinMarkdownViewer(
    //             screenName: 'Login Help',
    //             urlRequested:
    //                 'https://raw.githubusercontent.com/brownboycodes/HADWIN/master/docs/HADWIN_WIKI.md')));
  }

  void goToSignUpScreen() {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => SignUpUserScreen()))
        .then((value) => const LoginScreen());
  }

  SizedBox _spacing(double height) => SizedBox(
        height: height,
      );
}
