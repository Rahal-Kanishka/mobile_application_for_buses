import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:global_configuration/global_configuration.dart';

class Driver {
  String userName;
  String name;
  int age;
  String nationality;
  String rating;
  int trips;

  Driver(Map<String, dynamic> data) {
    if (data != null) {
      this.userName = data['userName'];
      this.name = data['name'];
      this.age = data['age'] as int;
      this.nationality = data['nationality'];
      this.rating = data['rating'];
      this.trips = data['trips'] as int;
    }
  }
}

class DriverHome extends StatefulWidget {
  @override
  _DriverHomeState createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome> {
  String endPoint;
  Driver driver = new Driver(null);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDriverData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Driver Profile'),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.red,
        alignment: Alignment.topRight,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Container(
                padding: new EdgeInsets.all(10.0),
                color: Colors.red,
                height: MediaQuery.of(context).size.height / 2 - 45,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: new EdgeInsets.all(10.0),
                      color: Colors.blue,
                      width: MediaQuery.of(context).size.width / 2 - 10,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                            child: Text('Name:   ${driver.name}'),
                            color: Colors.grey[100],
                          ),
                          Container(
                            child: Text('Age: ${driver.age.toString()}'),
                            color: Colors.grey[200],
                          ),
                          Container(
                            child: Text('Nationality:   ${driver.nationality}'),
                            color: Colors.grey[300],
                          ),
                          Container(
                            child: Text('Trips: ${driver.trips?.toString()}'),
                            color: Colors.grey[500],
                          ),
                          Container(
                            child: Text('Rating: ${driver.rating}'),
                            color: Colors.grey[500],
                          ),
                        ],
                      ),
                    ),
                    Container(
                        padding: new EdgeInsets.all(10.0),
                        color: Colors.yellow,
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
                padding: new EdgeInsets.all(10.0),
                color: Colors.blue,
                height: MediaQuery.of(context).size.height / 2 - 45,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width - 20,
                      padding: new EdgeInsets.all(10.0),
                      child: RaisedButton(
                        onPressed: () {},
                        child: Text('Start Driving'),
                      ),
                      color: Colors.deepPurpleAccent,
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  void getDriverData() async {
    var json = await GlobalConfiguration()
        .loadFromPath('assets/cfg/configurations.json');
    endPoint = GlobalConfiguration().getValue("backend_url");

    final response = await http.get(endPoint + '/driver/rahal_1');

    if (response.statusCode == 200) {
      var driverData = jsonDecode(response.body);
      print(driverData);
      setState(() {
        driver = Driver(driverData);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }
}
