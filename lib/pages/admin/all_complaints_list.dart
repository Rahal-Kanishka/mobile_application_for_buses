import 'package:flutter/material.dart';
import 'package:flutter_with_maps/models/Complaint.dart';
import 'package:flutter_with_maps/util/backend.dart';

class AllComplaintListTable extends StatefulWidget {
  @override
  _AllComplaintListTableState createState() => _AllComplaintListTableState();
}

class _AllComplaintListTableState extends State<AllComplaintListTable> {
  List<Complaint> allComplaintList = new List();
  List<DataRow> userDataRowList = new List();
  CustomTableDataSource _customTableDataSource = CustomTableDataSource([]);
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  @override
  void initState() {
    super.initState();
    getAllUsers();
  }

  @override
  void dispose() {
    super.dispose();
    this.allComplaintList.clear();
    this.userDataRowList.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('All Complaint List'),
          centerTitle: true,
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                PaginatedDataTable(
                  header: Text('All Complaint List'),
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
                        label: Text('Complainer Name',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Complainer Type',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Complainer Email',
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

  Future<List<Complaint>> getAllUsers() async {
    BackEndResult backEndResult = await BackEnd.getRequest('/complaint/all');
    List<Complaint> data = new List();
    if (backEndResult.statusCode == 200) {
      data = (backEndResult.responseBody as List)
          .map((i) => Complaint.fromJson(i))
          .toList();
      this.allComplaintList = data;
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
      DataCell(Text(
          complaint.user.firstName != null || complaint.user.lastName != null
              ? complaint.user.firstName + complaint.user.lastName
              : 'N/A')),
      DataCell(Text(complaint.user.type != null
          ? complaint.user.type.typeName.toString()
          : 'N/A')),
      DataCell(Text(complaint.user.email != null
          ? complaint.user.email.toString()
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
