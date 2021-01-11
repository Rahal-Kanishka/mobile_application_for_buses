import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
      ),
      body: Container(
          color: Colors.blue[300],
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 2,
          child: ListView(shrinkWrap: true, children: <Widget>[
            Container(
                padding: new EdgeInsets.all(10.0),
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: 'enter username'),
                )),
            Container(
                padding: new EdgeInsets.all(10.0),
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Enter password'),
                  obscureText: true,
                )),
            Container(
              padding: new EdgeInsets.all(10.0),
              child: RaisedButton(
                  color: Colors.redAccent[200],
                  child: Text('Login'),
                  onPressed: () {}),
            ),
            Container(
              padding: new EdgeInsets.all(10.0),
              child: RaisedButton(
                  color: Colors.blue[200],
                  child: Text('Register'),
                  onPressed: () {}),
            )
          ])),
    );
  }
}
