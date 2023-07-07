// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDialogs {
  successDialog(
      {required context, required contentIcon, required String body}) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: AlertDialog(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  width: 30,
                  height: 30,
                  child: contentIcon,
                ),
                SizedBox(height: 10),
                Text(
                  body.toString(),
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  errorDialog({required context, required header, required String body}) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: AlertDialog(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  width: 30,
                  height: 30,
                  child: Image(
                    image: AssetImage("assets/icons/warning.png"),
                  ),
                ),
                Text(
                  header,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  body,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                child: Text(
                  "Ok",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        );
      },
    );
  }

  passwordFormDialog({
    required context,
    required TextEditingController controller,
    required ValueChanged onChanged,
    required VoidCallback onCancel,
    required VoidCallback onSubmit,
  }) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        String? errorText;
        return Container(
          child: AlertDialog(
            backgroundColor: Color(0xffe5e4e2),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: CustomPassInput(
                //     labelText: "password",
                //     controller: controller,
                //     obsecureText: true,
                //     errorText: errorText!,
                //     suffix: InkWell(
                //         child: Icon(
                //           CupertinoIcons.eye,
                //           color: Color(0xffe5e4e2),
                //           size: 20,
                //         ),
                //         onTap: null),
                //     onChanged: onChanged,
                //   ),
                // ),
              ],
            ),
            actions: [
              TextButton(
                child: Text(
                  "Cancel",
                  style: TextStyle(
                      color: Colors.blueGrey, fontWeight: FontWeight.bold),
                ),
                onPressed: onCancel,
              ),
              TextButton(
                child: Text(
                  "Ok",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: onSubmit,
              )
            ],
          ),
        );
      },
    );
  }
}

CustomDialogs dialog = CustomDialogs();
