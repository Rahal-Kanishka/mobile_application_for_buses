
import 'dart:ffi';

class DriverProfile {

  String driverID, rating, maxRatings;
  int trips;

  DriverProfile(this.trips, this.driverID, this.rating, this.maxRatings);

  factory DriverProfile.fromJson(dynamic json) {
    if (json != null) {
      return DriverProfile(json['trips'] as int,json['driver_id'] as String,json['rating'] as String,json['max_ratings'] as String,);
    } else {
      return DriverProfile(null, null, null, null);
    }
  }
}