
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BusRoute {
  final String routeNumber;
  final LatLng start;
  final LatLng end;
  final int journeyStep; // 1 - first trip
  final Map<int, List<LatLng>>
  busStations; // index 1 - bus halts on 1st journey

  BusRoute(this.routeNumber, this.start, this.end, this.journeyStep,
      this.busStations);
}