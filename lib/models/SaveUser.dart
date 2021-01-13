import 'package:flutter_with_maps/models/UserType.dart';

class SaveUser {
  String firstName,
      lastName,
      email,
      address,
      contact,
      password,
      confirmPassword;

  UserType type;

  SaveUser(
      {this.firstName,
      this.lastName,
      this.email,
      this.address,
      this.contact,
      this.type,
      this.password,
      this.confirmPassword});
}
