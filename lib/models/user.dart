class User {
  String? id;
  String? name;
  String? location;
  String? phone;
  User({this.id, this.phone, this.location, this.name});

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['user_id'],
      phone: map['phone'],
      location: map['location'],
      name: map['name'],
    );
  }
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user_id'],
      phone: json['phone'],
      location: json['location'],
      name: json['name'],
    );
  }
}
