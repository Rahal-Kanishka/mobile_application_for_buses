import 'package:flutter/material.dart';
import 'package:flutter_with_maps/common/basic_alert.dart';
import 'package:flutter_with_maps/models/bus.dart';
import 'package:flutter_with_maps/util/backend.dart';

class BusSelection extends StatefulWidget {
  @override
  _BusSelectionState createState() => _BusSelectionState();
}

class _BusSelectionState extends State<BusSelection> {
  List<Bus> busList = new List();
  var alertDialog;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Select Bus'),
          centerTitle: true,
        ),
        body: Container(
          child: FutureBuilder<List<Bus>>(
            future: this.getAssignedBusList(),
            builder: (BuildContext context, AsyncSnapshot<List<Bus>> snapshot) {
              List<Widget> children;
              if (snapshot.hasData) {
                children = this.generateBusCards(context);
              } else if (snapshot.hasError) {
              } else {
                children = <Widget>[
                  SizedBox(
                    child: CircularProgressIndicator(),
                    width: 60,
                    height: 60,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Awaiting result...'),
                  )
                ];
              }
              return Container(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: children,
                  ),
                ),
              );
            },
          ),
        ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    alertDialog = new BasicAlert("Confirm", "Do you want to Select this Bus?", "Confirm", "Cancel", (){}, (){});
  }

  Future<List<Bus>> getAssignedBusList() async {
    BackEndResult backEndResult = await BackEnd.getRequest('/bus/all');
    List<Bus> data = new List();
    if (backEndResult.statusCode == 200) {
      data = (backEndResult.responseBody as List)
          .map((i) => Bus.fromJson(i))
          .toList();
      this.busList = data;
      print(data);
    }
    return data;
  }

  /// generate bus cards based on the retrieved bus list data from database
  List<Widget> generateBusCards(BuildContext context) {
    if (this.busList != null && this.busList.length > 0) {
      List<Widget> cardList = new List();
      for (var i = 0; this.busList.length > i; i++) {
        Card busCard = new Card(
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              print('Card tapped.');
              this.onSelectBus(context);
            },
            child: Container(
              width: 300,
              height: 100,
              alignment: Alignment.center,
              child: ListTile(
                leading: Icon(Icons.directions_bus),
                title: Text(busList[i].route),
              ),
            ),
          ),
        );
        cardList.add(busCard);
      }
      return cardList;
    } else {
      return <Widget>[];
    }
  }

  void onSelectBus(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => alertDialog);

  }
}
