import 'package:mkulima/services/helper_services.dart';

class DriverSchedule {
  String? id;
  String? start;
  String? via;
  String? destination;
  String? date;
  String? beautyDate;
  String? space;
  String? status;
  String? driver;

  DriverSchedule({
    this.date,
    this.destination,
    this.driver,
    this.id,
    this.space,
    this.start,
    this.via,
    this.status,
    this.beautyDate,
  });

  factory DriverSchedule.fromMap(Map<String, dynamic> map) {
    return DriverSchedule(
      id: map['id'],
      date: map['date'],
      start: map['start'],
      via: map['via'],
      destination: map['destination'],
      space: map['space'],
      status: map['status'],
      driver: map['driver_id'],
      beautyDate: DateTime.tryParse(map['date']) == null
          ? map['date']
          : helper.beautifyDate(DateTime.parse(map['date'])),
    );
  }

  factory DriverSchedule.fromJson(Map<String, dynamic> json) {
    return DriverSchedule(
      id: json['id'],
      date: json['date'],
      via: json['via'],
      start: json['start'],
      destination: json['destination'],
      space: json['space'],
      status: json['status'],
      driver: json['driver_id'],
      beautyDate: helper.beautifyDate(DateTime.parse(json['date'])),
    );
  }
}
