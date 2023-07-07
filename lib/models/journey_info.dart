import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mkulima/models/request.dart';
import 'package:mkulima/models/schedule.dart';
import 'package:mkulima/services/helper_services.dart';

class JourneyInfo {
  String? id;
  ClientRequest? request;
  DriverSchedule? schedule;
  String? status;
  String? clientPhone;
  String? driverPhone;
  LatLng? driverPosition;
  LatLng? clientPosition;

  JourneyInfo({
    this.clientPosition,
    this.driverPosition,
    this.id,
    this.request,
    this.schedule,
    this.status,
    this.clientPhone,
    this.driverPhone,
  });

  factory JourneyInfo.fromMap(Map<String, dynamic> map) {
    return JourneyInfo(
      id: map['id'],
      request: ClientRequest.fromMap(map['request']),
      schedule: DriverSchedule.fromMap(map['schedule']),
      clientPosition: helper.locStrToLatLng(position: map['client_position']),
      driverPosition: helper.locStrToLatLng(position: map['driver_position']),
      status: map['status'],
      clientPhone: map['client_phone'],
      driverPhone: map['driver_phone'],
    );
  }

  factory JourneyInfo.fromJson(Map<String, dynamic> json) {
    return JourneyInfo(
      id: json['id'],
      request: ClientRequest.fromMap(json['request']),
      schedule: DriverSchedule.fromMap(json['schedule']),
      clientPosition: helper.locStrToLatLng(position: json['client_position']),
      driverPosition: helper.locStrToLatLng(position: json['driver_position']),
      status: json['status'],
      clientPhone: json['client_phone'],
      driverPhone: json['driver_phone'],
    );
  }
}
