import 'package:flutter_with_maps/models/user.dart';

class UserSession {
   static final UserSession _userSession = UserSession._internal();

  factory UserSession() {
    return _userSession;
  }

  UserSession._internal();

  User currentUser;
  String jwtToken;
  bool isLoggedIn = false;
}