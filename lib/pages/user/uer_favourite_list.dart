import 'package:flutter/material.dart';
import 'package:flutter_with_maps/common/user_session.dart';
import 'package:flutter_with_maps/models/Complaint.dart';
import 'package:flutter_with_maps/models/favourite.dart';
import 'package:flutter_with_maps/util/backend.dart';

class UserFavouriteListTable extends StatefulWidget {
  @override
  _UserFavouriteListTableState createState() => _UserFavouriteListTableState();
}

class _UserFavouriteListTableState extends State<UserFavouriteListTable> {
  List<Favourite> userFavouriteList = new List();
  List<DataRow> userDataRowList = new List();
  CustomTableDataSource _customTableDataSource = CustomTableDataSource([]);
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  @override
  void initState() {
    super.initState();
    getComplaintsByUser();
  }

  @override
  void dispose() {
    super.dispose();
    this.userFavouriteList.clear();
    this.userDataRowList.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Favourite List'),
          centerTitle: true,
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                PaginatedDataTable(
                  header: Text('My Favourite List'),
                  onRowsPerPageChanged: (rows) {
                    setState(() {
                      _rowsPerPage = rows;
                    });
                  },
                  rowsPerPage: _rowsPerPage,
                  columns: [
                    DataColumn(
                        label: Text('Trips',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Rating',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Added to Favourite On',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold))),
                  ],
                  source: _customTableDataSource,
                )
              ],
            ),
          ),
        ));
  }

  Future<List<Favourite>> getComplaintsByUser() async {
    BackEndResult backEndResult =
    await BackEnd.getRequest('/favourite/all');
    List<Favourite> data = new List();
    if (backEndResult.statusCode == 200) {
      data = (backEndResult.responseBody as List)
          .map((i) => Favourite.fromJson(i))
          .toList();
      this.userFavouriteList = data;
      setState(() {
        _customTableDataSource = CustomTableDataSource(data);
      });
      print(data);
    }
    return data;
  }
}

class CustomTableDataSource extends DataTableSource {
  final List<Favourite> _results;

  CustomTableDataSource(this._results);

  int _selectedCount = 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= _results.length) return null;
    final Favourite favourite = _results[index];
    return DataRow.byIndex(index: index, cells: <DataCell>[
      DataCell(Text(
          favourite.driverProfile != null ? favourite.driverProfile.rating.toString() : 'N/A')),
      DataCell(Text(favourite != null
          ? favourite.driverProfile.trips.toString()
          : 'N/A')),
      DataCell(Text(favourite.createdOn != null
          ? favourite.createdOn.toString()
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
