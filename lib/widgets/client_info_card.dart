// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mkulima/models/request.dart';
import 'package:mkulima/models/user.dart';
import 'package:mkulima/pages/requests/request_list_page.dart';
import 'package:mkulima/services/helper_services.dart';
import 'package:mkulima/theme/colors.dart';
import 'package:mkulima/utils/enum.dart';
import 'package:mkulima/widgets/logout_prompt.dart';

class ClientInfoCard extends StatefulWidget {
  final User user;
  const ClientInfoCard({required this.user});

  @override
  State<ClientInfoCard> createState() => _ClientInfoCardState();
}

class _ClientInfoCardState extends State<ClientInfoCard> {
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: size.width * .03, vertical: 10),
      decoration: BoxDecoration(
        color: colors.gray.withOpacity(.5),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: colors.primary.withOpacity(.5)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: firestore
                        .collection('requests')
                        .where("client_id", isEqualTo: widget.user.id)
                        .where("status", whereIn: [
                      "sent",
                      "accepted",
                      // "rejected"
                    ]).snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Sent Request",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Divider(),
                            Text(
                              "Total: --",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(200, 30),
                                backgroundColor: colors.primary,
                              ),
                              onPressed: null,
                              child: Text("---"),
                            )
                          ],
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Sent Request",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Divider(),
                            Text(
                              "Total: --",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(200, 30),
                                backgroundColor: colors.primary,
                              ),
                              onPressed: null,
                              child: Text("Loading..."),
                            )
                          ],
                        );
                      }
                      if (snapshot.hasData) {
                        if (snapshot.data!.docs.isNotEmpty) {
                          final List<ClientRequest> _requests = [];
                          for (var doc in snapshot.data!.docs) {
                            final data = doc.data() as Map<String, dynamic>;
                            data['id'] = doc.id;
                            final request = ClientRequest.fromMap(data);
                            _requests.add(request);
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Sent Request",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Divider(),
                              Text(
                                "Total: ${_requests.length}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    fixedSize: Size(200, 30)),
                                child: Text("View"),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RequestListPage(
                                            requestType: RequestType.send,
                                            user: widget.user),
                                      ));
                                },
                              )
                            ],
                          );
                        }
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Sent Request",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Divider(),
                          Text(
                            "Total: --",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(200, 30),
                              backgroundColor: colors.primary,
                            ),
                            onPressed: null,
                            child: Text("No request"),
                          )
                        ],
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: colors.primary.withOpacity(.5)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: firestore
                        .collection('requests')
                        .where("receiver_id", isEqualTo: widget.user.id)
                        .where("status",
                            whereIn: ["sent", "accepted"]).snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Receiving Request",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Divider(),
                            Text(
                              "Total: --",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(200, 30),
                                backgroundColor: colors.primary,
                              ),
                              onPressed: null,
                              child: Text("---"),
                            )
                          ],
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Receiving Request",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Divider(),
                            Text(
                              "Total: --",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(200, 30),
                                backgroundColor: colors.primary,
                              ),
                              onPressed: null,
                              child: Text("Loading..."),
                            )
                          ],
                        );
                      }
                      if (snapshot.hasData) {
                        if (snapshot.data!.docs.isNotEmpty) {
                          final List<ClientRequest> _requests = [];
                          for (var doc in snapshot.data!.docs) {
                            final data = doc.data() as Map<String, dynamic>;
                            data['id'] = doc.id;
                            final request = ClientRequest.fromMap(data);
                            _requests.add(request);
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Receiving Request",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Divider(),
                              Text(
                                "Total: ${_requests.length}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  fixedSize: Size(200, 30),
                                  backgroundColor: colors.primary,
                                ),
                                child: Text("View"),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RequestListPage(
                                            requestType: RequestType.receive,
                                            user: widget.user),
                                      ));
                                },
                              )
                            ],
                          );
                        }
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Receiving Request",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Divider(),
                          Text(
                            "Total: --",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(200, 30),
                              backgroundColor: colors.primary,
                            ),
                            onPressed: null,
                            child: Text("No request"),
                          )
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
