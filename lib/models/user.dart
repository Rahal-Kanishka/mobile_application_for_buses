import 'package:flutter_with_maps/models/UserType.dart';

class User {
  String firstName,
      lastName,
      email,
      address,
      contact,
      password,
      confirmPassword;

  UserType type;

  User(
      {this.firstName,
      this.lastName,
      this.email,
      this.address,
      this.contact,
      this.type,
      this.password,
      this.confirmPassword});
}
