import 'package:flutter_with_maps/models/UserType.dart';

class User {
  String id,
      firstName,
      lastName,
      email,
      address,
      contact,
      password,
      confirmPassword;

  UserType type;

  User([this.id, this.firstName, this.lastName, this.email, this.address, this.contact,
      this.type,
      this.password, this.confirmPassword]);

  factory User.fromJson(dynamic json) {
    if (json != null) {
      return User(
          json['_id'] as String,
          json['firstName'] as String,
          json['lastName'] as String,
          json['userName'] as String,
          json['address'] as String,
          json['contact'] as String,
          UserType.fromJson(json['type']));
    } else {
      return User(null, null, null, null, null, null);
    }
  }
}
