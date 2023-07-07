class ClientRequest {
  String? id;
  String? destination;
  String? parcel;
  String? client;
  String? receiver;
  String? start;
  String? status;
  String? schedule;

  ClientRequest({
    this.destination,
    this.id,
    this.parcel,
    this.receiver,
    this.schedule,
    this.start,
    this.status,
    this.client,
  });

  factory ClientRequest.fromMap(Map<String, dynamic> map) {
    return ClientRequest(
      id: map['id'],
      parcel: map['parcel'],
      start: map['start'],
      receiver: map['receiver_id'],
      client: map['client_id'],
      destination: map['destination'],
      schedule: map['schedule_id'],
      status: map['status'],
    );
  }

  factory ClientRequest.fromJson(Map<String, dynamic> json) {
    return ClientRequest(
      id: json['id'],
      parcel: json['parcel'],
      start: json['start'],
      client: json['client_id'],
      receiver: json['receiver_id'],
      destination: json['destination'],
      schedule: json['schedule_id'],
      status: json['status'],
    );
  }
}
