import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

class DriverPosition {

  const DriverPosition(this.position, this.speed, this.rotation);

  final double speed;
  final double rotation;
  final LatLng position;
}