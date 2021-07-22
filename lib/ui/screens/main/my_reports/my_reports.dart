import 'package:flutter/material.dart';
import 'package:mafcode/ui/screens/main/home/reports_list_store.dart';
import 'package:mafcode/ui/screens/main/home/reports_list_widget.dart';

class MyReports extends StatefulWidget {
  MyReports({Key key}) : super(key: key);

  _MyReportsState createState() => _MyReportsState();
}

class _MyReportsState extends State<MyReports> {
  bool hasNotification = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          preferredSize: Size.fromHeight(0),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 8),
          child: ReportsListWidget(
            title: "My Reports",
            reportsSource: ReportsSource.CURRENT_USER,
          ),
        ));
  }
}
