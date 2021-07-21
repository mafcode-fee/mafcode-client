import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mafcode/core/di/providers.dart';
import 'package:mafcode/core/models/report.dart';
import 'package:mafcode/ui/auto_router_config.gr.dart';
import 'package:mafcode/ui/screens/main/home/reports_list_store.dart';
import 'package:mafcode/ui/screens/main/home/reports_list_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read(reportsListStoreProvider(ReportsSource.ALL)).getReports();
      },
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            "ACTIONS",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              HomeCard(
                lable: "Report Found",
                icon: Icons.emoji_people_rounded,
                color: Colors.blue,
                onTap: () {
                  Navigator.of(context).pushNamed(
                    Routes.reportScreen,
                    arguments: ReportScreenArguments(reportType: ReportType.FOUND),
                  );
                },
              ),
              HomeCard(
                lable: "Report Missing",
                icon: Icons.search_rounded,
                color: Colors.purple,
                onTap: () {
                  Navigator.of(context).pushNamed(
                    Routes.reportScreen,
                    arguments: ReportScreenArguments(reportType: ReportType.MISSING),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 28),
          ReportsListWidget(
            title: "LAST REPORTS",
            reportsSource: ReportsSource.ALL,
          )
        ],
      ),
    );
  }
}

class HomeCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String lable;
  final Function onTap;
  const HomeCard({
    Key key,
    @required this.icon,
    @required this.color,
    @required this.lable,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(
                icon,
                size: 75,
                color: color,
              ),
              SizedBox(height: 24),
              Text(
                lable,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
