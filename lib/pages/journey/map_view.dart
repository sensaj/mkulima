// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mkulima/models/journey_info.dart';
import 'package:mkulima/providers/map_view_provider.dart';
import 'package:mkulima/utils/enum.dart';
import 'package:mkulima/widgets/app_elevated_button.dart';

class MapView extends StatefulWidget {
  final JourneyInfo journey;
  final MapViewProvider mapState;
  final RequestType requestType;
  MapView(
      {required this.journey,
      required this.mapState,
      required this.requestType});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  LatLng? _initialPosition;
  late Timer timer;
  late MapViewProvider mapState;
  @override
  void initState() {
    super.initState();
    mapState = widget.mapState;
    mapState.changeDriverPosition(widget.journey.driverPosition!);
    mapState.journeyProgressListener(
        journey: widget.journey, requestType: widget.requestType);
    Future.delayed(
      Duration(seconds: 5),
      () {
        mapState.initMap(widget.journey);
      },
    );
    timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      await mapState.updateUserPositionOnMap(
          journey: widget.journey, requestType: widget.requestType);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height - 157,
      alignment: Alignment.center,
      child: mapState.isLoading
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Preparing map...",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            )
          : mapState.mapErrors != null
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.sentiment_neutral,
                      color: CupertinoColors.white,
                      size: 41,
                    ),
                    Text(
                      mapState.mapErrors!['header'],
                      style: TextStyle(
                        color: CupertinoColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      mapState.mapErrors!['msg'],
                      style:
                          TextStyle(color: CupertinoColors.white, fontSize: 13),
                    ),
                    SizedBox(
                      width: 200,
                      child: AppElevatedButton(
                        label: "Retry",
                        onPressed: () {
                          mapState.determinePosition(context);
                        },
                      ),
                    ),
                  ],
                )
              : mapState.initialCameraPosition == null
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 30,
                            height: 30,
                            child:
                                CircularProgressIndicator(color: Colors.white),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Preparing map...",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    )
                  : GoogleMap(
                      initialCameraPosition: mapState.initialCameraPosition!,
                      myLocationButtonEnabled: true,
                      myLocationEnabled: true,
                      compassEnabled: true,
                      markers: mapState.markers,
                      onMapCreated: mapState.onCreated,
                    ),
    );
  }
}
