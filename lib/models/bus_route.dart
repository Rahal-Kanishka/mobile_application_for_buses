
import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class Trip {
  List<LatLng> stops; // bus stops
  List<LatLng> routes; // route markers (driving path)

  Trip(this.stops,this.routes);

  factory Trip.fromJson(dynamic json) {
    if (json != null) {
      var stopObjsJson = (json)['stops'] as List<dynamic>;
      var routeObjsJson = (json)['route'] as List<dynamic>;
      List<LatLng> stopObjects =
          stopObjsJson.map((stopJson) => LatLng(stopJson['lat'],stopJson['lng']),).toList();
      List<LatLng> routeObjects =
          routeObjsJson.map((routeJson) => LatLng(routeJson['lat'],routeJson['lng'] == null ? 0.000 : routeJson['lng'] )).toList();
      return Trip(stopObjects, routeObjects);
    } else {
      return Trip(null, null);
    }
  }

}

class BusRoute {
  final String routeID;
  final String routeName;
  final String routeNumber;
  final LatLng start;
  final LatLng end;
  final int journeyStep; // 1 - first trip
  Trip firstTrip;
  Trip secondTrip;

  BusRoute(this.routeID,this.routeName,this.routeNumber, this.start, this.end, this.journeyStep,
      this.firstTrip, this.secondTrip);

  factory BusRoute.fromJson(dynamic json) {
    if (json != null) {
      return BusRoute(
          json['_id'] as String,
          json['name'] as String,
          json['number'] as String,
          LatLng(json['start_location']['lat'],json['start_location']['lng']),
          LatLng(json['end_location']['lat'],json['end_location']['lng']),
          1,
          Trip.fromJson(json['first_trip']),
          Trip.fromJson(null)
      );
    } else {
      return BusRoute(null, null, null, null, null, null, null, null);
    }
  }

}