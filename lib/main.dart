import 'dart:async';
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

class BusRoute {
  final String routeNumber;
  final List<LatLng> busStations;

  BusRoute(this.routeNumber, this.busStations);
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
  List<BusRoute> busRoutesList = <BusRoute>[
    BusRoute('100 Panadura - Pettah', [LatLng(6.927685, 79.843284)]),
    BusRoute('101 Moratuwa - Pettah', [LatLng(6.796744, 79.888338)]),
    BusRoute('154 Kiribathgoda - Agulana', [LatLng(6.796744, 79.888338), LatLng(6.927685, 79.843284)])
  ];

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
  }

  void updateMarker(BusRoute busRoute) {
    markersList = [];
    for (var i = 0; i < busRoute.busStations.length; i++) {
      markersList.add(Marker(
        markerId: MarkerId(busRoute.routeNumber +' '+ i.toString()),
        draggable: false,
        onTap: () {
          print('bus holt selected');
        },
        position: busRoute.busStations[i],
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
