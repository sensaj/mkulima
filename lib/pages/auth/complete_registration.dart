// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mkulima/models/user.dart';
import 'package:mkulima/pages/homepage.dart';
import 'package:mkulima/services/local_services.dart';
import 'package:mkulima/services/user_services.dart';
import 'package:mkulima/theme/colors.dart';
import 'package:mkulima/widgets/app_elevated_button.dart';
import 'package:mkulima/widgets/app_textformfield.dart';
import 'package:mkulima/widgets/pop_up_dialogs.dart';

class CompleteRegistration extends StatefulWidget {
  final String userId;
  CompleteRegistration({required this.userId});

  @override
  State<CompleteRegistration> createState() => _CompleteRegistrationState();
}

class _CompleteRegistrationState extends State<CompleteRegistration> {
  final _formKey = GlobalKey<FormState>();
  String name = "";
  String nameError = "";
  String location = "";
  String locationError = "";
  String phone = "";
  String phoneError = "";
  RegExp phonePattern = RegExp(r'^\+\d{1,3}\s?\d{9,}$');

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: size.height,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    margin: EdgeInsets.symmetric(vertical: 50),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage("assets/images/logo.png"),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: size.width * .03),
                    alignment: Alignment.center,
                    child: Container(
                      width: size.width,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * .03, vertical: 10),
                      decoration: BoxDecoration(
                        color: colors.gray,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Profile Info",
                            style: TextStyle(
                              color: colors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                          SizedBox(height: 10),
                          AppTextFormField(
                            hintText: "Full name",
                            errorText: nameError,
                            validator: (value) {
                              setState(() {
                                if (value != null && value.isNotEmpty) {
                                  name = value;
                                  nameError = "";
                                } else {
                                  name = "";
                                  nameError = "this field can not be empty";
                                }
                              });
                              return;
                            },
                          ),
                          AppTextFormField(
                            hintText: "phone +255 xxx xxx xxx",
                            errorText: phoneError,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              setState(() {
                                if (value != null) {
                                  if (phonePattern.hasMatch(value)) {
                                    phone = value;
                                    phoneError = "";
                                  } else {
                                    phone = "";
                                    phoneError =
                                        "kindly use this phonePattern +255 xxx xxx xxx";
                                  }
                                } else {
                                  phone = "";
                                  phoneError = "this field can not be null";
                                }
                              });
                              return;
                            },
                          ),
                          AppTextFormField(
                            hintText: "Residence",
                            errorText: locationError,
                            validator: (value) {
                              setState(() {
                                if (value != null && value.isNotEmpty) {
                                  location = value;
                                  locationError = "";
                                } else {
                                  location = "";
                                  locationError = "this field can not be null";
                                }
                              });
                              return;
                            },
                          ),
                          isLoading
                              ? CircularProgressIndicator()
                              : AppElevatedButton(
                                  label: "Save",
                                  onPressed: validateInputs,
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  validateInputs() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_formKey.currentState!.validate()) {
      if (phoneError == "" && nameError == "" && locationError == "") {
        _completeRegistration();
      }
    }
  }

  _completeRegistration() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> userData = {
      "user_id": widget.userId,
      "name": name,
      "phone": phone,
      "location": location,
    };

    try {
      final results = await userServices.createUserData(userData: userData);
      if (results is User) {
        local.setInstance(key: "hasLogin", type: bool, value: true);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Homepage(user: results),
          ),
        );
      } else {
        dialog.errorDialog(
          context: context,
          header: "ERROR!",
          body: "Failed to create user data $results",
        );
      }
    } catch (e) {
      print("--------------------------------------------------------$e");
      dialog.errorDialog(
        context: context,
        header: "ERROR!",
        body:
            "Registration returned errors, Please check your connection and retry",
      );
    }
  }
}
