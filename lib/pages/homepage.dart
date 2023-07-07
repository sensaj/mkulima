// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mkulima/models/schedule.dart';
import 'package:mkulima/models/user.dart';
import 'package:mkulima/services/helper_services.dart';
import 'package:mkulima/theme/colors.dart';
import 'package:mkulima/widgets/client_info_card.dart';
import 'package:mkulima/widgets/logout_prompt.dart';
import 'package:mkulima/widgets/schedule_card.dart';

class Homepage extends StatefulWidget {
  final User user;
  Homepage({required this.user});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DateTime date = DateTime.now();
  late String today;

  @override
  void initState() {
    super.initState();
    today = helper.beautifyDate(date);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        drawer: _clientDrawer(),
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 200,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: ClientInfoCard(user: widget.user),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * .03, vertical: 10),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "Active Schedules",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 23,
                          color: colors.gray,
                        ),
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: firestore.collection('schedules').where("status",
                          whereIn: ["active", "started"]).snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        if (snapshot.hasData) {
                          if (snapshot.data!.docs.isNotEmpty) {
                            return SizedBox(
                              child: ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                primary: false,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  final data = snapshot.data!.docs[index].data()
                                      as Map<String, dynamic>;
                                  data['id'] = snapshot.data!.docs[index].id;
                                  final schedule = DriverSchedule.fromMap(data);
                                  return ScheduleCard(
                                      schedule: schedule, user: widget.user);
                                },
                              ),
                            );
                          }
                          return Container();
                        }
                        return Container();
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Drawer _clientDrawer() {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: colors.primary),
              ),
              child: Icon(CupertinoIcons.person_alt,
                  color: colors.primary, size: 100),
            ),
            Text(
              "${widget.user.name}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colors.black,
                fontSize: 18,
              ),
            ),
            Text(
              "${widget.user.phone}",
              style: TextStyle(color: colors.black, fontSize: 12),
            ),
            SizedBox(height: 50),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(
            //           "Email",
            //           style: TextStyle(
            //             fontWeight: FontWeight.bold,
            //             color: colors.black,
            //             fontSize: 18,
            //           ),
            //         ),
            //         Text(
            //           "${widget.user.truck}",
            //           style: TextStyle(color: colors.black),
            //         ),
            //       ],
            //     ),
            //     Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(
            //           "Plate No.",
            //           style: TextStyle(
            //             fontWeight: FontWeight.bold,
            //             color: colors.black,
            //             fontSize: 18,
            //           ),
            //         ),
            //         Text(
            //           "${widget.user.plateNo}",
            //           style: TextStyle(color: colors.black),
            //         ),
            //       ],
            //     ),
            //     Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(
            //           "Licence",
            //           style: TextStyle(
            //             fontWeight: FontWeight.bold,
            //             color: colors.black,
            //             fontSize: 18,
            //           ),
            //         ),
            //         Text(
            //           "${widget.user.licence}",
            //           style: TextStyle(color: colors.black),
            //         ),
            //       ],
            //     ),
            //   ],
            // ),
            // SizedBox(height: 20),
            InkWell(
              child: Container(
                width: double.infinity,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  "Log Out",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                ),
              ),
              onTap: () {
                showModalBottomSheet<dynamic>(
                  isScrollControlled: true,
                  clipBehavior: Clip.antiAlias,
                  backgroundColor: Color(0xffe5e4e2),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                  )),
                  elevation: 5,
                  context: context,
                  builder: (context) => LogoutPrompt(),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
