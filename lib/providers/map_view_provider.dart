import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mkulima/models/journey_info.dart';
import 'package:mkulima/models/schedule.dart';
import 'package:mkulima/services/helper_services.dart';
import 'package:mkulima/utils/enum.dart';

class MapViewProvider extends ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  LatLng? _driverPosition;
  Map<String, dynamic>? _mapErrors;
  late GoogleMapController _googleMapController;
  CameraPosition? _initialCameraPosition;
  bool _isLoading = false;
  String _driverCurrentLocName = "---";

  Set<Marker> _markers = {};
  Map<String, dynamic>? get mapErrors => _mapErrors;

  LatLng? get driverPosition => _driverPosition;
  bool get isLoading => _isLoading;
  String get driverCurrentLocName => _driverCurrentLocName;
  CameraPosition? get initialCameraPosition => _initialCameraPosition;
  GoogleMapController get googleMapController => _googleMapController;
  Set<Marker> get markers => _markers;

  MapViewProvider(context) {
    determinePosition(context);
  }

  changeDriverPosition(LatLng position) async {
    _driverPosition = position;
    _driverCurrentLocName = await helper.getLocationName(location: position);
    notifyListeners();
  }

  journeyProgressListener(
      {required JourneyInfo journey, required RequestType requestType}) async {
    print("---------------------->${journey.schedule!.id}");
    firestore
        .collection('schedules')
        .doc(journey.schedule!.id)
        .snapshots()
        .listen(
      (snapshot) {
        if (snapshot.data() != null) {
          final scheduleMap = snapshot.data();
          print("Checking Driver info:${snapshot.data()}");
          _driverPosition =
              helper.locStrToLatLng(position: scheduleMap!['driver_position']);
          _markers.removeWhere((m) => m.markerId.value == "driver_position");
          _addMarker(_driverPosition!, "driver_position",
              icon: BitmapDescriptor.defaultMarker,
              markerId: "driver_position");
          notifyListeners();
        }
      },
      onError: (error) {},
    );
    firestore
        .collection('requests')
        .doc(journey.request!.id)
        .snapshots()
        .listen(
      (snapshot) {
        if (snapshot.data() != null) {
          final requestMap = snapshot.data();
          print("Checking Client info:$requestMap");
          LatLng? position =
              helper.locStrToLatLng(position: requestMap!['sender_position']);

          if (requestType == RequestType.receive) {
            position = helper.locStrToLatLng(
                position: requestMap['receiver_position']);
          }
          if (position != null) {
            _markers.removeWhere((m) => m.markerId.value == "client_position");

            _addMarker(position, "$position", markerId: "client_position");
          }
          notifyListeners();
        }
      },
      onError: (error) {},
    );
  }

  updateUserPositionOnMap(
      {required JourneyInfo journey, required RequestType requestType}) async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      DocumentReference scheduleDoc = FirebaseFirestore.instance
          .collection('requests')
          .doc(journey.request!.id);

      await scheduleDoc.update({
        requestType == RequestType.send
            ? 'sender_position'
            : "receiver_position": '${position.latitude},${position.longitude}'
      });

      print('Request-------Document updated successfully');
    } catch (e, stack) {
      print('Error: $e');
      print('Error: $stack');
      _isLoading = false;
    }

    notifyListeners();
    return;
  }

  initMap(JourneyInfo journey) async {
    _isLoading = true;
    notifyListeners();
    _initialCameraPosition =
        CameraPosition(target: journey.driverPosition!, zoom: 14);
    _addMarker(journey.driverPosition!, "driver_position",
        icon: BitmapDescriptor.defaultMarker, markerId: "driver_position");
    if (journey.clientPosition != null) {
      _addMarker(journey.clientPosition!, "${journey.clientPosition!}",
          markerId: "client_position");
    }
    _isLoading = false;
    notifyListeners();
  }

  onCreated(GoogleMapController controller) {
    _googleMapController = controller;
    notifyListeners();
  }

  void onCamerMove(CameraPosition position) {
    // _driverPosition = position.target;
    // notifyListeners();
  }

  void _addMarker(LatLng location, String address,
      {BitmapDescriptor? icon, String? markerId}) {
    _markers.add(Marker(
      markerId: MarkerId(markerId ?? location.toString()),
      position: location,
      infoWindow: InfoWindow(title: "Pickup Location", snippet: address),
      icon: icon ??
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    ));
  }

  Future determinePosition(context) async {
    _isLoading = true;
    notifyListeners();
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _mapErrors = {
        "header": "Location Disabled",
        "msg": "Enable location services to continue"
      };
      _isLoading = false;
      notifyListeners();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _mapErrors = {
          "header": "Location Denied",
          "msg": "Enable app to access location in settings"
        };
        _isLoading = false;
        notifyListeners();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _mapErrors = {
        "header": "Location Denied",
        "msg":
            "Location permissions are permanently denied, we cannot request permissions."
      };
      _isLoading = false;
      notifyListeners();
      return;
    }
    // final position = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.high);

    // _driverPosition = LatLng(position.latitude, position.longitude);
    // _initialCameraPosition =
    //     CameraPosition(target: _driverPosition!, zoom: 11.5);
    _isLoading = false;
    _mapErrors = null;
    notifyListeners();
  }
}
