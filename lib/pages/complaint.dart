import 'package:flutter/material.dart';

class Complaint extends StatefulWidget {
  @override
  _ComplaintState createState() => _ComplaintState();
}

class _ComplaintState extends State<Complaint> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Complaints'),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        color: Colors.white,
        child: Column(
          children: <Widget>[
            TextField(
              maxLines: 8,
              decoration: InputDecoration.collapsed(
                  hintText: "Enter your complaint here.."),
            ),
            RaisedButton(
                color: Colors.blue[200], child: Text('Submit'), onPressed: () {})
          ],
        ),
      ),
    );
  }
}
