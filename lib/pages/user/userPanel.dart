import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class UserPanel extends StatefulWidget {
  @override
  _UserPanel createState() => _UserPanel();
}

class _UserPanel extends State<UserPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('User Panel'),
          centerTitle: true,
        ),
        body: Container(
          color: Colors.red,
          alignment: Alignment.center,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Card(
                      child: InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                          print('Card tapped.');
                          Navigator.pushNamed(context, '/home');
                        },
                        child: Container(
                          width: 300,
                          height: 100,
                          alignment: Alignment.center,
                          child: ListTile(
                            leading: Icon(Icons.directions_bus),
                            title: Text('View Buses'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Card(
                      child: InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                          print('Card tapped.');
                          Navigator.pushNamed(context, '/select_bus');
                        },
                        child: Container(
                          width: 300,
                          height: 100,
                          alignment: Alignment.center,
                          child: ListTile(
                            leading: Icon(Icons.calendar_today_rounded),
                            title: Text('Book a Bus'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Card(
                      child: InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                          print('Card tapped.');
                        },
                        child: Container(
                          width: 300,
                          height: 100,
                          alignment: Alignment.center,
                          child: ListTile(
                            leading: Icon(Icons.favorite_outlined),
                            title: Text('My Favourites'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Card(
                      child: InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                          print('Card tapped.');
                        },
                        child: Container(
                            width: 300,
                            height: 100,
                            alignment: Alignment.center,
                            child: ListTile(
                              leading: Icon(Icons.history),
                              title: Text('Booking History'),
                            )),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Card(
                      child: InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                          print('Card tapped.');
                        },
                        child: Container(
                            width: 300,
                            height: 100,
                            alignment: Alignment.center,
                            child: ListTile(
                              leading: Icon(Icons.comment),
                              title: Text('My Complaints'),
                            )),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Card(
                      child: InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                          print('Card tapped.');
                        },
                        child: Container(
                          width: 300,
                          height: 100,
                          alignment: Alignment.center,
                          child: ListTile(
                            leading: Icon(Icons.rate_review),
                            title: Text('My Reviews'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        floatingActionButton: SpeedDial(
            animatedIcon: AnimatedIcons.menu_home,
            animatedIconTheme: IconThemeData(size: 22.0),
            curve: Curves.bounceIn,
            backgroundColor: Colors.lightBlueAccent,
            children: [
              SpeedDialChild(
                child: Icon(Icons.logout, color: Colors.white),
                backgroundColor: Colors.deepOrange,
                onTap: () {
                  Navigator.pushNamed(context, '/login');
                },
                label: 'Log out',
                labelStyle: TextStyle(fontWeight: FontWeight.w500),
                labelBackgroundColor: Colors.deepOrangeAccent,
              ),
              SpeedDialChild(
                  child: Icon(Icons.app_registration, color: Colors.white),
                  backgroundColor: Colors.redAccent[200],
                  onTap: () => Navigator.pushNamed(context, '/register'),
                  label: 'Register',
                  labelStyle: TextStyle(fontWeight: FontWeight.w500),
                  labelBackgroundColor: Colors.redAccent[200]),
              SpeedDialChild(
                  child: Icon(Icons.settings, color: Colors.white),
                  backgroundColor: Colors.green,
                  onTap: () => Navigator.pushNamed(context, '/complaint'),
                  label: 'Complaints',
                  labelStyle: TextStyle(fontWeight: FontWeight.w500),
                  labelBackgroundColor: Colors.green)
            ]));
  }
}
