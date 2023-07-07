// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mkulima/models/schedule.dart';
import 'package:mkulima/models/user.dart';
import 'package:mkulima/theme/colors.dart';
import 'package:mkulima/widgets/request_form.dart';

class ScheduleCard extends StatefulWidget {
  final DriverSchedule schedule;
  final User user;
  const ScheduleCard({required this.schedule, required this.user});

  @override
  State<ScheduleCard> createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<ScheduleCard> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
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
          StreamBuilder<QuerySnapshot>(
            stream: firestore
                .collection('drivers')
                .where("user_id", isEqualTo: widget.schedule.driver)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (snapshot.hasData) {
                if (snapshot.data!.docs.isNotEmpty) {
                  Map<String, dynamic> data =
                      snapshot.data!.docs[0].data() as Map<String, dynamic>;
                  String name = data['name'];
                  String plateNo = data['plate_no'];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Driver Info",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: colors.primary),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              name,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Wrap(
                              children: [
                                Text("Plate No.: "),
                                Text(plateNo),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider()
                    ],
                  );
                }
                return Container();
              }
              return Container();
            },
          ),
          Text(
            "Schedule on ${widget.schedule.beautyDate}",
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
                    "${widget.schedule.start}",
                    style: TextStyle(color: colors.black),
                  )
                ],
              ),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Icon(CupertinoIcons.map, color: colors.black, size: 15),
                  Text(
                    "${widget.schedule.via}",
                    style: TextStyle(color: colors.black),
                  )
                ],
              ),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Icon(CupertinoIcons.pin_fill, color: colors.black, size: 15),
                  Text(
                    "${widget.schedule.destination}",
                    style: TextStyle(color: colors.black),
                  )
                ],
              ),
              Divider(color: CupertinoColors.systemGrey5),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text("Space:"),
                  Text(
                    "${widget.schedule.space}",
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
        content: RequestForm(schedule: widget.schedule, user: widget.user),
      ),
    );
  }
}
