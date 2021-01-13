import 'package:flutter/material.dart';
import 'package:flutter_with_maps/models/SaveUser.dart';
import 'package:flutter_with_maps/models/UserType.dart';
import 'package:http/http.dart' as http;
import 'package:global_configuration/global_configuration.dart';
import 'dart:convert';

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
  String endPoint;
  UserType selectedUserType;
  final _formKey = GlobalKey<FormState>();
  SaveUser userModel = new SaveUser();

  @override
  void initState() {
    super.initState();
    selectedUserType = userTypeList[1];
    this.userModel.type = userTypeList[1];
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text('Register'),
          centerTitle: true,
        ),
        body: Builder(
          builder: (BuildContext buildContext) {
            return Form(
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
                          validator: (String value) {
                            if (value.isEmpty) {
                              return "First Name can not be empty";
                            } else {
                              return null;
                            }
                          },
                          onSaved: (String value) {
                            this.userModel.firstName = value;
                          },
                        )),
                    Container(
                        padding: new EdgeInsets.all(10.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                              icon: const Icon(Icons.person),
                              border: OutlineInputBorder(),
                              hintText: 'Enter your Last Name...',
                              labelText: 'Last Name'),
                          onSaved: (String value) {
                            this.userModel.lastName = value;
                          },
                        )),
                    Container(
                        padding: new EdgeInsets.all(10.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                              icon: const Icon(Icons.email),
                              border: OutlineInputBorder(),
                              hintText: 'Enter your email...',
                              labelText: 'email'),
                          keyboardType: TextInputType.emailAddress,
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'email can not be empty';
                            } else {
                              return null;
                            }
                          },
                          onSaved: (String value) {
                            this.userModel.email = value;
                          },
                        )),
                    Container(
                        padding: new EdgeInsets.all(10.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                              icon: const Icon(Icons.phone),
                              border: OutlineInputBorder(),
                              hintText: 'Enter your Contact Number...',
                              labelText: 'Contact'),
                          onSaved: (String value) {
                            this.userModel.contact = value;
                          },
                        )),
                    Container(
                        padding: new EdgeInsets.all(10.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                              icon: const Icon(Icons.home_filled),
                              border: OutlineInputBorder(),
                              hintText: 'Enter your Address...',
                              labelText: 'Address'),
                          onSaved: (String value) {
                            this.userModel.address = value;
                          },
                        )),
                    Container(
                      padding: new EdgeInsets.all(10.0),
                      child: new DropdownButton(
                        hint: new Text("select user type"),
                        value: selectedUserType,
                        onChanged: (UserType newValue) {
                          setState(() {
                            selectedUserType = newValue;
                            this.userModel.type = newValue;
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
                                      style:
                                          new TextStyle(color: Colors.black)),
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
                          validator: (String value) {
                            if (value.isEmpty || value.length < 3) {
                              return "password should be minimum of three characters";
                            } else {
                              this._formKey.currentState.save();
                              return null;
                            }
                          },
                          onSaved: (String value) {
                            this.userModel.password = value;
                          },
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
                          validator: (String value) {
                            if (value.isEmpty || value.length < 3) {
                              return "password should be minimum of three characters";
                            } else if (value != this.userModel.password) {
                              return "passwords do not match";
                            } else {
                              return null;
                            }
                          },
                          onSaved: (String value) {
                            this.userModel.confirmPassword = value;
                          },
                        )),
                    Container(
                      padding: new EdgeInsets.all(10.0),
                      child: RaisedButton(
                          color: Colors.redAccent[200],
                          child: Text('Register'),
                          onPressed: () {
                            this.saveFormData().then((value) {
                              if (value != null && value.isNotEmpty) {
                                final snackBar = SnackBar(content: Text(value));
                                Scaffold.of(buildContext)
                                    .showSnackBar(snackBar);
                              }
                            });
                          }),
                    )
                  ])),
            );
          },
        ));
  }

  Future<String> saveFormData() async {
    if (this._formKey.currentState.validate()) {
      this._formKey.currentState.save();
      String result = await this.saveUserData();
      return result;
    }
  }

  Future<String> saveUserData() async {
    String result = null;
    var json = await GlobalConfiguration()
        .loadFromPath('assets/cfg/configurations.json');
    endPoint = GlobalConfiguration().getValue("backend_url");
    var url = endPoint + '/user/register';
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'firstName': this.userModel.firstName,
          'lastName': this.userModel.lastName,
          'userName': this.userModel.email,
          'contact': this.userModel.contact,
          'address': this.userModel.address,
          'type': {
            'id': this.userModel.type.typeName,
            'name': this.userModel.type.typeName
          },
          'password': this.userModel.password,
        }));
    var userData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      result = 'User ' +
          userData['data']['firstName'] +
          ' ' +
          userData['data']['lastName'] +
          ' registered successfully';
    } else {
      result = userData['data'][0]['msg'];
    }
    return result;
  }
}
