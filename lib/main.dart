import 'dart:async';
import 'dart:collection';
// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission/permission.dart';

void main() {
  runApp(MaterialApp(
    home: HomeWidget(),
  ));
}

class Destination {
  final LatLng location;
  final String name;

  Destination(this.location, this.name);
}
class BusRoute {
  final String routeNumber;
  final LatLng start;
  final LatLng end;
  final int journeyStep; // 1 - first trip
  final Map< int, List<LatLng>> busStations; // index 1 - bus halts on 1st journey

  BusRoute(this.routeNumber, this.start, this.end, this.journeyStep, this.busStations);
}

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  List<Marker> markersList = [];
  List<LatLng> routeCoords = [];
  final Set<Polyline> polyLine = {};
  GoogleMapPolyline googleMapPolyline =
      new GoogleMapPolyline(apiKey: "AIzaSyDAOFWzuosZPkQZ6m4tFCUqzBtO1rVRAH4");
  GoogleMapController _controller;
  BusRoute selectedBusRoute;
  // 154
  Map< int, List<LatLng>> busStations_154 = new HashMap<int, List<LatLng>>();
  Map< int, List<LatLng>> busStations_100 = new HashMap<int, List<LatLng>>();
  Map< int, List<LatLng>> busStations_101 = new HashMap<int, List<LatLng>>();
  List<BusRoute> busRoutesList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    markersList.add(Marker(
      markerId: MarkerId(
        'Katubeddha busholt',
      ),
      draggable: false,
      onTap: () {
        print('bus holt selected');
      },
      position: LatLng(6.796744, 79.888338),
      infoWindow: InfoWindow(
        title: 'Bus Halt',
        snippet: '101, 100, 2',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
    ));
    getSomePoints();
    // initiate data
    busStations_100[1] = [LatLng(6.716216, 79.907538),LatLng(6.724812, 79.906620), LatLng(6.750239, 79.900306)]; // Panadura to Pettah
    busStations_100[2] = [LatLng(6.9671920, 79.894041),LatLng(6.967234, 79.900681), LatLng(6.974128, 79.921958)]; // Pettah to Panadura
    busStations_101[1] = [LatLng(6.780459, 79.883247),LatLng(6.790203, 79.885856), LatLng(6.8333174, 79.867266)]; // Moratuwa to Pettah
    busStations_101[2] = [LatLng(6.9671920, 79.894041),LatLng(6.967234, 79.900681), LatLng(6.974128, 79.921958)]; // Pettah to Moratuwa
    busStations_154[1] = [LatLng(6.967194, 79.906330),LatLng(6.967110, 79.900765), LatLng(6.961823, 79.894262)]; // kiribathgoda to Agulana
    busStations_154[2] = [LatLng(6.9671920, 79.894041),LatLng(6.967234, 79.900681), LatLng(6.974128, 79.921958)]; // Agulana to kiribathgoda
    BusRoute busRoute_154 = new BusRoute('154 Kiribathgoda - Agulana', LatLng(6.979248, 79.930212), LatLng(6.804479, 79.886325), 1, busStations_154);
    BusRoute busRoute_100 = new BusRoute('100 Panadura - Pettah', LatLng(6.711797, 79.907597), LatLng(6.933934, 79.850132), 1, busStations_100);
    BusRoute busRoute_101 = new BusRoute('101 Moratuwa - Pettah', LatLng(6.774401, 79.882734), LatLng(6.933934, 79.850132), 1, busStations_101);
    busRoutesList = [busRoute_100,busRoute_101,busRoute_154];
  }

  void updateMarker(BusRoute busRoute) {
    markersList = [];
    // add start and end bus station markers in different color
    markersList.add(Marker(
      markerId: MarkerId(busRoute.routeNumber +' start'),
      draggable: false,
      onTap: () {
        print('bus holt selected');
      },
      position: busRoute.start,
      infoWindow: InfoWindow(
        title: busRoute.routeNumber + ' Bus Start Station',
        snippet: '101, 100, 2',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    ));
    // end
    markersList.add(Marker(
      markerId: MarkerId(busRoute.routeNumber +' end'),
      draggable: false,
      onTap: () {
        print('bus holt selected');
      },
      position: busRoute.end,
      infoWindow: InfoWindow(
        title: busRoute.routeNumber + ' Bus End Station',
        snippet: '101, 100, 2',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    ));
    // add markers for bus halts on the road
    for (var i = 0; i < busRoute.busStations[busRoute.journeyStep].length; i++) {
      markersList.add(Marker(
        markerId: MarkerId(busRoute.routeNumber +' '+ i.toString()),
        draggable: false,
        onTap: () {
          print('bus holt selected');
        },
        position: busRoute.busStations[busRoute.journeyStep][i],
        infoWindow: InfoWindow(
          title: busRoute.routeNumber + ' Bus Halt',
          snippet: '101, 100, 2',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
      ));
    }
  }

  getSomePoints() async {
    var permissions =
        await Permission.getPermissionsStatus([PermissionName.Location]);
    if (permissions[0].permissionStatus == PermissionStatus.notAgain) {
      var askPermissions =
          await Permission.requestPermissions([PermissionName.Location]);
    } else {
      routeCoords = await googleMapPolyline.getCoordinatesWithLocation(
          origin: LatLng(6.927685, 79.843284),
          destination: LatLng(6.796744, 79.888338),
          mode: RouteMode.driving);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Flutter with maps',
          style: TextStyle(letterSpacing: 2.0, fontFamily: 'IndieFlower'),
        ),
        centerTitle: true,
      ),
      body: Column(children: [
        new DropdownButton<BusRoute>(
          hint: new Text("Select a Route"),
          value: selectedBusRoute,
          onChanged: (BusRoute newValue) {
            setState(() {
              selectedBusRoute = newValue;
              // update bus halts in the map
              updateMarker(newValue);
            });
          },
          items: busRoutesList.map((BusRoute value) {
            return new DropdownMenuItem<BusRoute>(
              value: value,
              child: new Text(value.routeNumber,
                  style: new TextStyle(color: Colors.black)),
            );
          }).toList(),
        ),
        Expanded(
          child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                onMapCreated: onMapCreated,
                polylines: polyLine,
                initialCameraPosition:
                    CameraPosition(target: LatLng(6.7881, 79.8913), zoom: 12.0),
                markers: Set.from(markersList),
                mapType: MapType.normal,
              )),
        )
      ]),
    );
  }

  void onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller = controller;

      polyLine.add(Polyline(
          polylineId: PolylineId('route1'),
          visible: true,
          points: routeCoords,
          width: 4,
          color: Colors.blue,
          startCap: Cap.roundCap,
          endCap: Cap.buttCap));
    });
  }
}
