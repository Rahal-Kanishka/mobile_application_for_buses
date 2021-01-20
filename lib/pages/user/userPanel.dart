import 'package:flutter/material.dart';

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
    );
  }
}
