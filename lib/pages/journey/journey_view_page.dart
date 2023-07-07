// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mkulima/models/journey_info.dart';
import 'package:mkulima/models/user.dart';
import 'package:mkulima/pages/journey/map_view.dart';
import 'package:mkulima/providers/map_view_provider.dart';
import 'package:mkulima/services/helper_services.dart';
import 'package:mkulima/theme/colors.dart';
import 'package:mkulima/utils/enum.dart';
import 'package:provider/provider.dart';

class JourneyViewPage extends StatefulWidget {
  final User user;
  final JourneyInfo journey;
  final RequestType requestType;
  JourneyViewPage(
      {required this.requestType, required this.journey, required this.user});

  @override
  State<JourneyViewPage> createState() => _JourneyViewPageState();
}

class _JourneyViewPageState extends State<JourneyViewPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late JourneyInfo journey;
  String today = "";

  @override
  void initState() {
    super.initState();
    journey = widget.journey;
    today = helper.beautifyDate(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final mapState = Provider.of<MapViewProvider>(context);
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey5,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: colors.black),
                          child: IconButton(
                            icon: Icon(
                              CupertinoIcons.chevron_back,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Text(
                          "Delivery to: ${journey.request!.destination}",
                          style: TextStyle(
                            color: colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        )
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              today,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "Driver Location",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: colors.black,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              mapState.driverCurrentLocName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              MapView(
                  journey: journey,
                  mapState: mapState,
                  requestType: widget.requestType),
            ],
          ),
        ),
      ),
    );
  }
}
