import 'package:flutter/material.dart';
import 'package:flutter_with_maps/models/DriverPopulatedDetail.dart';
import 'package:flutter_with_maps/models/bus_route.dart' as busRoute;
import 'package:flutter_with_maps/util/backend.dart';

class DriversByRouteTable extends StatefulWidget {
  @override
  _DriversByRouteTableState createState() => _DriversByRouteTableState();
}

class _DriversByRouteTableState extends State<DriversByRouteTable> {
  List<busRoute.BusRoute> routeList = new List();
  List<DriverPopulatedDetail> driverDetailsList = new List();
  List<DataRow> userDataRowList = new List();
  DriverByRouteTableDataSource _driverByRouteTableDataSource =
      DriverByRouteTableDataSource([]);
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  busRoute.BusRoute selectedBusRoute;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drivers By Route'),
        centerTitle: true,
      ),
      body: Container(
        padding: new EdgeInsets.all(10.0),
        color: Colors.white,
        alignment: Alignment.center,
        child: Column(
          children: [
            new DropdownButton<busRoute.BusRoute>(
              hint: new Text("Select a Route"),
              value: selectedBusRoute,
              onChanged: (busRoute.BusRoute newValue) {
                setState(() {
                  selectedBusRoute = newValue;
                  // update bus halts in the map
                  this.getDriversByRoute(selectedBusRoute.routeID);
                });
              },
              items: routeList.map((busRoute.BusRoute value) {
                return new DropdownMenuItem<busRoute.BusRoute>(
                  value: value,
                  child: new Text(value.routeName,
                      style: new TextStyle(color: Colors.black)),
                );
              }).toList(),
            ),
            Expanded(
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      PaginatedDataTable(
                        header: Text(' User List'),
                        onRowsPerPageChanged: (rows) {
                          setState(() {
                            _rowsPerPage = rows;
                          });
                        },
                        rowsPerPage: _rowsPerPage,
                        columns: [
                          DataColumn(
                              label: Text('Driver Name',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('Trips',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('Rating',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('Max Ratings',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold))),
                        ], source: _driverByRouteTableDataSource,
                      )
                    ],
                  ),
                ),
              )
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    this.getAllRoutes();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<DriverPopulatedDetail>> getDriversByRoute(String routeID) async {
    Map<String, String> driverProfileQueryParams = {
      'route_id': routeID
    };
    BackEndResult backEndResult = await BackEnd.getRequest('/driver/by_route', driverProfileQueryParams);
    List<DriverPopulatedDetail> data = new List();
    if (backEndResult.statusCode == 200) {
      data = (backEndResult.responseBody as List)
          .map((i) => DriverPopulatedDetail.fromJson(i))
          .toList();
      this.driverDetailsList = data;
      setState(() {
        _driverByRouteTableDataSource = DriverByRouteTableDataSource(this.driverDetailsList);
      });
      print(data);
    }
    return data;
  }

  Future<List<busRoute.BusRoute>> getAllRoutes() async {
    BackEndResult backEndResult = await BackEnd.getRequest('/route/all_routes');
    List<busRoute.BusRoute> data = new List();
    if (backEndResult.statusCode == 200) {
      data = (backEndResult.responseBody as List)
          .map((i) => busRoute.BusRoute.fromJson(i))
          .toList();
      setState(() {
        this.routeList = data;
      });
    }
    return data;
  }
}

class DriverByRouteTableDataSource extends DataTableSource {
  final List<DriverPopulatedDetail> _results;

  DriverByRouteTableDataSource(this._results);

  int _selectedCount = 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= _results.length) return null;
    final DriverPopulatedDetail driverPopulatedDetail = _results[index];
    return DataRow.byIndex(index: index, cells: <DataCell>[
      DataCell(Text(driverPopulatedDetail.userBasicInfo.firstName != null ||
              driverPopulatedDetail.userBasicInfo.firstName != null
          ? driverPopulatedDetail.userBasicInfo.firstName +
              driverPopulatedDetail.userBasicInfo.lastName
          : 'N/A')),
      DataCell(Text(driverPopulatedDetail.trips != null
          ? driverPopulatedDetail.trips.toString()
          : 'N/A')),
      DataCell(Text(driverPopulatedDetail.rating != null
          ? driverPopulatedDetail.rating
          : 'N/A')),
      DataCell(Text(driverPopulatedDetail.maxRatings != null
          ? driverPopulatedDetail.maxRatings
          : 'N/A'))
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _results.length;

  @override
  int get selectedRowCount => _selectedCount;
}
