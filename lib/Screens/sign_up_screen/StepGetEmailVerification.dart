import 'package:flutter/material.dart';

class StepGetEmailVerification extends StatefulWidget {
  final LabeledGlobalKey<FormState> emailPasswordFormKey;
  // final Function updateSignUpDetails;

  // final String email;
  final Function proceedToNextStep;
  const StepGetEmailVerification(
      {Key? key,
      // required this.updateSignUpDetails,
      // required this.email,
      required this.emailPasswordFormKey,
      required this.proceedToNextStep})
      : super(key: key);

  @override
  _StepGetEmailVerificationState createState() =>
      _StepGetEmailVerificationState();
}

class _StepGetEmailVerificationState extends State<StepGetEmailVerification> {
  String email = "";
  String emailErrorMessage = "";
  @override
  void initState() {
    super.initState();
    // email = widget.email;
  }

  @override
  void dispose() {
    // widget.emailPasswordFormKey.currentState?.validate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: widget.emailPasswordFormKey,
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
                // initialValue: email,
                // validator: _validateNewPassword,
                autofocus: mounted,
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
                  hintText: "email",
                  hintStyle: TextStyle(fontSize: 16, color: Color(0xFF929BAB)),
                ),
                style: const TextStyle(fontSize: 16, color: Color(0xFF929BAB)),
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
              ),
            ),
            if (emailErrorMessage != '')
              Container(
                margin: const EdgeInsets.all(2),
                padding: const EdgeInsets.all(2),
                width: double.infinity,
                child: Text(
                  "\t\t\t\t$emailErrorMessage",
                  style: const TextStyle(fontSize: 10, color: Colors.red),
                ),
              ),
            // Email CODE END HERE
          ],
        ));
  }

  // void errorMessageSetter(String fieldName, String message) {
  //   setState(() {
  //     switch (fieldName) {
  //       case 'NEW-PASSWORD':
  //         new_passwordErrorMessage = message;
  //         break;

  //       case 'CONFIRM-PASSWORD':
  //         confirm_passwordErrorMessage = message;
  //         break;
  //     }
  //   });
  // }

  // String? _validateNewPassword(String? value) {
  //   if (value == null || value.isEmpty) {
  //     errorMessageSetter('NEW-PASSWORD', 'password cannot be empty');
  //   } else {
  //     errorMessageSetter('NEW-PASSWORD', "");

  //     widget.updateSignUpDetails('new_password', value);
  //   }
  //   return null;
  // }

  // String? _validateConfirmpassword(String? value) {
  //   if (value == null || value.isEmpty) {
  //     errorMessageSetter(
  //         'CONFIRM-PASSWORD', 'you must provide a valid confirm-password');
  //   } else {
  //     errorMessageSetter('CONFIRM-PASSWORD', "");
  //     widget.updateSignUpDetails('confirm_password', value);
  //   }

  //   return null;
  // }
}
