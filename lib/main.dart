import 'dart:async';
import 'dart:collection';
// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_with_maps/common/user_session.dart';
import 'package:flutter_with_maps/models/DriverProfile.dart';
import 'package:flutter_with_maps/models/user.dart';
import 'package:flutter_with_maps/pages/about_us.dart';
import 'package:flutter_with_maps/pages/bus_selection.dart';
import 'package:flutter_with_maps/pages/complaint.dart';
import 'package:flutter_with_maps/pages/driver/driver_home.dart';
import 'package:flutter_with_maps/pages/driver/driver_navigate.dart';
import 'package:flutter_with_maps/pages/login.dart';
import 'package:flutter_with_maps/pages/register.dart';
import 'package:flutter_with_maps/pages/user/userPanel.dart';
import 'package:flutter_with_maps/pages/user_profile.dart' as UserProfile;
import 'package:flutter_with_maps/pages/welcome.dart';
import 'package:flutter_with_maps/util/backend.dart';
import 'package:flutter_with_maps/util/common.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission/permission.dart';
import 'package:http/http.dart' as http;
import 'package:global_configuration/global_configuration.dart';

import 'common/basic_alert.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    var json = await GlobalConfiguration()
        .loadFromPath('assets/cfg/configurations.json');
    print(json);
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/welcome',
      routes: {
        '/home': (context) => HomeWidget(),
        '/welcome': (context) => Welcome(),
        '/driver': (context) => DriverHome(),
        '/complaint': (context) => Complaint(),
        '/user': (context) => UserProfile.UserProfile(),
        '/login': (context) => Login(),
        '/register': (context) => Register(),
        '/select_bus': (context) => BusSelection(),
        '/user_panel': (context) => UserPanel(),
        '/driver_navigate': (context) => DriverNavigation(),
        '/about_us': (context) => AboutUs(),
      },
    ));
  } catch (e) {
    throw Exception(e.toString());
  }
}

class Destination {
  final LatLng location;
  final String name;

  Destination(this.location, this.name);
}

class BusRoute {
  final String id;
  final String routeNumber;
  final LatLng start;
  final LatLng end;
  final int journeyStep; // 1 - first trip
  final Map<int, List<LatLng>>
      busStations; // index 1 - bus halts on 1st journey

  BusRoute(this.id, this.routeNumber, this.start, this.end, this.journeyStep,
      this.busStations);
}

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  List<Marker> markersList = [];
  List<LatLng> routeCoords = [];
  List<LatLng> driverJourneyMarkersList = [];
  final Set<Polyline> polyLine = {};
  GoogleMapPolyline googleMapPolyline =
      new GoogleMapPolyline(apiKey: GlobalConfiguration().getValue("api_key"));
  GoogleMapController _controller;
  BusRoute selectedBusRoute;
  Timer timer;
  var alertDialog;
  Marker driverMarker;
  BitmapDescriptor driverIcon;

  // 154
  Map<int, List<LatLng>> busStations_154 = new HashMap<int, List<LatLng>>();
  Map<int, List<LatLng>> busStations_100 = new HashMap<int, List<LatLng>>();
  Map<int, List<LatLng>> busStations_101 = new HashMap<int, List<LatLng>>();
  List<BusRoute> busRoutesList = [];
  String endPoint;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Common.getBytesFromAsset("assets/images/bus_start_2.png", 100).then((onValue) {
      driverIcon = BitmapDescriptor.fromBytes(onValue);
    });
    markersList.add(Marker(
      markerId: MarkerId(
        'Katubeddha bus-halt',
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
    endPoint = GlobalConfiguration().getValue("backend_url");
    // initiate data
    busStations_100[1] = [
      LatLng(6.716216, 79.907538),
      LatLng(6.724812, 79.906620),
      LatLng(6.750239, 79.900306)
    ]; // Panadura to Pettah
    busStations_100[2] = [
      LatLng(6.9671920, 79.894041),
      LatLng(6.967234, 79.900681),
      LatLng(6.974128, 79.921958)
    ]; // Pettah to Panadura
    busStations_101[1] = [
      LatLng(6.780459, 79.883247),
      LatLng(6.790203, 79.885856),
      LatLng(6.8333174, 79.867266)
    ]; // Moratuwa to Pettah
    busStations_101[2] = [
      LatLng(6.9671920, 79.894041),
      LatLng(6.967234, 79.900681),
      LatLng(6.974128, 79.921958)
    ]; // Pettah to Moratuwa
    busStations_154[1] = [
      LatLng(6.967194, 79.906330),
      LatLng(6.967110, 79.900765),
      LatLng(6.961823, 79.894262)
    ]; // kiribathgoda to Agulana
    busStations_154[2] = [
      LatLng(6.9671920, 79.894041),
      LatLng(6.967234, 79.900681),
      LatLng(6.974128, 79.921958)
    ]; // Agulana to kiribathgoda
    BusRoute busRoute_154 = new BusRoute(
        null,
        '154 Kiribathgoda - Agulana',
        LatLng(6.979248, 79.930212),
        LatLng(6.804479, 79.886325),
        1,
        busStations_154);
    BusRoute busRoute_100 = new BusRoute(
        '6004830b0027e4132e2cd39a',
        '100 Panadura - Pettah',
        LatLng(6.711797, 79.907597),
        LatLng(6.933934, 79.850132),
        1,
        busStations_100);
    BusRoute busRoute_101 = new BusRoute(
        '6008f9a8986ab2208f701dd3',
        '101 Moratuwa - Pettah',
        LatLng(6.774401, 79.882734),
        LatLng(6.933934, 79.850132),
        1,
        busStations_101);
    busRoutesList = [busRoute_100, busRoute_101, busRoute_154];
  }

  void dispose() {
    super.dispose();
    if (timer != null) {
      timer.cancel();
    }
  }

  Future<void> updateDriverLocation(BuildContext context, String routeID) async {
    int count = 0;
    driverJourneyMarkersList = [];
    // get driver profile data
    String driverID = "606aae33085ad53d3c6f9097";
    Map<String, String> driverProfileQueryParams = {
      'driver_id': driverID
    };
    BackEndResult driverProfileData =
    await BackEnd.getRequest('/driver/driver_profile', driverProfileQueryParams);
    DriverProfile driverProfile = DriverProfile.fromJson(driverProfileData.responseBody);
    User driverUser =  (await Common.getUserDetails(driverID));
    setState(() {});
    if (timer != null) {
      timer.cancel(); // close existing time calls
    } else {
      timer = Timer.periodic(Duration(seconds: 15),
          (Timer t) => getDriverRealTimeLocation(
            count++, context, routeID, driverProfile, driverUser));
    }
  }

  Future<void> getDriverRealTimeLocation(
      int count, BuildContext context, String routeID,
      DriverProfile driverProfile, User driverUser) async {
    Map<String, String> queryParams = {
      'route_id': routeID,
      'count': count.toString(),
    };
    BackEndResult backEndResult =
        await BackEnd.getRequest('/driver/driver_location', queryParams);
    var driverNewLocation;
    if (backEndResult.statusCode == 200 && backEndResult.responseBody != null) {
      driverNewLocation = LatLng.fromJson([
        backEndResult.responseBody['lat'],
        backEndResult.responseBody['lng']
      ]);
      print('count: ' + count.toString());
      print(driverNewLocation);
      driverJourneyMarkersList.add(driverNewLocation);
      // setting up the bus route
      Polyline polyline = new Polyline(
          polylineId: new PolylineId("driver_path"),
          points: driverJourneyMarkersList,
          geodesic: true,
          width: 5,
          color: Colors.blue
      );
      polyLine.add(polyline);
      if (driverMarker != null) {
        // if marker is already exists, remove it and add a new marker
        markersList.removeWhere((marker) => marker.markerId == "driver position");
      }
      setState(() {});
      driverMarker = new Marker(
        markerId: MarkerId("driver position"),
        draggable: false,
        onTap: () {
          print('driver location');
          this.showDriverDetailsInBottomSheet(context, driverProfile, driverUser);
        },
        position: driverNewLocation,
        infoWindow: InfoWindow(
          title: 'Bus Driver',
          snippet: '101, 100, 2',
        ),
        icon: driverIcon,
      );
      markersList.add(driverMarker);
      setState(() {});
    } else {
      alertDialog = new BasicAlert(
          "Error Occurred",
          "error occurred in getting Driver location?",
          "Confirm",
          "Cancel",
          () {},
          () {},
          true);
      showDialog(
          context: context, builder: (BuildContext context) => alertDialog);
      setState(() {});
    }
  }

  void updateMarker(BusRoute busRoute) {
    markersList = [];
    // add start and end bus station markers in different color
    markersList.add(Marker(
      markerId: MarkerId(busRoute.routeNumber + ' start'),
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
      markerId: MarkerId(busRoute.routeNumber + ' end'),
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
    for (var i = 0;
        i < busRoute.busStations[busRoute.journeyStep].length;
        i++) {
      markersList.add(Marker(
        markerId: MarkerId(busRoute.routeNumber + ' ' + i.toString()),
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
    var permissions = await Permission.getPermissionsStatus(
        [PermissionName.Location, PermissionName.Internet]);
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
          'Bus Routes',
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
            updateDriverLocation(context, newValue.id);
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
                padding: EdgeInsets.only(bottom: 80, right: 10),
                onMapCreated: onMapCreated,
                polylines: polyLine,
                initialCameraPosition:
                    CameraPosition(target: LatLng(6.7881, 79.8913), zoom: 12.0),
                markers: Set.from(markersList),
                mapType: MapType.normal,
              )),
        )
      ]),
      floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_home,
          animatedIconTheme: IconThemeData(size: 22.0),
          curve: Curves.bounceIn,
          backgroundColor: Colors.lightBlueAccent,
          children: this.getSpeedDials()),
    );
  }

  /// show the drivers info in the bottom of the view
  void showDriverDetailsInBottomSheet(BuildContext context,
      DriverProfile driverProfile, User driverUser) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.black12,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: new EdgeInsets.all(10.0),
                 child: Text(driverUser != null
                      ? driverUser.firstName + ' ' + driverUser.lastName
                      : 'N/A',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20
                    ))
              ),
              Container(
                  padding: new EdgeInsets.all(5.0),
                  child: new RichText(
                    text: new TextSpan(
                      // Note: Styles for TextSpans must be explicitly defined.
                      // Child text spans will inherit styles from parent
                      style: new TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        new TextSpan(text: 'Contact: '),
                        new TextSpan(
                            text: driverUser.contact,
                            style: new TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )),
              Container(
                  padding: new EdgeInsets.all(5.0),
                  child: new RichText(
                    text: new TextSpan(
                      // Note: Styles for TextSpans must be explicitly defined.
                      // Child text spans will inherit styles from parent
                      style: new TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        new TextSpan(text: 'Rating: '),
                        new TextSpan(
                            text: driverProfile.rating,
                            style: new TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )),
              Container(
                  padding: new EdgeInsets.all(5.0),
                  child: new RichText(
                    text: new TextSpan(
                      // Note: Styles for TextSpans must be explicitly defined.
                      // Child text spans will inherit styles from parent
                      style: new TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        new TextSpan(text: 'Trips: '),
                        new TextSpan(
                            text: driverProfile.trips.toString(),
                            style: new TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )),
              ElevatedButton(
                child: new Text('Close'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),

        );
      },
    );
  }

  /// get speedDials based on user authentication details
  List<SpeedDialChild> getSpeedDials() {
    List<SpeedDialChild> speedDials = new List.of([
      SpeedDialChild(
        child: Icon(Icons.assignment_ind_outlined, color: Colors.white),
        backgroundColor: Colors.deepOrange,
        onTap: () => Navigator.pushNamed(context, '/about_us'),
        label: 'About Us',
        labelStyle: TextStyle(fontWeight: FontWeight.w500),
        labelBackgroundColor: Colors.deepOrangeAccent,
      )
    ]);

    if (UserSession().isLoggedIn) {
      speedDials.addAll([
        SpeedDialChild(
          child: Icon(Icons.assignment_ind_outlined, color: Colors.white),
          backgroundColor: Colors.lightBlueAccent,
          onTap: () => Navigator.pushNamed(context, '/user'),
          label: 'Profile',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.lightBlueAccent,
        ),
        SpeedDialChild(
            child: Icon(Icons.settings, color: Colors.white),
            backgroundColor: Colors.green,
            onTap: () => Navigator.pushNamed(context, '/complaint'),
            label: 'Complaints',
            labelStyle: TextStyle(fontWeight: FontWeight.w500),
            labelBackgroundColor: Colors.green)
      ]);
    }
    return speedDials;
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
