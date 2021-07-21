import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mafcode/core/di/providers.dart';
import 'package:mafcode/ui/screens/main/home/reports_list_store.dart';
import 'package:mafcode/ui/screens/matches/matches_screen.dart';
import 'package:mafcode/ui/shared/error_widget.dart';

import '../../../auto_router_config.gr.dart';

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
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.matchesScreen,
                    arguments: MatchesScreenArguments(reportId: "60f81f1d7d73b09cb0706614"));
              },
              child: Text("test")),
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
                            if (r.clothings != null) ...[SizedBox(height: 10), Text("Clothings: ${r.clothings ?? ""}")],
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
