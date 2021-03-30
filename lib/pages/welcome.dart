import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_with_maps/common/user_session.dart';

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
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/home');
                },
                color: Colors.amber[100],
                icon: new Icon(Icons.subway_outlined, size: 60.0),
              )),
        ]),
      ),
      floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_home,
          animatedIconTheme: IconThemeData(size: 22.0),
          curve: Curves.bounceIn,
          backgroundColor: Colors.lightBlueAccent,
          children: this.getSpeedDialArray()
          ),
    );
  }

  List<SpeedDialChild> getSpeedDialArray() {
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
      speedDials.add(SpeedDialChild(
          child: Icon(Icons.login_sharp, color: Colors.white),
          backgroundColor: Colors.redAccent[200],
          onTap: () => Navigator.pushNamed(context, '/login'),
          label: 'Log out',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.redAccent[200]));
    } else {
      speedDials.add(
          SpeedDialChild(
              child: Icon(Icons.login_sharp, color: Colors.white),
              backgroundColor: Colors.lightBlueAccent,
              onTap: () => Navigator.pushNamed(context, '/login'),
              label: 'Login',
              labelStyle: TextStyle(fontWeight: FontWeight.w500),
              labelBackgroundColor: Colors.lightBlueAccent));
    }
    return speedDials;
  }
}
