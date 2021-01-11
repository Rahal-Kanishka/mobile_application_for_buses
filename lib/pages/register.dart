import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  List<String> userTypeList = ['Admin','General','Driver'];
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text('Register'),
          centerTitle: true,
        ),
        body: Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2,
            child: ListView(shrinkWrap: true, children: <Widget>[
              Container(
                  padding: new EdgeInsets.all(10.0),
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: 'First Name'),
                  )),
              Container(
                  padding: new EdgeInsets.all(10.0),
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Last Name'),
                  )),
              Container(
                  padding: new EdgeInsets.all(10.0),
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: 'email'),
                  )),
              Container(
                  padding: new EdgeInsets.all(10.0),
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: 'contact'),
                  )),
              Container(
                  padding: new EdgeInsets.all(10.0),
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: 'address'),
                  )),
            ])));
  }
}
