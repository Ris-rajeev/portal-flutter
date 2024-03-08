import 'package:flutter/material.dart';

class StepGetRegistration extends StatefulWidget {
  final LabeledGlobalKey<FormState> bankAccountFormKey;
  // final Function updateSignUpDetails;
  final Function showConfirmSignUpButton;
  final Function registrationDetails;
  final Function finalStepProccessing;
  const StepGetRegistration(
      {Key? key,
      // required this.updateSignUpDetails,
      required this.registrationDetails,
      required this.bankAccountFormKey,
      required this.showConfirmSignUpButton,
      required this.finalStepProccessing})
      : super(key: key);

  @override
  _StepGetRegistrationState createState() => _StepGetRegistrationState();
}

class _StepGetRegistrationState extends State<StepGetRegistration> {
  String firstname = "";
  String firstnameErrorMessage = "";

  String lastName = "";
  String lastNameErrorMessage = "";

  String mobNo = "";
  String mobNoErrorMessage = "";

  String password = "";
  String passwordErrorMessage = "";

  String confirmPassword = "";
  String confirmPasswordErrorMessage = "";
  @override
  void initState() {
    super.initState();
    Map<String, String> signUpDetails = widget.registrationDetails();
    if (mounted) {
      setState(() {
        firstname = signUpDetails['first_name']!;
        lastName = signUpDetails['last_name']!;
        mobNo = signUpDetails['mob_no']!;
        password = signUpDetails['new_password']!;
        confirmPassword = signUpDetails['confirm_password']!;
      });
    }
  }

  @override
  void dispose() {
    // widget.bankAccountFormKey.currentState?.validate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: widget.bankAccountFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border:
                      Border.all(width: 1.0, color: const Color(0xFFF5F7FA)),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    const BoxShadow(
                        blurRadius: 6.18,
                        spreadRadius: 0.618,
                        offset: Offset(-4, -4),
                        color: Colors.white38),
                    BoxShadow(
                        blurRadius: 6.18,
                        spreadRadius: 0.618,
                        offset: const Offset(4, 4),
                        color: Colors.blueGrey.shade100)
                  ]),
              child: TextFormField(
                initialValue: firstname,
                onChanged: _toggleSignUpButtonVisibility,
                // validator: _validateEmailId,
                autofocus: mounted,
                autocorrect: false,
                onFieldSubmitted: (value) {
                  if (value.isNotEmpty) {
                    widget.finalStepProccessing();
                  }
                },
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding:
                      EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                  hintText: "first name",
                  hintStyle: TextStyle(fontSize: 16, color: Color(0xFF929BAB)),
                ),
                style: const TextStyle(fontSize: 16, color: Color(0xFF929BAB)),
              ),
            ),
            if (firstnameErrorMessage != '')
              Container(
                margin: const EdgeInsets.all(2),
                padding: const EdgeInsets.all(2),
                child: Text(
                  "\t\t\t\t$firstnameErrorMessage",
                  style: const TextStyle(fontSize: 10, color: Colors.red),
                ),
              ),

            // first name code end here

            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border:
                      Border.all(width: 1.0, color: const Color(0xFFF5F7FA)),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    const BoxShadow(
                        blurRadius: 6.18,
                        spreadRadius: 0.618,
                        offset: Offset(-4, -4),
                        color: Colors.white38),
                    BoxShadow(
                        blurRadius: 6.18,
                        spreadRadius: 0.618,
                        offset: const Offset(4, 4),
                        color: Colors.blueGrey.shade100)
                  ]),
              child: TextFormField(
                initialValue: lastName,
                onChanged: _toggleSignUpButtonVisibility,
                // validator: _validateEmailId,
                autofocus: mounted,
                autocorrect: false,
                onFieldSubmitted: (value) {
                  if (value.isNotEmpty) {
                    widget.finalStepProccessing();
                  }
                },
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding:
                      EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                  hintText: "last name",
                  hintStyle: TextStyle(fontSize: 16, color: Color(0xFF929BAB)),
                ),
                style: const TextStyle(fontSize: 16, color: Color(0xFF929BAB)),
              ),
            ),
            if (lastNameErrorMessage != '')
              Container(
                margin: const EdgeInsets.all(2),
                padding: const EdgeInsets.all(2),
                child: Text(
                  "\t\t\t\t$lastNameErrorMessage",
                  style: const TextStyle(fontSize: 10, color: Colors.red),
                ),
              ),

            // last name code

            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border:
                      Border.all(width: 1.0, color: const Color(0xFFF5F7FA)),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    const BoxShadow(
                        blurRadius: 6.18,
                        spreadRadius: 0.618,
                        offset: Offset(-4, -4),
                        color: Colors.white38),
                    BoxShadow(
                        blurRadius: 6.18,
                        spreadRadius: 0.618,
                        offset: const Offset(4, 4),
                        color: Colors.blueGrey.shade100)
                  ]),
              child: TextFormField(
                initialValue: mobNo,
                onChanged: _toggleSignUpButtonVisibility,
                // validator: _validateEmailId,
                autofocus: mounted,
                autocorrect: false,
                onFieldSubmitted: (value) {
                  if (value.isNotEmpty) {
                    widget.finalStepProccessing();
                  }
                },
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding:
                      EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                  hintText: "mob no",
                  hintStyle: TextStyle(fontSize: 16, color: Color(0xFF929BAB)),
                ),
                style: const TextStyle(fontSize: 16, color: Color(0xFF929BAB)),
              ),
            ),
            if (mobNoErrorMessage != '')
              Container(
                margin: const EdgeInsets.all(2),
                padding: const EdgeInsets.all(2),
                child: Text(
                  "\t\t\t\t$mobNoErrorMessage",
                  style: const TextStyle(fontSize: 10, color: Colors.red),
                ),
              ),

            // mob no code end
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border:
                      Border.all(width: 1.0, color: const Color(0xFFF5F7FA)),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    const BoxShadow(
                        blurRadius: 6.18,
                        spreadRadius: 0.618,
                        offset: Offset(-4, -4),
                        color: Colors.white38),
                    BoxShadow(
                        blurRadius: 6.18,
                        spreadRadius: 0.618,
                        offset: const Offset(4, 4),
                        color: Colors.blueGrey.shade100)
                  ]),
              child: TextFormField(
                initialValue: password,
                onChanged: _toggleSignUpButtonVisibility,
                // validator: _validateEmailId,
                autofocus: mounted,
                autocorrect: false,
                onFieldSubmitted: (value) {
                  if (value.isNotEmpty) {
                    widget.finalStepProccessing();
                  }
                },
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding:
                      EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                  hintText: "password",
                  hintStyle: TextStyle(fontSize: 16, color: Color(0xFF929BAB)),
                ),
                style: const TextStyle(fontSize: 16, color: Color(0xFF929BAB)),
              ),
            ),
            if (passwordErrorMessage != '')
              Container(
                margin: const EdgeInsets.all(2),
                padding: const EdgeInsets.all(2),
                child: Text(
                  "\t\t\t\t$passwordErrorMessage",
                  style: const TextStyle(fontSize: 10, color: Colors.red),
                ),
              ),

            // new password code end

            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border:
                      Border.all(width: 1.0, color: const Color(0xFFF5F7FA)),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    const BoxShadow(
                        blurRadius: 6.18,
                        spreadRadius: 0.618,
                        offset: Offset(-4, -4),
                        color: Colors.white38),
                    BoxShadow(
                        blurRadius: 6.18,
                        spreadRadius: 0.618,
                        offset: const Offset(4, 4),
                        color: Colors.blueGrey.shade100)
                  ]),
              child: TextFormField(
                initialValue: confirmPassword,
                onChanged: _toggleSignUpButtonVisibility,
                // validator: _validateEmailId,
                autofocus: mounted,
                autocorrect: false,
                onFieldSubmitted: (value) {
                  if (value.isNotEmpty) {
                    widget.finalStepProccessing();
                  }
                },
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding:
                      EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                  hintText: "confirmPassword",
                  hintStyle: TextStyle(fontSize: 16, color: Color(0xFF929BAB)),
                ),
                style: const TextStyle(fontSize: 16, color: Color(0xFF929BAB)),
              ),
            ),
            if (confirmPasswordErrorMessage != '')
              Container(
                margin: const EdgeInsets.all(2),
                padding: const EdgeInsets.all(2),
                child: Text(
                  "\t\t\t\t$confirmPasswordErrorMessage",
                  style: const TextStyle(fontSize: 10, color: Colors.red),
                ),
              ),

            // confirm password code end here
          ],
        ));
  }

  // void errorMessageSetter(String fieldName, String message) {
  //   setState(() {
  //     switch (fieldName) {
  //       case 'EMAIL-Id':
  //         emailErrorMessage = message;
  //         break;
  //     }
  //   });
  // }

  // String? _validateEmailId(String? value) {
  //   if (value == null || value.isEmpty) {
  //     errorMessageSetter('EMAIL-ID', 'you must provide a valid email-id');
  //   } else if (!validEmailFormat.hasMatch(value)) {
  //     errorMessageSetter('EMAIL-ID', 'format of your email address is invalid');
  //   } else {
  //     errorMessageSetter('EMAIL-ID', "");
  //     widget.updateSignUpDetails('email', value);
  //   }

  //   return null;
  // }

  void _toggleSignUpButtonVisibility(String value) {
    widget.registrationDetails('confirmPassword', value);
    if (value.isNotEmpty) {
      widget.showConfirmSignUpButton(true);
    } else {
      widget.showConfirmSignUpButton(false);
    }
  }
}
