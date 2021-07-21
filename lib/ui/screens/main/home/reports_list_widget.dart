import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mafcode/core/di/providers.dart';
import 'package:mafcode/core/models/report.dart';
import 'package:mafcode/ui/screens/main/home/reports_list_store.dart';
import 'package:mafcode/ui/screens/matches/matches_screen.dart';
import 'package:mafcode/ui/shared/error_widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ReportsListWidget extends HookWidget {
  final String title;
  final ReportsSource reportsSource;

  const ReportsListWidget({
    @required this.title,
    @required this.reportsSource,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = useProvider(reportsListStoreProvider(reportsSource));
    useEffect(() {
      store.getReports();
      return null;
    }, []);
    return Observer(builder: (_) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
          // ElevatedButton(
          //     onPressed: () {
          //       Navigator.of(context).pushNamed(Routes.matchesScreen,
          //           arguments: MatchesScreenArguments(reportId: "60f81f1d7d73b09cb0706614"));
          //     },
          //     child: Text("test")),
          SizedBox(height: 28),
          if (store.hasError)
            MafcodeErrorWidget(
              store.error,
              onReload: () => store.getReports(),
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
              (r) => ReportWidget(r),
            ),
        ],
      );
    });
  }
}

class ReportWidget extends StatelessWidget {
  final Report report;

  const ReportWidget(
    this.report, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData icon = report.reportType == ReportType.FOUND ? MdiIcons.mapMarker : MdiIcons.accountSearch;
    Color color = report.reportType == ReportType.FOUND ? Colors.green : Colors.red;
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        color: color,
                      ),
                      SizedBox(width: 10),
                      Text(
                        report.reportType.toString().split(".").last,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Table(
                    columnWidths: {
                      0: FixedColumnWidth(40),
                      1: FixedColumnWidth(65),
                      3: FlexColumnWidth(),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      buildInfoRow(Icons.drive_file_rename_outline, "Name", report.name),
                      buildInfoRow(Icons.person, "Age", report.age?.toString()),
                      buildInfoRow(MdiIcons.tshirtV, "Clothes", report.clothings),
                      buildInfoRow(MdiIcons.note, "Notes", report.notes),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 100,
              height: 150,
              child: MatchReportCard(
                report: report,
                margin: EdgeInsets.all(8),
              ),
            ),
          ],
        ),
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: () {},
              icon: Icon(MdiIcons.mapSearch),
              label: Text("Open Location"),
            ),
            Spacer(),
            OutlinedButton.icon(
              onPressed: () {},
              icon: Icon(MdiIcons.faceRecognition),
              label: Text("Matching Reports"),
            ),
          ],
        ),
        Divider(),
      ],
    );
  }

  TableRow buildInfoRow(IconData icon, String lable, String info) {
    return TableRow(children: [
      Icon(icon),
      Text(
        lable,
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      Text(info == null || info.trim().isEmpty ? "---" : info),
    ]);
  }
}
