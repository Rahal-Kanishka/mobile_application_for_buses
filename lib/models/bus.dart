import 'package:flutter/material.dart';

class Bus {
  String _id, route, vehicleNo, registeredDate;
  int capacity;

  Bus(String _id, String route, String vehicleNo, String registeredDate,
      int capacity) {
    this._id = _id;
    this.route = route;
    this.vehicleNo = vehicleNo;
    this.registeredDate = registeredDate;
    this.capacity = capacity;
  }

  factory Bus.fromJson(dynamic json) {
    if (json != null) {
      return Bus(
          json['_id'] as String,
          json['route'] as String,
          json['vehicleNo'] as String,
          json['registeredDate'] as String,
          json['capacity'] as int);
    } else {
      return Bus(null, null, null, null, 0);
    }
  }
}
