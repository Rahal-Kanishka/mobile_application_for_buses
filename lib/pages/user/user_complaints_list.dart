import 'package:flutter/material.dart';
import 'package:flutter_with_maps/common/user_session.dart';
import 'package:flutter_with_maps/models/Complaint.dart';
import 'package:flutter_with_maps/util/backend.dart';

class UserComplaintListTable extends StatefulWidget {
  @override
  _UserComplaintListTableState createState() => _UserComplaintListTableState();
}

class _UserComplaintListTableState extends State<UserComplaintListTable> {
  List<Complaint> userComplaintList = new List();
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
    this.userComplaintList.clear();
    this.userDataRowList.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Complaint List'),
          centerTitle: true,
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                PaginatedDataTable(
                  header: Text('My Complaint List'),
                  onRowsPerPageChanged: (rows) {
                    setState(() {
                      _rowsPerPage = rows;
                    });
                  },
                  rowsPerPage: _rowsPerPage,
                  columns: [
                    DataColumn(
                        label: Text('Heading',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Complaint',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Status',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Recorded Time',
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

  Future<List<Complaint>> getComplaintsByUser() async {
    Map<String, String> queryParams = {'user_id': UserSession().currentUser.id};
    BackEndResult backEndResult =
        await BackEnd.getRequest('/complaint/by_user', queryParams);
    List<Complaint> data = new List();
    if (backEndResult.statusCode == 200) {
      data = (backEndResult.responseBody as List)
          .map((i) => Complaint.fromJson(i))
          .toList();
      this.userComplaintList = data;
      setState(() {
        _customTableDataSource = CustomTableDataSource(data);
      });
      print(data);
    }
    return data;
  }
}

class CustomTableDataSource extends DataTableSource {
  final List<Complaint> _results;

  CustomTableDataSource(this._results);

  int _selectedCount = 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= _results.length) return null;
    final Complaint complaint = _results[index];
    return DataRow.byIndex(index: index, cells: <DataCell>[
      DataCell(Text(
          complaint.heading != null ? complaint.heading.toString() : 'N/A')),
      DataCell(Text(complaint.complaint != null
          ? complaint.complaint.toString()
          : 'N/A')),
      DataCell(Text(complaint.status != null
          ? complaint.status.toString()
          : 'N/A')),
      DataCell(Text(complaint.createdOn != null
          ? complaint.createdOn.toString()
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
