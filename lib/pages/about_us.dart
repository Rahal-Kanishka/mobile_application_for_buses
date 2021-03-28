import 'package:flutter/material.dart';
import 'package:flutter_with_maps/common/basic_alert.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
        centerTitle: true,
      ),
      body: Container(
        child: ListView(shrinkWrap: true, children: <Widget>[
          Container(
              padding: new EdgeInsets.all(10.0),
              color: Colors.lightBlueAccent,
              height: MediaQuery.of(context).size.height/8,
              width: MediaQuery.of(context).size.width,
              child: ListView(shrinkWrap: true, children: <Widget>[
                Text('Convenient Public Transportation',
                    textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.00),
                ),
              ])),
          Container(
              padding: new EdgeInsets.all(10.0),
              color: Colors.grey,
              height: MediaQuery.of(context).size.height / 12,
              width: MediaQuery.of(context).size.width,
              child: ListView(shrinkWrap: true, children: <Widget>[
                Text('Developers',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ])),
          Container(
              padding: new EdgeInsets.all(10.0),
              color: Colors.grey,
              height: MediaQuery.of(context).size.height/5,
              width: MediaQuery.of(context).size.width,
              child: ListView(shrinkWrap: true, children: <Widget>[
                Text('D.R.K.Dharmapriya'),
                Text('124038A'),
                Text('rahalncm@gmail.com')
              ])),
          Container(
              padding: new EdgeInsets.all(10.0),
              color: Colors.grey,
              height: MediaQuery.of(context).size.height/5,
              width: MediaQuery.of(context).size.width,
              child: ListView(shrinkWrap: true, children: <Widget>[
                Text('Janaka Wijerathne'),
                Text('144038A'),
                Text('wijesuriya@gmail.com')
              ])
              ),
          Container(
              padding: new EdgeInsets.all(12.0),
              color: Colors.grey,
              height: MediaQuery.of(context).size.height/12,
              width: MediaQuery.of(context).size.width,
              child: ListView(shrinkWrap: true, children: <Widget>[
                Text('Mentor',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ])),
          Container(
              padding: new EdgeInsets.all(10.0),
              color: Colors.grey,
              height: MediaQuery.of(context).size.height/4,
              width: MediaQuery.of(context).size.width,
              child: ListView(shrinkWrap: true, children: <Widget>[
                Text('Thuan Shafer Preena'),
                Text('Virtusa (PVT) LTD')
              ])
              )
        ]),
      ),
    );
  }
}
