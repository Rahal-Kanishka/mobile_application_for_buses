import 'package:flutter/material.dart';
import 'package:flutter_with_maps/models/user.dart';
import 'package:flutter_with_maps/util/backend.dart';

class UserListTable extends StatefulWidget {
  @override
  _UserListTableState createState() => _UserListTableState();
}

class _UserListTableState extends State<UserListTable> {
  List<User> userList = new List();
  List<DataRow> userDataRowList = new List();
  CustomTableDataSource _customTableDataSource = CustomTableDataSource([]);
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  @override
  void initState()  {
    super.initState();
    getAllUsers();
  }

  @override
  void dispose() {
    super.dispose();
    this.userList.clear();
    this.userDataRowList.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('User List'),
          centerTitle: true,
        ),
        body: Container(
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
                        label: Text('ID',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Name',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('UserName',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Type',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold))),
                  ], source: _customTableDataSource,
                )
              ],
            ),
          ),
        )
    );
  }

  Future<List<User>> getAllUsers() async {
    BackEndResult backEndResult = await BackEnd.getRequest('/user/all');
    List<User> data = new List();
    if (backEndResult.statusCode == 200) {
      data = (backEndResult.responseBody as List)
          .map((i) => User.fromJson(i))
          .toList();
      this.userList = data;
      setState(() {
        _customTableDataSource = CustomTableDataSource(data);
      });
      print(data);
    }
    return data;
  }
}

class CustomTableDataSource extends DataTableSource {

  final List<User> _results;

  CustomTableDataSource(this._results);

  int _selectedCount = 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= _results.length) return null;
    final User user = _results[index];
    return DataRow.byIndex(
        index: index,
        cells: <DataCell>[
          DataCell(Text(user.id != null ? user.id.toString() : 'N/A')),
          DataCell(Text(user.firstName != null || user.firstName != null
              ? user.firstName + user.lastName
              : 'N/A')),
          DataCell(Text(user.email != null ? user.email.toString() : 'N/A')),
          DataCell(
              Text(user.type != null ? user.type.typeName.toString() : 'N/A'))
        ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _results.length;

  @override
  int get selectedRowCount => _selectedCount;

}
