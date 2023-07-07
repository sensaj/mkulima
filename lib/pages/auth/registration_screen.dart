// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mkulima/pages/auth/complete_registration.dart';
import 'package:mkulima/pages/auth/login_screen.dart';
import 'package:mkulima/services/auth_services.dart';
import 'package:mkulima/theme/colors.dart';
import 'package:mkulima/widgets/app_textformfield.dart';
import 'package:mkulima/widgets/pop_up_dialogs.dart';

class RegistrationScreen extends StatefulWidget {
  RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  String email = "";
  String emailError = "";
  String password = "";
  String passwordError = "";
  String comfPassword = "";
  String comfPasswordError = "";
  String _emailPattern =
      r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";

  bool isLoading = false, obscureText = true;
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
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Sign Up",
                            style: TextStyle(
                              color: colors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                          SizedBox(height: 10),
                          AppTextFormField(
                            hintText: "email",
                            color: colors.background,
                            keyboardType: TextInputType.emailAddress,
                            errorText: emailError,
                            validator: (value) {
                              setState(() {
                                if (value == null || value.isEmpty) {
                                  emailError = 'you must provide a email';
                                } else {
                                  emailError = "";
                                  email = value;
                                }
                              });

                              return null;
                            },
                          ),
                          AppTextFormField(
                            hintText: "password",
                            color: colors.background,
                            errorText: passwordError,
                            obscureText: obscureText,
                            suffix: InkWell(
                              child: Icon(
                                obscureText
                                    ? CupertinoIcons.eye
                                    : CupertinoIcons.eye_slash,
                                color: Color(0xFF929BAB),
                              ),
                              onTap: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                            ),
                            onChanged: (value) {
                              setState(() {
                                if (value != null) {
                                  password = value;
                                }
                              });

                              return null;
                            },
                            validator: (value) {
                              setState(() {
                                if (value == null || value.isEmpty) {
                                  passwordError = 'you must provide a password';
                                } else {
                                  if (value == comfPassword) {
                                    passwordError = "";
                                  } else {
                                    print(
                                        "$value-------------------$comfPassword");
                                    passwordError =
                                        'passwords are not the same';
                                  }
                                }
                              });

                              return null;
                            },
                          ),
                          AppTextFormField(
                            hintText: "comfirm password",
                            color: colors.background,
                            errorText: comfPasswordError,
                            obscureText: obscureText,
                            suffix: InkWell(
                              child: Icon(
                                obscureText
                                    ? CupertinoIcons.eye
                                    : CupertinoIcons.eye_slash,
                                color: Color(0xFF929BAB),
                              ),
                              onTap: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                            ),
                            validator: (value) {
                              setState(() {
                                if (value == null || value.isEmpty) {
                                  comfPasswordError =
                                      'you must provide a password';
                                } else {
                                  if (value == password) {
                                    comfPasswordError = "";
                                  } else {
                                    comfPasswordError =
                                        'passwords are not the same';
                                  }
                                }
                              });

                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                if (value != null) {
                                  comfPassword = value;
                                }
                              });

                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.black, shape: BoxShape.circle),
                            child: isLoading
                                ? CircularProgressIndicator()
                                : IconButton(
                                    icon: Icon(
                                      CupertinoIcons.chevron_forward,
                                      color: Colors.white,
                                    ),
                                    onPressed: validateInputs,
                                  ),
                          ),
                          SizedBox(height: 10),
                          Wrap(
                            children: [
                              Text(
                                "Already registered? ",
                                style: TextStyle(color: Colors.black),
                              ),
                              InkWell(
                                child: Text(
                                  "sign in",
                                  style: TextStyle(color: colors.primary),
                                ),
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()),
                                  );
                                },
                              ),
                            ],
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
      if (emailError == "" && passwordError == "" && comfPasswordError == "") {
        _registerUser();
      }
    }
  }

  _registerUser() async {
    setState(() {
      isLoading = true;
    });
    print("Accessing Firebase...");
    var result = await auth.signUpWithEmail(email: email, password: password);
    if (result is bool) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CompleteRegistration(userId: auth.user!.uid),
          ));
    } else {
      dialog.errorDialog(context: context, header: "ERROR", body: result);
    }
    setState(() {
      isLoading = false;
    });
  }
}
