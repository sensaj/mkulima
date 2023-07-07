// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mkulima/models/journey_info.dart';
import 'package:mkulima/models/request.dart';
import 'package:mkulima/models/schedule.dart';
import 'package:mkulima/models/user.dart';
import 'package:mkulima/theme/colors.dart';
import 'package:mkulima/utils/enum.dart';
import 'package:mkulima/widgets/request_container.dart';

class RequestListPage extends StatefulWidget {
  final RequestType requestType;
  final User user;
  RequestListPage({required this.requestType, required this.user});

  @override
  State<RequestListPage> createState() => _RequestListPageState();
}

class _RequestListPageState extends State<RequestListPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: CupertinoColors.systemGrey3,
          leading: IconButton(
            icon: Icon(CupertinoIcons.chevron_back, color: colors.primary),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          title: Text(
            widget.requestType == RequestType.send
                ? "Sent Requests"
                : "Receiving Requests",
            style:
                TextStyle(color: colors.primary, fontWeight: FontWeight.bold),
          ),
        ),
        body: StreamBuilder<List<JourneyInfo>>(
          stream: getRequests(),
          builder: (BuildContext context,
              AsyncSnapshot<List<JourneyInfo>> snapshot) {
            if (snapshot.hasData) {
              final journeys = snapshot.data;
              // Render your UI based on the data
              return ListView.builder(
                itemCount: journeys!.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return JourneyInfoContainer(
                    journey: journeys[index],
                    requestType: widget.requestType,
                    user: widget.user,
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(backgroundColor: Colors.white),
              );
            }
          },
        ),
      ),
    );
  }

  Stream<List<JourneyInfo>> getRequests() {
    final StreamController<List<JourneyInfo>> controller =
        StreamController<List<JourneyInfo>>();
    if (widget.requestType == RequestType.send) {
      FirebaseFirestore.instance
          .collection('requests')
          .where("client_id", isEqualTo: widget.user.id)
          .where("status", whereIn: ["sent", "accepted"])
          .snapshots()
          .listen((snapshot) async {
            List<JourneyInfo> infos = [];
            for (var doc in snapshot.docs) {
              final requestMap = doc.data();
              requestMap['id'] = doc.id;
              final scheduleQuery = await FirebaseFirestore.instance
                  .collection('schedules')
                  .where(FieldPath.documentId,
                      isEqualTo: requestMap['schedule_id'])
                  .where("status", whereIn: ["active", "started"]).get();
              final scheduleMap = scheduleQuery.docs.first.data();
              scheduleMap['id'] = scheduleQuery.docs.first.id;
              final journeyMap = {
                "schedule": scheduleMap,
                "request": requestMap,
                "driver_position": scheduleMap['driver_position'],
                "driver_phone": scheduleMap['driver_phone'],
                "status": requestMap['status'] == "accepted"
                    ? scheduleMap['status']
                    : requestMap['status'],
                "client_position": requestMap['receiver_position'],
                "client_phone": requestMap['receiver_phone'],
              };

              final JourneyInfo journeyInfo = JourneyInfo.fromMap(journeyMap);
              infos.add(journeyInfo);
            }
            controller.add(infos);
          }, onError: (error) {
            controller.addError(error);
          });
    } else {
      FirebaseFirestore.instance
          .collection('requests')
          .where("receiver_id", isEqualTo: widget.user.id)
          .where("status", whereIn: ["sent", "accepted"])
          .snapshots()
          .listen((snapshot) async {
            List<JourneyInfo> infos = [];
            for (var doc in snapshot.docs) {
              final requestMap = doc.data();
              requestMap['id'] = doc.id;
              final scheduleQuery = await FirebaseFirestore.instance
                  .collection('schedules')
                  .where(FieldPath.documentId,
                      isEqualTo: requestMap['schedule_id'])
                  .where("status", whereIn: ["active", "started"]).get();
              final scheduleMap = scheduleQuery.docs.first.data();
              scheduleMap['id'] = scheduleQuery.docs.first.id;

              final journeyMap = {
                "schedule": scheduleMap,
                "request": requestMap,
                "driver_position": scheduleMap['driver_position'],
                "driver_phone": scheduleMap['driver_phone'],
                "status": requestMap['status'] == "accepted"
                    ? scheduleMap['status']
                    : requestMap['status'],
                "client_position": requestMap['sender_position'],
                "client_phone": requestMap['sender_phone'],
              };
              final JourneyInfo journeyInfo = JourneyInfo.fromMap(journeyMap);
              infos.add(journeyInfo);
            }
            controller.add(infos);
          }, onError: (error) {
            controller.addError(error);
          });
    }
    return controller.stream;
  }
}
