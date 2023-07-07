// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mkulima/models/request.dart';
import 'package:mkulima/models/schedule.dart';
import 'package:mkulima/models/user.dart';
import 'package:mkulima/services/local_services.dart';
import 'package:mkulima/services/request_services.dart';
import 'package:mkulima/theme/colors.dart';
import 'package:mkulima/widgets/app_elevated_button.dart';
import 'package:mkulima/widgets/app_textformfield.dart';
import 'package:mkulima/widgets/pop_up_dialogs.dart';

class RequestForm extends StatefulWidget {
  final User user;
  final DriverSchedule schedule;
  RequestForm({required this.schedule, required this.user});

  @override
  State<RequestForm> createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  final _formKey = GlobalKey<FormState>();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String receiverHint = "receiver";
  String receiverError = "";
  String destination = "";
  String destinationError = "";
  String parcel = "";
  String parcelError = "";
  User? receiver;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: 430,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(color: colors.gray),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Text(
              "Send Request",
              style: TextStyle(
                color: colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: firestore
                  .collection('clients')
                  .where("user_id", isNotEqualTo: widget.user.id)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(5),
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(width: 1.0, color: Color(0xFFF5F7FA)),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 6.18,
                          spreadRadius: 0.618,
                          offset: Offset(-4, -4),
                          color: Color(0xFF929BAB),
                        ),
                        BoxShadow(
                          blurRadius: 6.18,
                          spreadRadius: 0.618,
                          offset: Offset(4, 4),
                          color: Color(0xFF929BAB),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Error: ${snapshot.error}',
                          style: TextStyle(color: colors.gray),
                        ),
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(strokeWidth: 1),
                        )
                      ],
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(5),
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(width: 1.0, color: Color(0xFFF5F7FA)),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 6.18,
                          spreadRadius: 0.618,
                          offset: Offset(-4, -4),
                          color: Color(0xFF929BAB),
                        ),
                        BoxShadow(
                          blurRadius: 6.18,
                          spreadRadius: 0.618,
                          offset: Offset(4, 4),
                          color: Color(0xFF929BAB),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "receiver",
                          style: TextStyle(color: colors.gray),
                        ),
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(strokeWidth: 1),
                        )
                      ],
                    ),
                  );
                }
                if (snapshot.hasData) {
                  if (snapshot.data!.docs.isNotEmpty) {
                    final docs = snapshot.data!.docs;
                    List<User> receivers = [];
                    for (var doc in docs) {
                      final data = doc.data() as Map<String, dynamic>;
                      final _receiver = User.fromMap(data);
                      receivers.add(_receiver);
                    }
                    return _buildReceiverDropDown(
                        receivers: receivers, size: size);
                  }
                  return Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(5),
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(width: 1.0, color: Color(0xFFF5F7FA)),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 6.18,
                          spreadRadius: 0.618,
                          offset: Offset(-4, -4),
                          color: Color(0xFF929BAB),
                        ),
                        BoxShadow(
                          blurRadius: 6.18,
                          spreadRadius: 0.618,
                          offset: Offset(4, 4),
                          color: Color(0xFF929BAB),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "No available receiver",
                          style: TextStyle(color: colors.primary),
                        ),
                        Icon(Icons.error, color: colors.primary)
                      ],
                    ),
                  );
                }
                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(5),
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(width: 1.0, color: Color(0xFFF5F7FA)),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 6.18,
                        spreadRadius: 0.618,
                        offset: Offset(-4, -4),
                        color: Color(0xFF929BAB),
                      ),
                      BoxShadow(
                        blurRadius: 6.18,
                        spreadRadius: 0.618,
                        offset: Offset(4, 4),
                        color: Color(0xFF929BAB),
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "receiver",
                        style: TextStyle(color: colors.gray),
                      ),
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(strokeWidth: 1),
                      )
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            AppTextFormField(
              hintText: "destination",
              color: colors.background,
              errorText: destinationError,
              validator: (value) {
                setState(() {
                  if (value == null || value.isEmpty) {
                    destination = "";
                    destinationError = "this field can not be null";
                  } else {
                    destination = value;
                  }
                });
                return;
              },
            ),
            AppTextFormField(
              hintText: "parcel and size",
              color: colors.background,
              errorText: parcelError,
              validator: (value) {
                setState(() {
                  if (value == null || value.isEmpty) {
                    parcel = "";
                    parcelError = "this field can not be null";
                  } else {
                    parcel = value;
                  }
                });
                return;
              },
            ),
            AppElevatedButton(
              label: "Send",
              onPressed: validateInputs,
            )
          ],
        ),
      ),
    );
  }

  Container _buildReceiverDropDown(
      {required List<User> receivers, required Size size}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(5),
      height: 60,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(width: 1.0, color: Color(0xFFF5F7FA)),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 6.18,
            spreadRadius: 0.618,
            offset: Offset(-4, -4),
            color: Color(0xFF929BAB),
          ),
          BoxShadow(
            blurRadius: 6.18,
            spreadRadius: 0.618,
            offset: Offset(4, 4),
            color: Color(0xFF929BAB),
          )
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<User>(
            iconEnabledColor: Color(0xff3c9efc),
            isExpanded: false,
            hint: Text(
              receiverHint,
              style: TextStyle(color: colors.gray, fontSize: 15),
            ),
            icon: Icon(Icons.arrow_drop_down, color: colors.primary),
            iconSize: 23,
            style: TextStyle(color: colors.gray, fontSize: 15),
            onChanged: (value) {
              setState(() {
                receiverHint = value!.name!;
                receiver = value;
                receiverError = "";
              });
            },
            items: receivers.map((User receiver) {
              return DropdownMenuItem<User>(
                value: receiver,
                child: SizedBox(
                  width: size.width * .31,
                  child: Text(
                    "${receiver.name}",
                    style: TextStyle(color: colors.blue),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  validateInputs() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_formKey.currentState!.validate()) {
      if (receiverError == "" &&
          destinationError == "" &&
          parcelError == "" &&
          receiver != null) {
        _sendRequest();
      }
    }
  }

  _sendRequest() async {
    setState(() {
      isLoading = true;
    });
    try {
      Map<String, dynamic> requestData = {
        "client_id": widget.user.id,
        "destination": destination,
        "parcel": parcel,
        "receiver_id": receiver!.id,
        "schedule_id": widget.schedule.id,
        "start": widget.schedule.start,
        "status": "sent",
        "sender_position": "",
        "receiver_position": "",
        "sender_phone": widget.user.phone,
        "receiver_phone": receiver!.phone,
      };
      final results =
          await requestServices.sendRequest(requestData: requestData);
      if (results is ClientRequest) {
        Navigator.pop(context);
      } else {
        dialog.errorDialog(
            context: context, header: "ERROR!", body: "Failed to send request");
      }
    } catch (e) {
      dialog.errorDialog(
          context: context, header: "ERROR!", body: "Failed to send request");
    }
  }
}
