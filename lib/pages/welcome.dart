import 'package:flutter/material.dart';

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
                height: MediaQuery.of(context).size.height / 2 - 45,
                width: MediaQuery.of(context).size.width,
                child: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/driver');
                  },
                  color: Colors.cyan[100],
                  icon: new Icon(Icons.directions_bus, size: 60.0),
                )),
          ]),
        ));
  }
}
