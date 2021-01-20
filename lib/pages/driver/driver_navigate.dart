import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_with_maps/models/bus_route.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission/permission.dart';
import 'package:http/http.dart' as http;
import 'package:global_configuration/global_configuration.dart';

class DriverNavigation extends StatefulWidget {
  @override
  _DriverNavigationState createState() => _DriverNavigationState();
}

class _DriverNavigationState extends State<DriverNavigation> {
  List<Marker> markersList = [];
  List<LatLng> routeCoords = [];
  final Set<Polyline> polyLine = {};
  GoogleMapPolyline googleMapPolyline =
  new GoogleMapPolyline(apiKey: GlobalConfiguration().getValue("api_key"));
  GoogleMapController _controller;
  BusRoute selectedBusRoute;

  // drivers bus station stops
  Map<int, List<LatLng>> busStations = new HashMap<int, List<LatLng>>();
  List<BusRoute> busRoutesList = [];
  String endPoint;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    endPoint = GlobalConfiguration().getValue("backend_url");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Driver Navigation'),
        centerTitle: true,
      ),
    );
  }
}
