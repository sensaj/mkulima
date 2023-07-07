// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mkulima/models/journey_info.dart';
import 'package:mkulima/models/user.dart';
import 'package:mkulima/pages/journey/journey_view_page.dart';
import 'package:mkulima/services/helper_services.dart';
import 'package:mkulima/services/user_services.dart';
import 'package:mkulima/theme/colors.dart';
import 'package:mkulima/utils/enum.dart';

class JourneyInfoContainer extends StatefulWidget {
  final JourneyInfo journey;
  final User user;
  final RequestType requestType;
  const JourneyInfoContainer(
      {required this.journey, required this.user, required this.requestType});

  @override
  State<JourneyInfoContainer> createState() => _JourneyInfoContainerState();
}

class _JourneyInfoContainerState extends State<JourneyInfoContainer> {
  late JourneyInfo journey;
  User? driver, client;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    journey = widget.journey;
    _getClientsInfo();
  }

  _getClientsInfo() async {
    final _driver =
        await userServices.getDriverData(driverId: journey.schedule!.driver);
    final _client = await userServices.getClientData(
        userId: widget.requestType == RequestType.send
            ? journey.request!.receiver
            : journey.request!.client);
    setState(() {
      driver = _driver;
      client = _client;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: colors.black, offset: Offset(0, 4), blurRadius: 5.0)
        ],
      ),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: CupertinoColors.systemGrey5,
          borderRadius: BorderRadius.circular(5),
        ),
        child: isLoading
            ? Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 1),
                ),
              )
            : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Driver Info",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Divider(),
                          Text(
                            "${driver!.name}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text("${widget.journey.schedule!.start}"),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(color: colors.black),
                              children: [
                                TextSpan(
                                  text:
                                      "${widget.journey.schedule!.destination}",
                                ),
                                TextSpan(
                                    text: "  Via  ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(
                                  text: "${widget.journey.schedule!.via}",
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Wrap(
                            children: [
                              InkWell(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(3),
                                  topRight: Radius.circular(3),
                                ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 3, horizontal: 5),
                                  decoration: BoxDecoration(
                                    color: colors.black,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(3),
                                      topRight: Radius.circular(3),
                                    ),
                                  ),
                                  child: Icon(
                                    CupertinoIcons.phone,
                                    color: Colors.white,
                                  ),
                                ),
                                onTap: () {
                                  helper.makeOutAppCommunication(
                                      media: "call",
                                      comuItem: "${driver!.phone}",
                                      context: context);
                                },
                              ),
                              SizedBox(width: 10),
                              InkWell(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(3),
                                  topRight: Radius.circular(3),
                                ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 3, horizontal: 5),
                                  decoration: BoxDecoration(
                                    color: colors.primary,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(3),
                                      topRight: Radius.circular(3),
                                    ),
                                  ),
                                  child: Icon(CupertinoIcons.text_bubble,
                                      color: Colors.white),
                                ),
                                onTap: () {
                                  helper.makeOutAppCommunication(
                                      media: "sms",
                                      comuItem: "${driver!.phone}",
                                      context: context);
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.requestType == RequestType.send
                                ? "Receiver Info"
                                : "Sender Info",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Divider(),
                          Text(
                            "${client!.name}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text("${widget.journey.request!.destination}"),
                          Text("${widget.journey.request!.parcel}"),
                          SizedBox(height: 10),
                          Wrap(
                            children: [
                              InkWell(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(3),
                                  topRight: Radius.circular(3),
                                ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 3, horizontal: 5),
                                  decoration: BoxDecoration(
                                    color: colors.black,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(3),
                                      topRight: Radius.circular(3),
                                    ),
                                  ),
                                  child: Icon(
                                    CupertinoIcons.phone,
                                    color: Colors.white,
                                  ),
                                ),
                                onTap: () {
                                  helper.makeOutAppCommunication(
                                      media: "call",
                                      comuItem: "${widget.journey.clientPhone}",
                                      context: context);
                                },
                              ),
                              SizedBox(width: 10),
                              InkWell(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(3),
                                  topRight: Radius.circular(3),
                                ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 3, horizontal: 5),
                                  decoration: BoxDecoration(
                                    color: colors.primary,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(3),
                                      topRight: Radius.circular(3),
                                    ),
                                  ),
                                  child: Icon(CupertinoIcons.text_bubble,
                                      color: Colors.white),
                                ),
                                onTap: () {
                                  helper.makeOutAppCommunication(
                                      media: "sms",
                                      comuItem: "${widget.journey.clientPhone}",
                                      context: context);
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  Divider(),
                  widget.journey.status == "started"
                      ? Container(
                          decoration: BoxDecoration(
                            color: colors.blue,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: IconButton(
                            icon: Icon(CupertinoIcons.map_fill,
                                color: Colors.white),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => JourneyViewPage(
                                        requestType: widget.requestType,
                                        journey: journey,
                                        user: widget.user),
                                  ));
                            },
                          ),
                        )
                      : Container(
                          width: 100,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: colors.gray,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(
                            "${widget.journey.status}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                ],
              ),
      ),
    );
  }
}
