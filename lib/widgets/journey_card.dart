// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mkulima/models/schedule.dart';
import 'package:mkulima/models/user.dart';
import 'package:mkulima/theme/colors.dart';
import 'package:mkulima/widgets/request_form.dart';

class ScheduleCard extends StatelessWidget {
  final DriverSchedule schedule;
  final User user;
  const ScheduleCard({required this.schedule, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey3,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Schedule on ${schedule.beautyDate}",
            style: TextStyle(color: colors.black, fontWeight: FontWeight.bold),
          ),
          Divider(color: CupertinoColors.systemGrey5),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Icon(CupertinoIcons.map_pin, color: colors.black, size: 15),
                  Text(
                    "${schedule.start}",
                    style: TextStyle(color: colors.black),
                  )
                ],
              ),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Icon(CupertinoIcons.map, color: colors.black, size: 15),
                  Text(
                    "${schedule.via}",
                    style: TextStyle(color: colors.black),
                  )
                ],
              ),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Icon(CupertinoIcons.pin_fill, color: colors.black, size: 15),
                  Text(
                    "${schedule.destination}",
                    style: TextStyle(color: colors.black),
                  )
                ],
              ),
              Divider(color: CupertinoColors.systemGrey5),
              Center(
                child: TextButton(
                  child: Text(
                    "Request",
                    style: TextStyle(
                        color: colors.primary, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    showRequestDialog(context);
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  showRequestDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.symmetric(horizontal: 10),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        content: RequestForm(schedule: schedule, user: user),
      ),
    );
  }
}
