import 'package:flutter/material.dart';

class UserType {
  const UserType(this.typeName, [this.typeIcon]);

  final String typeName;
  final Icon typeIcon;

  factory UserType.fromJson(dynamic json) {
    if (json != null) {
      return UserType(json['name'] as String);
    } else {
      return UserType(null);
    }
  }
}
