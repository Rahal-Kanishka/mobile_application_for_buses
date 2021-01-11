import 'package:flutter/material.dart';
import 'package:flutter_with_maps/pages/user_profile.dart';

class UserType {
  const UserType(this.typeName, this.typeIcon);

  final String typeName;
  final Icon typeIcon;
}

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  List<UserType> userTypeList = [
    new UserType('Admin', Icon(Icons.assignment_ind)),
    new UserType('General', Icon(Icons.supervised_user_circle_outlined)),
    new UserType('Driver', Icon(Icons.train_rounded))
  ];
  UserType selectedUserType;

  @override
  void initState() {
    super.initState();
    selectedUserType = userTypeList[1];
  }

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
            height: MediaQuery.of(context).size.height,
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
              Container(
                padding: new EdgeInsets.all(10.0),
                child: new DropdownButton(
                  hint: new Text("select user type"),
                  value: selectedUserType,
                  onChanged: (UserType newValue) {
                    setState(() {
                      selectedUserType = newValue;
                    });
                  },
                  items: userTypeList.map((UserType value) {
                    return new DropdownMenuItem<UserType>(
                      value: value,
                      child: Row(
                        children: [
                          value.typeIcon,
                          Container(
                            padding: new EdgeInsets.all(10.0),
                            child: new Text(value.typeName,
                                style: new TextStyle(color: Colors.black)),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              Container(
                padding: new EdgeInsets.all(10.0),
                child: RaisedButton(
                    color: Colors.redAccent[200],
                    child: Text('Register'),
                    onPressed: () {}),
              ),
            ])));
  }
}
