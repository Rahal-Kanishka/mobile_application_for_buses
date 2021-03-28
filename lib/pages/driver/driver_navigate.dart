import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_with_maps/models/bus_route.dart';
import 'package:flutter_with_maps/util/backend.dart';
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
  BusRoute selectedBusRoute;
  BusRoute busRoute;

  // drivers bus station stops
  Map<int, List<LatLng>> busStations = new HashMap<int, List<LatLng>>();
  List<BusRoute> busRoutesList = [];
  String endPoint;

  // tutorial
  Completer<GoogleMapController> _controller = Completer();
  // this set will hold my markers
  Set<Marker> _markers = {};// this will hold the generated polylines
  Set<Polyline> _polylines = {};
  // this will hold each polyline coordinate as Lat and Lng pairs
  List<LatLng> polylineCoordinates = [];// this is the key object - the PolylinePoints
// which generates every polyline between start and finish
  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;
  BitmapDescriptor halt;
  CameraPosition _cameraPosition = CameraPosition(target: LatLng(6.7881, 79.8913), zoom: 18.0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    endPoint = GlobalConfiguration().getValue("backend_url");

    setSourceAndDestinationIcons();
    // load bus route data from backend
    getRouteAndBusStopsData();
  }

  void setSourceAndDestinationIcons() async {
    getBytesFromAsset("assets/images/bus_start_2.png", 100).then((onValue) {
     sourceIcon = BitmapDescriptor.fromBytes(onValue);
    });
    getBytesFromAsset("assets/images/destination_edited.bmp", 100).then((onValue) {
      destinationIcon = BitmapDescriptor.fromBytes(onValue);
    });

    getBytesFromAsset("assets/images/bus_halt.bmp", 80).then((onValue) {
      halt = BitmapDescriptor.fromBytes(onValue);
    });
  }

  void getRouteAndBusStopsData() async {
    BackEndResult backEndResult = await BackEnd.getRequest('/route/100 Moratuwa Pettah');
    int count = 0;
    if (backEndResult.statusCode == 200) {
      this.busRoute = BusRoute.fromJson(backEndResult.responseBody);
      // setting up start position
      setState(() {
        _markers.add(Marker(
            markerId: MarkerId("sourcePin"),
            position: this.busRoute.start,
            icon: sourceIcon));
        _markers.add(Marker(
            markerId: MarkerId("destPin"),
            position: this.busRoute.end,
            icon: destinationIcon));
        //setting up bus halts
        for (var stop in this.busRoute.firstTrip.stops) {
          this._markers.add(
              Marker(markerId: MarkerId("holt" + count.toString()), position: stop, icon: halt));
          count++;
        }

        // setting up the bus route
        Polyline polyline = new Polyline(
            polylineId: new PolylineId("1"),
            points: this.busRoute.firstTrip.routes,
            geodesic: true,
            width: 5,
            color: Colors.blue
        );
        _polylines.add(polyline);
        //setup initial camera position
        _cameraPosition = CameraPosition(target: this.busRoute.start, zoom: 18.0);
      });
    }
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png)).buffer.asUint8List();
  }

  void onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    setState(() {
      setMapPins();
     // setPolyLines();
    });
  }

  void setMapPins() {
    // source pin
    /*_markers.add(Marker(
        markerId: MarkerId("sourcePin"),
        position: LatLng(6.975531, 79.924400),
        icon: sourceIcon)); // destination pin
    _markers.add(Marker(
        markerId: MarkerId("destPin"),
        position: LatLng(6.944697, 79.878116),
        icon: destinationIcon));
    _markers.add(Marker(
        markerId: MarkerId("holt_1"),
        position: LatLng(6.969306, 79.912190),
        icon: halt));*/
  }

  void setPolyLines() {
    const busCoordinates = [
      LatLng(6.975531, 79.924400),
      LatLng(6.974700, 79.922938),
      LatLng(6.969306, 79.912190),
      LatLng(6.944697, 79.878116),
    ];
    Polyline polyline = new Polyline(
      polylineId: new PolylineId("1"),
      points: busCoordinates,
      geodesic: true,
      width: 5,
      color: Colors.blue
    );
    _polylines.add(polyline);
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Driver Navigation'),
        centerTitle: true,
      ),
      body: Column(children: [
        Expanded(
          child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                padding: EdgeInsets.only(bottom: 80, right: 10),
                onMapCreated: onMapCreated,
                polylines: _polylines,
                initialCameraPosition: _cameraPosition,
                markers: _markers,
                mapType: MapType.normal,
              )),
        )
      ]),
    );
  }
}
