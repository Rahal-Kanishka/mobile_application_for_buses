import 'package:flutter/material.dart';
import 'package:flutter_with_maps/common/user_session.dart';
import 'package:flutter_with_maps/util/backend.dart';

class Complaint extends StatefulWidget {
  @override
  _ComplaintState createState() => _ComplaintState();
}

class _ComplaintState extends State<Complaint> {
  String complaintTitle, complaint;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Complaints'),
        centerTitle: true,
      ),
      body: Builder(
          builder: (BuildContext buildContext) {
           return Container(
              alignment: Alignment.center,
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  TextField(
                    maxLines: 2,
                    decoration: InputDecoration.collapsed(
                        hintText: "Enter your complaint heading..",
                        border: OutlineInputBorder()),
                    onChanged: (String value) {
                      this.complaintTitle = value;
                    },
                  ),
                  TextField(
                    maxLines: 8,
                    decoration: InputDecoration.collapsed(
                        hintText: "Enter your complaint here..",
                        border: OutlineInputBorder()),
                    onChanged: (String value) {
                      this.complaint = value;
                    },
                  ),
                  RaisedButton(
                      color: Colors.blue[200],
                      child: Text('Submit'),
                      onPressed: () {
                        this.saveComplaint().then((value) {
                          final snackBar = SnackBar(content: Text(value));
                          Scaffold.of(buildContext).showSnackBar(snackBar);
                        });
                      })
                ],
              ),
            );
          }),
    );
  }

  Future<String> saveComplaint() async {
    String display;
    Map<String, dynamic> dataObject = {
      'heading': this.complaintTitle,
      'complaint': this.complaint,
      'user_id': UserSession().currentUser.id
    };
    BackEndResult result =
    await BackEnd.postRequest(dataObject, '/complaint/add_complaint');

    if (result != null && result.statusCode == 200) {
      display = 'Complaint Recorded Successfully';
    } else {
      display = 'Error in recording the complaint';
    }
    return display;
  }
}
