// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mkulima/theme/colors.dart';

class AppDatePicker {
  showDatePicker(
      {required BuildContext context,
      required Function(DateTime) onDateTimeChanged,
      required VoidCallback onDateComfirm,
      required int minimumYear,
      required DateTime initialDate,
      DateTime? minimumDate,
      DateTime? maximumDate,
      required int maximumYear,
      required String title}) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              contentPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5).copyWith(
                    bottomLeft: Radius.zero, bottomRight: Radius.zero),
              ),
              content: Container(
                height: 325,
                decoration: BoxDecoration(
                  color: colors.gray,
                  borderRadius: BorderRadius.circular(5).copyWith(
                      bottomLeft: Radius.zero, bottomRight: Radius.zero),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 5),
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 5),
                    SizedBox(
                      height: 250,
                      child: CupertinoTheme(
                        data: CupertinoThemeData(
                          brightness: Brightness.dark,
                        ),
                        child: CupertinoDatePicker(
                          minimumYear: minimumYear,
                          initialDateTime: initialDate,
                          maximumYear: maximumYear,
                          mode: CupertinoDatePickerMode.date,
                          onDateTimeChanged: onDateTimeChanged,
                          maximumDate: maximumDate,
                          minimumDate: minimumDate,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: InkWell(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(
                            "Ok",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: colors.primary,
                            ),
                          ),
                        ),
                        onTap: onDateComfirm,
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }
}

AppDatePicker appDatePicker = AppDatePicker();
