import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:authsec_flutter/screens/sign_up_screen/StepGetRegistration.dart';
import 'package:authsec_flutter/screens/sign_up_screen/StepGetEmailVerification.dart';
import 'package:authsec_flutter/screens/sign_up_screen/step_createAccount.dart';
import 'package:authsec_flutter/utilities/hadwin_markdown_viewer.dart';

import 'package:authsec_flutter/utilities/make_api_request.dart';
import 'package:authsec_flutter/utilities/display_error_alert.dart';
import 'package:authsec_flutter/utilities/slide_right_route.dart';

import '../Login Screen/login_screen.dart';

class SignUpSteps extends StatefulWidget {
  const SignUpSteps({Key? key}) : super(key: key);

  @override
  _SignUpStepsState createState() => _SignUpStepsState();
}

class _SignUpStepsState extends State<SignUpSteps> {
  late PageController _signUpStepController;
  final createAccountFormKey = LabeledGlobalKey<FormState>("reateAccountForm");
  final emailVerificationFormKey =
      LabeledGlobalKey<FormState>("emailVerificationForm");
  final signUpFormKey = LabeledGlobalKey<FormState>("signUpForm");
  Map<String, String> accountDetails = {
    'companyName': '',
    'email': '',
    'mobile': '',
    'workspace': '',
    'gstNumber': '',
    'pancard': '',
  };
  Map<String, String> registrationDetails = {
    'first_name': '',
    'last_name': '',
    'mob_no': '',
    'new_password': '',
    'confirm_password': '',
  };
  Map<String, String> accountsDetails() => accountDetails;
  Map<String, String> registraionDetails() => registrationDetails;
  String? email;

  int _currentStep = 0;
  List<bool> stepHasError = [false, false, false];
  List<bool> stepCompletedSuccessfully = [false, false, false];
  late List<Widget> signUpStepContent;
  bool confirmSignUpButton = false;
  @override
  void initState() {
    _signUpStepController = PageController();
    signUpStepContent = [
      StepCreateAccount(
        registrationDetails: accountsDetails,
        // updateSignUpDetails: updateSignUpDetails,
        nameAddressFormKey: createAccountFormKey,
        proceedToNextStep: _proceedToNextStep,
      ),
      StepGetEmailVerification(
        // updateSignUpDetails: updateSignUpDetails,
        emailPasswordFormKey: emailVerificationFormKey,
        // registrationDetails: registraionDetails,
        proceedToNextStep: _proceedToNextStep,
      ),
      StepGetRegistration(
        // updateSignUpDetails: updateSignUpDetails,
        bankAccountFormKey: signUpFormKey,
        registrationDetails: registraionDetails,
        showConfirmSignUpButton: showConfirmSignUpButton,
        finalStepProccessing: _finalStepProccessing,
      )
    ];

    super.initState();
  }

  @override
  void dispose() {
    _signUpStepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [0, 1, 2]
                    .map((e) => Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () => changeStepOnTap(e),
                              child: CircleAvatar(
                                  backgroundColor: stepHasError[e]
                                      ? Colors.red.shade600
                                      : !stepCompletedSuccessfully[e]
                                          ? const Color(0xffF5F7FA)
                                          : Colors.green.shade600,
                                  foregroundColor: !stepCompletedSuccessfully[e]
                                      ? const Color(0xFF0070BA)
                                      : Colors.white,
                                  radius: 18,
                                  child: stepHasError[e]
                                      ? const Icon(
                                          FluentIcons.warning_16_filled,
                                          color: Colors.white,
                                        )
                                      : stepCompletedSuccessfully[e]
                                          ? const Icon(
                                              FluentIcons.checkmark_16_regular)
                                          : _currentStep == e
                                              ? const Icon(
                                                  FluentIcons.edit_16_filled)
                                              : Text("${e + 1}")),
                            ),
                            if (e < 2)
                              Container(
                                height: 10,
                                width: 70,
                                color: stepCompletedSuccessfully[e]
                                    ? Colors.green.shade600
                                    : Colors.transparent,
                              ),
                          ],
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              width: double.infinity,
              height: _currentStep == 2 ? 230 : 300,
              child: PageView(
                clipBehavior: Clip.none,
                controller: _signUpStepController,
                physics: const NeverScrollableScrollPhysics(),
                children: signUpStepContent,
              ),
            ),
            if (_currentStep == 2)
              Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 3.6, horizontal: 10),
                  child: RichText(
                      text: TextSpan(
                          text: 'By signing up you are agreeing to the ',
                          style: const TextStyle(
                              fontSize: 14, color: Color(0xFF929BAB)),
                          children: <InlineSpan>[
                        TextSpan(
                            text: 'Terms & Conditions',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                Future.delayed(
                                    const Duration(milliseconds: 300),
                                    () => Navigator.push(
                                        context,
                                        SlideRightRoute(
                                            page: const HadWinMarkdownViewer(
                                          screenName: "Terms & Conditons",
                                          urlRequested:
                                              'https://raw.githubusercontent.com/brownboycodes/HADWIN/master/docs/TERMS_AND_CONDITIONS.md',
                                        ))));
                              }),
                        const TextSpan(
                          text: ' and our ',
                          style:
                              TextStyle(fontSize: 14, color: Color(0xFF929BAB)),
                        ),
                        TextSpan(
                            text: 'End User License Agreement',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                Future.delayed(
                                    const Duration(milliseconds: 300),
                                    () => Navigator.push(
                                        context,
                                        SlideRightRoute(
                                            page: const HadWinMarkdownViewer(
                                          screenName:
                                              "End User License Agreement",
                                          urlRequested:
                                              'https://raw.githubusercontent.com/brownboycodes/HADWIN/master/docs/END_USER_LICENSE_AGREEMENT.md',
                                        ))));
                              })
                      ]))),
            confirmSignUpButton
                ? Container(
                    margin: const EdgeInsets.symmetric(vertical: 16.0),
                    width: double.infinity,
                    height: 64,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.blueGrey.shade100,
                            offset: const Offset(0, 4),
                            blurRadius: 5.0)
                      ],
                      gradient: const RadialGradient(
                          colors: [Color(0xff0070BA), Color(0xff1546A0)],
                          radius: 8.4,
                          center: Alignment(-0.24, -0.36)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ElevatedButton(
                        onPressed: _finalStepProccessing,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        child: const Text(
                          'Create Your Account',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        )),
                  )
                : Row(
                    children: [
                      if (_currentStep > 0 && confirmSignUpButton == false)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextButton(
                              onPressed: _goBackToPreviousStep,
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.transparent, shadowColor: Colors.transparent,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                              child: const Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 3.2,
                                  children: [
                                    Icon(
                                      FluentIcons.arrow_left_16_filled,
                                      color: Colors.blue,
                                      size: 18,
                                    ),
                                    Text(
                                      'Back',
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 16),
                                    ),
                                  ])),
                        ),
                      const Spacer(),
                      if (_currentStep < signUpStepContent.length - 1)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextButton(
                              onPressed: _proceedToNextStep,
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.transparent, shadowColor: Colors.transparent,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                              child: const Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 3.2,
                                  children: [
                                    Text(
                                      'Next',
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 16),
                                    ),
                                    Icon(
                                      FluentIcons.arrow_right_16_filled,
                                      color: Colors.blue,
                                      size: 18,
                                    )
                                  ])),
                        ),
                    ],
                  ),
          ],
        ));
  }

  void _finalStepProccessing() {
    FocusManager.instance.primaryFocus?.unfocus();
    _performErrorCheck(_currentStep + 1);

    if (stepHasError[_currentStep] == false && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
            const SnackBar(
              content: Text('Processing'),
              backgroundColor: Colors.blue,
              // onVisible: _tryRegistering,
            ),
          )
          .closed
          .then((value) => _tryRegistering());
    }
  }

//? FUNCTION TO GO BACK TO PREVIOUS STEP OF THE CURRENT STEP
  void _goBackToPreviousStep() {
    FocusManager.instance.primaryFocus?.unfocus();
    _performErrorCheck(_currentStep - 1);
    if (_currentStep > 0) {
      _signUpStepController.animateToPage(_currentStep - 1,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutCubic);
      setState(() {
        _currentStep--;
      });
    }
  }

//? FUNCTION TO MOVE TO THE NEXT STEP FROM THE CURRENT STEP
  void _proceedToNextStep() {
    FocusManager.instance.primaryFocus?.unfocus();
    _performErrorCheck(_currentStep + 1);

    print(stepHasError[_currentStep]);
    print(_currentStep);

    if (stepHasError[_currentStep] == false) {
      if (_currentStep < signUpStepContent.length - 1) {
        _signUpStepController.animateToPage(_currentStep + 1,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOutCubic);

        setState(() {
          _currentStep++;
        });
      }
    }
  }

//? FUNCTION TO UPDATE SIGN UP DETAILS
  // void updateSignUpDetails(String key, String value) {
  //   setState(() {
  //     signUpDetails[key] = value;
  //   });
  // }

//? FUNCTION TO TOGGLE VISIBILITY OF SIGN UP BUTTON
  void showConfirmSignUpButton(bool value) {
    if (value != confirmSignUpButton) {
      setState(() {
        confirmSignUpButton = value;
      });
    }
  }

//? FUNCTION TO CHECK FOR ERRORS IN ANY STEPS PRIOR FROM THE ONE REQUESTED
  void _performErrorCheck(int requestedIndex) {
    if (_currentStep < requestedIndex) {
      for (var i = 0; i < requestedIndex; i++) {
        bool errorStatus = false;
        switch (i) {
          case 0:
            createAccountFormKey.currentState?.validate();
            if (accountDetails["companyName"]!.isEmpty ||
                accountDetails['email']!.isEmpty ||
                accountDetails['mobile']!.isEmpty ||
                accountDetails['workspace']!.isEmpty ||
                accountDetails['gstNumber']!.isEmpty ||
                accountDetails['pancard']!.isEmpty ||
                accountDetails['working']!.isEmpty) {
              errorStatus = true;
            }

            break;
          case 1:
            emailVerificationFormKey.currentState?.validate();
            if (stepCompletedSuccessfully[1]) {
              errorStatus = false;
            } else if (stepCompletedSuccessfully[0] && _currentStep == 1) {
              // emailPasswordFormKey.currentState?.validate();
              if (email!.isEmpty) {
                errorStatus = true;
              }
            } else {
              errorStatus = true;
            }
            break;
          case 2:
            signUpFormKey.currentState?.validate();
            if (email!.isEmpty) {
              errorStatus = true;
            }

            break;
        }

        setState(() {
          stepHasError[i] = errorStatus;
          stepCompletedSuccessfully[i] = !stepHasError[i];
        });
        if (errorStatus) {
          break;
        }
      }
    } else {
      for (var i = _currentStep; i >= 0; i--) {
        bool errorStatus = false;
        switch (i) {
          case 0:
            createAccountFormKey.currentState?.validate();
            if (accountDetails["companyName"]!.isEmpty ||
                accountDetails['email']!.isEmpty ||
                accountDetails['mobile']!.isEmpty ||
                accountDetails['workspace']!.isEmpty ||
                accountDetails['gstNumber']!.isEmpty ||
                accountDetails['pancard']!.isEmpty ||
                accountDetails['working']!.isEmpty) {
              errorStatus = true;
            }

            break;
          case 1:
            emailVerificationFormKey.currentState?.validate();
            if (stepCompletedSuccessfully[1]) {
              errorStatus = false;
            } else if (stepCompletedSuccessfully[0] && _currentStep == 1) {
              // emailPasswordFormKey.currentState?.validate();
              if (email!.isEmpty) {
                errorStatus = true;
              }
            } else {
              errorStatus = true;
            }
            break;
          case 2:
            signUpFormKey.currentState?.validate();
            if (registrationDetails["first_name"]!.isEmpty ||
                registrationDetails["last_name"]!.isEmpty ||
                registrationDetails["mob_no"]!.isEmpty ||
                registrationDetails["new_password"]!.isEmpty ||
                registrationDetails["confirm_password"]!.isEmpty) {
              errorStatus = true;
            }

            break;
        }

        setState(() {
          stepHasError[i] = errorStatus;
          stepCompletedSuccessfully[i] = !stepHasError[i];
        });
        if (errorStatus) {
          break;
        }
      }
    }
  }

  void _tryRegistering() {
    sendData(urlPath: '/token/addOneAppUser', data: registrationDetails)
        .then((response) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (response.keys.join().toLowerCase().contains("error")) {
        showErrorAlert(context, response);
      } else {
        print('Account succesfully created');

        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(
                content: Text("Account Created Successfully"),
                backgroundColor: Colors.green))
            .closed
            .then((value) => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false));
        // Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(
        //         builder: (context) => ChooseUsername(
        //               userAuthKey: response['authorization_token'],
        //               userData: response['user'],
        //             )),
        //     (route) => false);
      }
    });
  }

//? FUNCTION TO CHANGE STEP ON TAPPING THE OVERHEAD STEP NUMBERS
  void changeStepOnTap(int requestedIndex) {
    FocusManager.instance.primaryFocus?.unfocus();

    if (requestedIndex < _currentStep) {
      _signUpStepController.animateToPage(requestedIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutCubic);

      _performErrorCheck(requestedIndex);
      setState(() {
        _currentStep = requestedIndex;
      });
    } else if (requestedIndex > _currentStep &&
        requestedIndex != _currentStep) {
      _performErrorCheck(requestedIndex);

      if (!stepHasError.sublist(0, requestedIndex).contains(true)) {
        if (_currentStep < signUpStepContent.length - 1) {
          _signUpStepController.animateToPage(requestedIndex,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOutCubic);

          setState(() {
            _currentStep = requestedIndex;
          });
        }
      } else {
        int stepWithError =
            stepHasError.sublist(0, requestedIndex).indexOf(true);
        _signUpStepController.animateToPage(stepWithError,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOutCubic);

        setState(() {
          _currentStep = stepWithError;
        });
      }
    }
  }
}
