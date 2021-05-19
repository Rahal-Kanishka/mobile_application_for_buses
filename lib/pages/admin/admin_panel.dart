import 'package:flutter/material.dart';

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
        centerTitle: true,
      ),
      body: Container(
        padding: new EdgeInsets.all(10.0),
        color: Colors.white,
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            children: generateAdminOptionCards(context),
          ),
        )
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  List<Widget> generateAdminOptionCards(BuildContext context) {
    List<Widget> cardList = new List();
    Card usersCard = getCard('All Users', Icons.supervised_user_circle_outlined, ()=> {
      Navigator.pushNamed(context, '/user_list')
    });
    Card driversCard = getCard('Drivers By Route', Icons.directions_bus, ()=> {  print(' drivers')});
    Card complaintsCard = getCard('Complaints', Icons.comment_bank, ()=> {  print('complaints')});
    cardList.addAll([usersCard, driversCard, complaintsCard]);
    return cardList;
  }

  // get card dynamically with tap action
  Card getCard(String cardTitle, IconData icon, VoidCallback callback) {
    Card driversCard = new Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          print('Card tapped.');
          callback();
        },
        child: Container(
          width: 300,
          height: 100,
          alignment: Alignment.center,
          child: ListTile(
            leading: Icon(icon),
            title: Text(cardTitle),
          ),
        ),
      ),
    );
    return driversCard;
  }

}