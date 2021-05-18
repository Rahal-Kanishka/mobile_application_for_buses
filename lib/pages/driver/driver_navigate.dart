import 'dart:async';
import 'dart:collection';
import 'dart:convert' as convert;
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_with_maps/common/basic_alert.dart';
import 'package:flutter_with_maps/common/user_session.dart';
import 'package:flutter_with_maps/models/DriverPosition.dart';
import 'package:flutter_with_maps/models/DriverProfile.dart';
import 'package:flutter_with_maps/util/common.dart';
import 'package:location/location.dart' as locationPackage;
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_with_maps/models/bus_route.dart';
import 'package:flutter_with_maps/util/backend.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  List<DriverPosition> driverJourneyMarkers = [];
  List<LatLng> driverJourneyPositionMarkers = [];
  Marker driverCurrentLocationMarker;
  Marker driverStartLocationMarker;

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
  BitmapDescriptor busIcon;
  BitmapDescriptor driverStart;
  BitmapDescriptor driverCurrent;
  CameraPosition _cameraPosition = CameraPosition(target: LatLng(6.7881, 79.8913), zoom: 18.0);
  DriverProfile driverProfile;
  String driverID = UserSession().currentUser.id;
  List<StreamSubscription> _subscriptions = [];
  var alertDialog;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    endPoint = GlobalConfiguration().getValue("backend_url");
    // get location access permission from device user
    getDriverDeviceLocationPermission();
    // get driver information from database
    getDriverDetailsAndStartJourney(driverID);
    setSourceAndDestinationIcons();
    // load bus route data from backend
    getRouteAndBusStopsData();
  }

  @override
  void dispose() {
    this.stopDriving();
    super.dispose();
  }

  Future<void> getDriverDetailsAndStartJourney(String driverID) async {
    // find the driver profile
     driverProfile =  (await Common.getDriverProfile(driverID));
     // change journey status in database
     this.changeJourneyStatus(true);
  }

  Future<void> getDriverDeviceLocationPermission() async {
    locationPackage.Location location = new locationPackage.Location();

    bool _serviceEnabled;
    locationPackage.PermissionStatus _permissionGranted;
    locationPackage.LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == locationPackage.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != locationPackage.PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();

    var locationSubscription = location.onLocationChanged
        .listen((locationPackage.LocationData currentLocation) async {
      // Use current location
      print('current location lat: ' +
          currentLocation.latitude.toString() +
          ' lng: ' +
          currentLocation.longitude.toString() +
          ' speed: ' +
          currentLocation.speed.toString() +
          ' accuracy: ' +
          currentLocation.accuracy.toString() +
          ' direction: ' +
          currentLocation.heading.toString());

      //update database with real time location data
      await updateDatabaseWithLocationData(currentLocation, driverID, driverProfile.routeID);

      this.driverJourneyPositionMarkers
          .add(LatLng(currentLocation.latitude, currentLocation.longitude));
      this.driverJourneyMarkers.add(new DriverPosition(
          LatLng(currentLocation.latitude, currentLocation.longitude),
          currentLocation.speed,
          currentLocation.heading));
      setState(() {
        this.plotDriverPath();
      });
    });
    _subscriptions.add(locationSubscription);
  }

  void cancelSubscriptions() {
    _subscriptions.forEach((subscription) {
      subscription.cancel();
    });
  }

  Future updateDatabaseWithLocationData(
      locationPackage.LocationData currentLocation,
      String driverID,
      String routeID) async {
    //update database with real time location data
    Map<String, dynamic> driverLocationDataObject = {
      'driver_id': driverID,
      'route_id': routeID,
      'lat': currentLocation.latitude.toString(),
      'lng': currentLocation.longitude.toString(),
      'speed': currentLocation.speed.toString(),
      'rotation': currentLocation.heading.toString(),
    };
    print('driverData: '+ convert.jsonEncode(driverLocationDataObject));
    BackEndResult backEndResult = await BackEnd.putRequest(
        driverLocationDataObject, '/driver/driver_location');
  }

  void plotDriverPath() {
    // marking started position
    if (driverStartLocationMarker == null) {
      this._markers.add(Marker(
          markerId: MarkerId("driver_start"),
          draggable: false,
          position: this.driverJourneyMarkers[0].position,
          icon: driverStart));
    }

    if (driverCurrentLocationMarker != null) {
      // if marker is already exists, remove it and add a new marker
      this._markers.removeWhere((marker) => marker.markerId == "driver_current_location");
    }
    setState(() {});
    driverCurrentLocationMarker = new Marker(
      markerId: MarkerId("driver_current_location"),
      draggable: false,
      onTap: () {
        print('bus selected');
      },
      position: this.driverJourneyMarkers[this.driverJourneyMarkers.length-1].position,
      infoWindow: InfoWindow(
        title: 'I am Driving',
        snippet: 'speed: ' + this.driverJourneyMarkers[this.driverJourneyMarkers.length-1].speed.toStringAsFixed(3),
      ),
      icon: driverCurrent,
      rotation: this.driverJourneyMarkers[this.driverJourneyMarkers.length-1].rotation
    );
    this._markers.add(driverCurrentLocationMarker);
    Polyline polyline = new Polyline(
        polylineId: new PolylineId("driver_journey"),
        points: this.driverJourneyPositionMarkers,
        geodesic: true,
        width: 5,
        color: Colors.grey
    );
    _polylines.add(polyline);
    setState(() {});
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

    getBytesFromAsset("assets/images/driver_start_edited.bmp", 80).then((onValue) {
      driverStart = BitmapDescriptor.fromBytes(onValue);
    });

    getBytesFromAsset("assets/images/bus_image_edited.bmp", 80).then((onValue) {
      driverCurrent = BitmapDescriptor.fromBytes(onValue);
    });
  }

  void getRouteAndBusStopsData() async {
    Map<String, String> queryParams = {
      'id': '6004830b0027e4132e2cd39a',
    };
    BackEndResult backEndResult = await BackEnd.getRequest('/route/route_by_id', queryParams);
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

  Future<void> stopDriving() async {
    // to stop listening to location change service
    cancelSubscriptions();
    // update database
    await this.changeJourneyStatus(false);
  }

  //update database with start or end of the journey
  changeJourneyStatus(bool journeyStatus) async {
    Map<String, dynamic> driverLocationDataObject = {
      'driver_id': driverID,
      'route_id':  driverProfile.routeID,
      'journey_status': journeyStatus
    };
    print('driverData: '+ convert.jsonEncode(driverLocationDataObject));
    BackEndResult backEndResult = await BackEnd.putRequest(
        driverLocationDataObject, '/driver/journey_status');

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
                mapToolbarEnabled: true,
              )),
        )
      ]),
      floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_home,
          animatedIconTheme: IconThemeData(size: 22.0),
          curve: Curves.bounceIn,
          backgroundColor: Colors.lightBlueAccent,
          children: this.getSpeedDials(context)),
    );
  }

  List<SpeedDialChild> getSpeedDials(BuildContext context) {
    List<SpeedDialChild> speedDials = new List.of([
      SpeedDialChild(
        child: Icon(Icons.cancel, color: Colors.white),
        backgroundColor: Colors.deepOrange,
        onTap: () {
          showEndJourneyConfirmation(context);
        },
        label: 'END Journey',
        labelStyle: TextStyle(fontWeight: FontWeight.w500),
        labelBackgroundColor: Colors.deepOrangeAccent,
      )
    ]);
    return speedDials;
  }

  showEndJourneyConfirmation(BuildContext context) {
    alertDialog = new BasicAlert(
        "END Journey", "Do you want to END the Journey?", "Confirm", "Cancel",
        () async {
      await stopDriving();
      //route to drive start page
      Navigator.pushNamed(context, '/driver');
    }, () {
          // to close the alert dialog
      Navigator.pop(context, true);
    });

    showDialog(
        context: context, builder: (BuildContext context) => alertDialog);
  }
}


