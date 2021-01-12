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
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          child: ListView(shrinkWrap: true, children: <Widget>[
            Container(
                padding: new EdgeInsets.all(10.0),
                child: TextField(
                  decoration: InputDecoration(
                      icon: const Icon(Icons.email),
                      border: OutlineInputBorder(),
                      hintText: 'enter username',
                      labelText: 'UserName'),
                )),
            Container(
                padding: new EdgeInsets.all(10.0),
                child: TextField(
                  decoration: InputDecoration(
                      icon: const Icon(Icons.vpn_key_sharp),
                      border: OutlineInputBorder(),
                      hintText: 'Enter password',
                      labelText: 'Password'),
                  obscureText: true,
                )),
            Container(
              padding: new EdgeInsets.all(10.0),
              child: RaisedButton(
                  color: Colors.blue[200],
                  child: Text('Login'),
                  onPressed: () {}),
            ),
            Container(
              padding: new EdgeInsets.all(10.0),
              child: RaisedButton(
                  color: Colors.redAccent[200],
                  child: Text('Register'),
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  }),
            )
          ])),
    );
  }
}
