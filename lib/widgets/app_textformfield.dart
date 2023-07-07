// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';

class AppTextFormField extends StatelessWidget {
  final String? Function(String? value)? validator;
  final String? Function(String? value)? onChanged;
  final String? hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final String? errorText;
  final Widget? suffix;
  final int? maxLines;
  final int? minLines;
  final bool readOnly;
  final TextInputType? keyboardType;
  final void Function()? onTap;
  final Color color;

  const AppTextFormField({
    this.onTap,
    this.controller,
    this.errorText,
    this.hintText,
    this.suffix,
    this.validator,
    this.onChanged,
    this.minLines,
    this.keyboardType,
    this.maxLines = 1,
    this.obscureText = false,
    this.readOnly = false,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(width: 1.0, color: Color(0xFFF5F7FA)),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                blurRadius: 6.18,
                spreadRadius: 0.618,
                offset: Offset(-4, -4),
                // color: Colors.white38
                color: errorText == "" ? Color(0xFF929BAB) : Colors.red,
              ),
              BoxShadow(
                blurRadius: 6.18,
                spreadRadius: 0.618,
                offset: Offset(4, 4),
                color: errorText == "" ? Color(0xFF929BAB) : Colors.red,
              )
            ],
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            readOnly: readOnly,
            minLines: minLines,
            maxLines: maxLines,
            keyboardType: keyboardType,
            autocorrect: false,
            validator: validator,
            onChanged: onChanged,
            onTap: onTap,
            decoration: InputDecoration(
              fillColor: Colors.white,
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              // errorText: errorText,
              suffix: suffix,
              contentPadding:
                  EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
              hintText: hintText,
              hintStyle: TextStyle(fontSize: 16, color: Color(0xFF929BAB)),
            ),
            style: TextStyle(fontSize: 16, color: Color(0xFF929BAB)),
          ),
        ),
        if (errorText != null)
          Container(
            child: Text(
              "\t\t\t\t$errorText",
              style: TextStyle(fontSize: 10, color: Colors.red),
            ),
            margin: EdgeInsets.all(2),
            padding: EdgeInsets.all(2),
          ),
      ],
    );
  }
}
