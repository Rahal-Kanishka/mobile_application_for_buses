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
  final _formKey = GlobalKey<FormState>();

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
        body: Form(
          key: _formKey,
          child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: ListView(shrinkWrap: true, children: <Widget>[
                Container(
                    padding: new EdgeInsets.all(10.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          icon: const Icon(Icons.perm_contact_cal_sharp),
                          border: OutlineInputBorder(),
                          hintText: 'Enter your First Name...',
                          labelText: 'First Name'),
                    )),
                Container(
                    padding: new EdgeInsets.all(10.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          icon: const Icon(Icons.person),
                          border: OutlineInputBorder(),
                          hintText: 'Enter your Last Name...',
                          labelText: 'Last Name'),
                    )),
                Container(
                    padding: new EdgeInsets.all(10.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          icon: const Icon(Icons.email),
                          border: OutlineInputBorder(),
                          hintText: 'Enter your email...',
                          labelText: 'email'),
                    )),
                Container(
                    padding: new EdgeInsets.all(10.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          icon: const Icon(Icons.phone),
                          border: OutlineInputBorder(),
                          hintText: 'Enter your Contact Number...',
                          labelText: 'Contact'),
                    )),
                Container(
                    padding: new EdgeInsets.all(10.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          icon: const Icon(Icons.home_filled),
                          border: OutlineInputBorder(),
                          hintText: 'Enter your Address...',
                          labelText: 'Address'),
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
                    child: TextFormField(
                      decoration: InputDecoration(
                          icon: const Icon(Icons.security),
                          border: OutlineInputBorder(),
                          hintText: 'Enter your password...',
                          labelText: 'Password'),
                      obscureText: true,
                    )),
                Container(
                    padding: new EdgeInsets.all(10.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          icon: const Icon(Icons.security),
                          border: OutlineInputBorder(),
                          hintText: 'Enter your confirm password...',
                          labelText: 'Confirm Password'),
                      obscureText: true,
                    )),
                Container(
                  padding: new EdgeInsets.all(10.0),
                  child: RaisedButton(
                      color: Colors.redAccent[200],
                      child: Text('Register'),
                      onPressed: () {}),
                )
              ])),
        ));
  }
}
