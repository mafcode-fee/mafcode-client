import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:mafcode/core/di/providers.dart';
import 'package:mafcode/core/models/report.dart';
import 'package:mafcode/ui/auto_router_config.gr.dart';
import 'package:mafcode/ui/screens/matches/matches_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
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
              color: Colors.red,
              onTap: () {
                Navigator.of(context).pushNamed(
                  Routes.reportScreen,
                  arguments:
                      ReportScreenArguments(reportType: ReportType.FOUND),
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
                  arguments:
                      ReportScreenArguments(reportType: ReportType.MISSING),
                );
              },
            ),
          ],
        ),
        SizedBox(height: 28),
        LastReportsWidget()
      ],
    );
  }
}

class LastReportsWidget extends HookWidget {
  const LastReportsWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = useProvider(lastReportsStoreProvider);
    useEffect(() {
      store.getLastReports();
      return null;
    }, []);
    return Observer(builder: (_) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "LAST REPORTS",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
          SizedBox(height: 28),
          if (store.hasError)
            Text(
              store.error,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red),
            )
          else if (store.isLoading)
            Center(
              child: CircularProgressIndicator(),
            )
          else if (store.lastReports.isEmpty)
            Center(
              child: Text(
                "Nothing here yet.\nFuture Reports will appear here.",
                textAlign: TextAlign.center,
              ),
            )
          else
            ...store.lastReports.map(
              (r) => Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              r.reportType.toString().split(".").last,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text("Name: ${r.name}"),
                            SizedBox(height: 10),
                            Text("Age: ${r.age.round()}"),
                            if (r.clothings != null) ...[
                              SizedBox(height: 10),
                              Text("Clothings: ${r.clothings ?? ""}")
                            ],
                          ],
                        ),
                      ),
                      Container(
                        width: 100,
                        height: 150,
                        child: MatchReportCard(
                          report: r,
                          margin: EdgeInsets.all(8),
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                ],
              ),
            ),
        ],
      );
    });
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
                size: 80,
                color: color,
              ),
              SizedBox(height: 24),
              Text(
                lable,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
