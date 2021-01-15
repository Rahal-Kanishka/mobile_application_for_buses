import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_with_maps/util/backend.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

class User {
  String name;
  String userName;
  String contact;
  String address;
  List<Trip> trips;

  User(this.name, this.userName, this.contact, this.address, [this.trips]);

  factory User.fromJson(dynamic json) {
    if (json != null) {
      if (json['bookings'] != null) {
        var tripObjsJson = json['bookings'] as List;
        List<Trip> _tags =
            tripObjsJson.map((tagJson) => Trip.fromJson(tagJson)).toList();

        return User(json['name'] as String, json['userName'] as String,
            json['contact'] as String, json['address'] as String, _tags);
      } else {
        return User(json['name'] as String, json['userName'] as String,
            json['contact'] as String, json['address'] as String);
      }
    } else {
      return User(null, null, null, null);
    }
  }
}

class Trip {
  String seats;
  String price;
  String bookingId;

  Trip(this.seats, this.price, this.bookingId);

  factory Trip.fromJson(dynamic json) {
    return Trip(json['seats'] as String, json['price'] as String,
        json['bookingId'] as String);
  }
}

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String endPoint;
  User user = new User(null, null, null, null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('User Profile'),
          centerTitle: true,
        ),
        body: Container(
          color: Colors.blue[300],
          alignment: Alignment.topRight,
          child: ListView(shrinkWrap: true, children: <Widget>[
            Container(
                padding: new EdgeInsets.all(10.0),
                color: Colors.white,
                height: MediaQuery.of(context).size.height / 2 - 45,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: new EdgeInsets.all(10.0),
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width / 2 - 10,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                            child: Text('Name:   ${user.name}'),
                            color: Colors.white,
                          ),
                          Container(
                            child: Text('Address: ${user.address?.toString()}'),
                            color: Colors.white,
                          ),
                          Container(
                            child: Text('Contact:   ${user.contact}'),
                            color: Colors.white,
                          ),
                          Container(
                            child: Text('Trips: ${user.trips?.length}'),
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                    Container(
                        padding: new EdgeInsets.all(10.0),
                        color: Colors.white,
                        height: MediaQuery.of(context).size.height / 2 - 60,
                        width: MediaQuery.of(context).size.width / 2 - 30,
                        child: FittedBox(
                            child: Image.asset(
                          'assets/images/driver_pic.jpg',
                          fit: BoxFit.contain,
                        ))),
                  ],
                )),
            Container(
              child: DataTable(columns: [
                DataColumn(
                    label: Text(
                  "Booking Id",
                  textScaleFactor: 1.5,
                  style: TextStyle(fontStyle: FontStyle.italic),
                )),
                DataColumn(
                    label: Text(
                  "Seats",
                  textScaleFactor: 1.5,
                  style: TextStyle(fontStyle: FontStyle.italic),
                )),
                DataColumn(
                    label: Text(
                  "Price",
                  textScaleFactor: 1.5,
                  style: TextStyle(fontStyle: FontStyle.italic),
                )),
              ], rows: generateTable()),
            ),
          ]),
        ));
  }

  List<DataRow> generateTable() {
    List<DataRow> rows = new List();
    if(user.trips != null) {
      for (var i = 0; i < user.trips?.length; i++) {
        DataRow row = new DataRow(cells: [
          DataCell(Text(
            user.trips[i].bookingId,
            textScaleFactor: 1.5,
          )),
          DataCell(Text(user.trips[i].seats, textScaleFactor: 1.5)),
          DataCell(Text(user.trips[i].price, textScaleFactor: 1.5))
        ]);
        rows.add(row);
      }
    }
    return rows;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // get user profile data
    this.getUserProfileData();
  }

  void getUserProfileData() async {
    BackEndResult backEndResult = await BackEnd.getRequest('/user/rahal_user');
    if (backEndResult.statusCode == 200) {
      var userData = backEndResult.responseBody;
      print(userData);
      setState(() {
        user = User.fromJson(userData);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }
}
