import 'package:flutter_with_maps/models/DriverProfile.dart';

class Favourite {

  String createdOn, _id;
  DriverProfile driverProfile;

  Favourite(this.createdOn, this._id, this.driverProfile);

  factory Favourite.fromJson(dynamic json) {
    if (json != null) {
      return Favourite(
          json['created_on'] as String,
          json['_id'] as String,
          DriverProfile.fromJson(json['driver_id'])
      );
    } else {
      return Favourite(null, null, null);
    }
  }
}