import 'package:flutter/material.dart';

class StepCreateAccount extends StatefulWidget {
  final LabeledGlobalKey<FormState> nameAddressFormKey;
  // final Function updateSignUpDetails;

  final Function registrationDetails;
  final Function proceedToNextStep;
  const StepCreateAccount(
      {Key? key,
      // required this.updateSignUpDetails,
      required this.nameAddressFormKey,
      required this.registrationDetails,
      required this.proceedToNextStep})
      : super(key: key);

  @override
  _StepCreateAccountState createState() => _StepCreateAccountState();
}

class _StepCreateAccountState extends State<StepCreateAccount> {
  String companyName = "";
  String companyNameErrorMessage = "";
  String email = "";
  String emailErrorMessage = "";
  RegExp validEmailFormat = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  String mobNo = "";
  String mobNoErrorMessage = "";

  String workspace = "";
  String workspaceErrorMessage = "";

  String gstNumber = "";
  String gstNumberErrorMessage = "";

  String pancard = "";
  String pancardErrorMessage = "";

  String working = "";
  String workingErrorMessage = "";

  @override
  void initState() {
    super.initState();
    Map<String, String> signUpDetails = widget.registrationDetails();
    if (mounted) {
      setState(() {
        companyName = signUpDetails['companyName'].toString();
        email = signUpDetails['email'].toString();
        mobNo = signUpDetails['mobile'].toString();
        workspace = signUpDetails['workspace'].toString();
        gstNumber = signUpDetails['gstNumber'].toString();
        pancard = signUpDetails['pancard'].toString();
        working = signUpDetails['working'].toString();
      });
    }
  }

  @override
  void dispose() {
    // widget.nameAddressFormKey.currentState?.validate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
            key: widget.nameAddressFormKey,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          width: 1.0, color: const Color(0xFFF5F7FA)),
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
                    // initialValue: companyName,
                    validator: _validatecompanyName,
                    autofocus: mounted,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 11, top: 11, right: 15),
                      hintText: "Company_Name",
                      hintStyle:
                          TextStyle(fontSize: 16, color: Color(0xFF929BAB)),
                    ),
                    style:
                        const TextStyle(fontSize: 16, color: Color(0xFF929BAB)),
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                if (companyNameErrorMessage != '')
                  Container(
                    margin: const EdgeInsets.all(2),
                    padding: const EdgeInsets.all(2),
                    width: double.infinity,
                    child: Text(
                      "\t\t\t\t$companyNameErrorMessage",
                      style: const TextStyle(fontSize: 10, color: Colors.red),
                    ),
                  ),
                // COMPANY NAME CODE END HERE
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          width: 1.0, color: const Color(0xFFF5F7FA)),
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
                    // validator: _validatelastName,
                    autofocus: mounted,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 11, top: 11, right: 15),
                      hintText: "email",
                      hintStyle:
                          TextStyle(fontSize: 16, color: Color(0xFF929BAB)),
                    ),
                    style:
                        const TextStyle(fontSize: 16, color: Color(0xFF929BAB)),
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

                // input field for email name ends here

                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          width: 1.0, color: const Color(0xFFF5F7FA)),
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
                    // initialValue: mobNo,
                    // validator: _validatemobno,
                    autofocus: mounted,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 11, top: 11, right: 15),
                      hintText: "mob_no",
                      hintStyle:
                          TextStyle(fontSize: 16, color: Color(0xFF929BAB)),
                    ),
                    style:
                        const TextStyle(fontSize: 16, color: Color(0xFF929BAB)),
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => widget.proceedToNextStep(),
                  ),
                ),
                if (mobNoErrorMessage != '')
                  Container(
                    margin: const EdgeInsets.all(2),
                    padding: const EdgeInsets.all(2),
                    width: double.infinity,
                    child: Text(
                      "\t\t\t\t$mobNoErrorMessage",
                      style: const TextStyle(fontSize: 10, color: Colors.red),
                    ),
                  ),
                // input field for Mob No ends here

                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          width: 1.0, color: const Color(0xFFF5F7FA)),
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
                    // initialValue: workspace,
                    // validator: _validatelastName,
                    autofocus: mounted,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 11, top: 11, right: 15),
                      hintText: "workspace",
                      hintStyle:
                          TextStyle(fontSize: 16, color: Color(0xFF929BAB)),
                    ),
                    style:
                        const TextStyle(fontSize: 16, color: Color(0xFF929BAB)),
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                if (workspaceErrorMessage != '')
                  Container(
                    margin: const EdgeInsets.all(2),
                    padding: const EdgeInsets.all(2),
                    width: double.infinity,
                    child: Text(
                      "\t\t\t\t$workspaceErrorMessage",
                      style: const TextStyle(fontSize: 10, color: Colors.red),
                    ),
                  ),
                // workspace code end
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          width: 1.0, color: const Color(0xFFF5F7FA)),
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
                    // initialValue: gstNumber,
                    // validator: _validatelastName,
                    autofocus: mounted,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 11, top: 11, right: 15),
                      hintText: "gst number",
                      hintStyle:
                          TextStyle(fontSize: 16, color: Color(0xFF929BAB)),
                    ),
                    style:
                        const TextStyle(fontSize: 16, color: Color(0xFF929BAB)),
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                if (gstNumberErrorMessage != '')
                  Container(
                    margin: const EdgeInsets.all(2),
                    padding: const EdgeInsets.all(2),
                    width: double.infinity,
                    child: Text(
                      "\t\t\t\t$gstNumberErrorMessage",
                      style: const TextStyle(fontSize: 10, color: Colors.red),
                    ),
                  ),
                // gst number code end here
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          width: 1.0, color: const Color(0xFFF5F7FA)),
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
                    // initialValue: pancard,
                    // validator: _validatelastName,
                    autofocus: mounted,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 11, top: 11, right: 15),
                      hintText: "pancard",
                      hintStyle:
                          TextStyle(fontSize: 16, color: Color(0xFF929BAB)),
                    ),
                    style:
                        const TextStyle(fontSize: 16, color: Color(0xFF929BAB)),
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                if (pancardErrorMessage != '')
                  Container(
                    margin: const EdgeInsets.all(2),
                    padding: const EdgeInsets.all(2),
                    width: double.infinity,
                    child: Text(
                      "\t\t\t\t$pancardErrorMessage",
                      style: const TextStyle(fontSize: 10, color: Colors.red),
                    ),
                  ),
                // pancard end here
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          width: 1.0, color: const Color(0xFFF5F7FA)),
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
                    // initialValue: working,
                    // validator: _validatelastName,
                    autofocus: mounted,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 11, top: 11, right: 15),
                      hintText: "working",
                      hintStyle:
                          TextStyle(fontSize: 16, color: Color(0xFF929BAB)),
                    ),
                    style:
                        const TextStyle(fontSize: 16, color: Color(0xFF929BAB)),
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                if (workingErrorMessage != '')
                  Container(
                    margin: const EdgeInsets.all(2),
                    padding: const EdgeInsets.all(2),
                    width: double.infinity,
                    child: Text(
                      "\t\t\t\t$workingErrorMessage",
                      style: const TextStyle(fontSize: 10, color: Colors.red),
                    ),
                  ),
              ],
            )),
      ),
    );
  }

  void errorMessageSetter(String fieldName, String message) {
    setState(() {
      switch (fieldName) {
        case 'COMPANY_NAME':
          companyNameErrorMessage = message;
          break;

        // case 'LAST-NAME':
        //   last_nameErrorMessage = message;
        //   break;

        // case 'MOB-NO':
        //   mob_noErrorMessage = message;
        //   break;
      }
    });
  }

  String? _validatecompanyName(String? value) {
    if (value == null || value.isEmpty) {
      errorMessageSetter('COMPANY_NAME', 'you must provide your Company name');
    } else if (value.length > 100) {
      errorMessageSetter(
          'COMPANY_NAME', 'name cannot contain more than 100 characters');
    } else {
      errorMessageSetter('COMPANY_NAME', "");

      // widget.updateSignUpDetails('first_name', value);
    }

    return null;
  }

  // String? _validatelastName(String? value) {
  //   if (value == null || value.isEmpty) {
  //     errorMessageSetter('LAST-NAME', 'you must provide your last name');
  //   } else if (value.length > 100) {
  //     errorMessageSetter(
  //         'LAST-NAME', 'name cannot contain more than 100 characters');
  //   } else {
  //     errorMessageSetter('LAST-NAME', "");

  //     widget.updateSignUpDetails('last_name', value);
  //   }

  //   return null;
  // }

  // String? _validatemobno(String? value) {
  //   if (value == null || value.isEmpty) {
  //     errorMessageSetter('MOB-NO', 'you must provide your MOB-NO');
  //   } else if (value.length > 100) {
  //     errorMessageSetter(
  //         'MOB-NO', 'name cannot contain more than 100 characters');
  //   } else {
  //     errorMessageSetter('MOB-NO', "");

  //     widget.updateSignUpDetails('mob_no', value);
  //   }

  //   return null;
  // }

  // String? _validateAddress(String? value) {
  //   if (value == null || value.isEmpty) {
  //     errorMessageSetter(
  //         'RESIDENTIAL-ADDRESS', 'you must provide your residential address');
  //   } else if (value.length > 300) {
  //     errorMessageSetter('RESIDENTIAL-ADDRESS',
  //         'address cannot contain more than 300 characters');
  //   } else {
  //     errorMessageSetter('RESIDENTIAL-ADDRESS', "");

  //     widget.updateSignUpDetails('address', value);
  //   }

  //   return null;
  // }
}
