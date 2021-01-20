import 'package:flutter/material.dart';
import 'package:flutter_with_maps/common/user_session.dart';
import 'package:flutter_with_maps/models/user.dart';
import 'package:flutter_with_maps/util/backend.dart';
import 'package:global_configuration/global_configuration.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  User loginUser = new User();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Login'),
          centerTitle: true,
        ),
        body: Builder(builder: (BuildContext buildContext) {
          return Form(
            key: _formKey,
            child: Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                child: ListView(shrinkWrap: true, children: <Widget>[
                  Container(
                      padding: new EdgeInsets.all(10.0),
                      child: TextFormField(
                          decoration: InputDecoration(
                              icon: const Icon(Icons.email),
                              border: OutlineInputBorder(),
                              hintText: 'enter username',
                              labelText: 'UserName'),
                          keyboardType: TextInputType.emailAddress,
                          validator: (String value) {
                            if (value != null && value.isEmpty) {
                              return 'email can not be empty';
                            } else {
                              return null;
                            }
                          },
                          onSaved: (String value) {
                            this.loginUser.email = value;
                          })),
                  Container(
                      padding: new EdgeInsets.all(10.0),
                      child: TextFormField(
                          decoration: InputDecoration(
                              icon: const Icon(Icons.vpn_key_sharp),
                              border: OutlineInputBorder(),
                              hintText: 'Enter password',
                              labelText: 'Password'),
                          obscureText: true,
                          validator: (String value) {
                            if (value != null && value.isEmpty) {
                              return 'password can not be empty';
                            } else {
                              return null;
                            }
                          },
                          onSaved: (String value) {
                            this.loginUser.password = value;
                          })),
                  Container(
                      padding: new EdgeInsets.all(10.0),
                      child: RaisedButton(
                        color: Colors.blue[200],
                        child: Text('Login'),
                        onPressed: () {
                          this.login().then((value) {
                            if (value != null && value[0].isNotEmpty) {
                              final snackBar = SnackBar(content: Text(value[0]));
                              Scaffold.of(buildContext).showSnackBar(snackBar);
                            }
                            if(value[1] == 200){
                              // if success
                              this.navigateToWelcome();
                            }
                          });
                        },
                      )),
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
        }));
  }

  Future<dynamic> login() async {
    if (this._formKey.currentState.validate()) {
      this._formKey.currentState.save();
      Map<String, dynamic> dataObject = {
        'userName': this.loginUser.email,
        'password': this.loginUser.password
      };
      BackEndResult result =
          await BackEnd.postRequest(dataObject, '/user/login');
      if (result != null && result.statusCode == 200) {
        UserSession().jwtToken = result.responseBody['token'];
        UserSession().currentUser = User.fromJson(result.responseBody['data']);
        return ['User login Successfully',result.statusCode];
      } else {
        return [result.responseBody['data'][0]['msg'],result.statusCode];
      }
    }
  }

  void navigateToWelcome(){
    Navigator.pushNamed(context, '/welcome');
  }
}
