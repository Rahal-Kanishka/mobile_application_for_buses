import 'package:flutter_with_maps/models/user.dart';

/// Drive with Profile data and related user data
class DriverPopulatedDetail {
  User userBasicInfo;
  String routeID, rating, maxRatings;
  int trips;

  DriverPopulatedDetail(this.userBasicInfo, this.routeID, this.rating,
      this.maxRatings, this.trips);

  factory DriverPopulatedDetail.fromJson(dynamic json) {
    if (json != null) {
      return DriverPopulatedDetail(
          User.fromJson(json['driver_id']),
          json['route_id'],
          json['max_ratings'],
          json['rating'],
          json['trips'] as int);
    } else {
      return DriverPopulatedDetail(null, null, null, null, null);
    }
  }
}
