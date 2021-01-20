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
                            child: Text('Name:   ${driver.name}'),
                            color: Colors.white,
                          ),
                          Container(
                            child: Text('Age: ${driver.age.toString()}'),
                            color: Colors.white,
                          ),
                          Container(
                            child: Text('Nationality:   ${driver.nationality}'),
                            color: Colors.white,
                          ),
                          Container(
                            child: Text('Trips: ${driver.trips?.toString()}'),
                            color: Colors.white,
                          ),
                          Container(
                            child: Text('Rating: ${driver.rating}'),
                            color: Colors.white,
                          ),
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
                padding: new EdgeInsets.all(10.0),
                color: Colors.blue[300],
                height: MediaQuery.of(context).size.height / 2 - 43,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width - 20,
                        height: MediaQuery.of(context).size.height / 4,
                        padding: new EdgeInsets.all(10.0),
                        color: Colors.indigoAccent[100],
                        alignment: Alignment.topLeft,
                        child: Column(
                          children: <Widget>[
                            Text('Next Schedule'),
                            RichText(
                                text: TextSpan(children: [
                              TextSpan(text: 'Start at '),
                              TextSpan(
                                  text: '3.00 P.M',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 50)),
                            ])),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Text('Start: Panadura'),
                                Text('End: Pettah'),
                              ],
                            )
                          ],
                        )),
                    Container(
                      width: MediaQuery.of(context).size.width - 20,
                      padding: new EdgeInsets.all(10.0),
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/driver_navigate');
                        },
                        child: Text('Start Driving'),
                      ),
                      color: Colors.indigoAccent[100],
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
