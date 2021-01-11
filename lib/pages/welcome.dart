import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey,
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        child: ListView(shrinkWrap: true, children: <Widget>[
          Container(
              padding: new EdgeInsets.all(10.0),
              color: Colors.red,
              height: MediaQuery.of(context).size.height / 2 - 45,
              width: MediaQuery.of(context).size.width,
              child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/home');
                },
                color: Colors.amber[100],
                icon: new Icon(Icons.supervised_user_circle, size: 60.0),
              )),
          Container(
              padding: new EdgeInsets.all(10.0),
              color: Colors.blue,
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/driver');
                },
                color: Colors.cyan[100],
                icon: new Icon(Icons.directions_bus, size: 60.0),
              )),
        ]),
      ),
      floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_home,
          animatedIconTheme: IconThemeData(size: 22.0),
          curve: Curves.bounceIn,
          backgroundColor: Colors.lightBlueAccent,
          children: [
            SpeedDialChild(
              child: Icon(Icons.assignment_ind_outlined, color: Colors.white),
              backgroundColor: Colors.deepOrange,
              onTap: () => print('FIRST CHILD'),
              label: 'About Us',
              labelStyle: TextStyle(fontWeight: FontWeight.w500),
              labelBackgroundColor: Colors.deepOrangeAccent,
            ),
            SpeedDialChild(
                child: Icon(Icons.settings, color: Colors.white),
                backgroundColor: Colors.green,
                onTap: () => print('SECOND CHILD'),
                label: 'Settings',
                labelStyle: TextStyle(fontWeight: FontWeight.w500),
                labelBackgroundColor: Colors.green
            ),
            SpeedDialChild(
                child: Icon(Icons.settings, color: Colors.white),
                backgroundColor: Colors.lightBlueAccent,
                onTap: () => Navigator.pushNamed(context, '/login'),
                label: 'Login',
                labelStyle: TextStyle(fontWeight: FontWeight.w500),
                labelBackgroundColor: Colors.lightBlueAccent)
          ]),
    );
  }
}
