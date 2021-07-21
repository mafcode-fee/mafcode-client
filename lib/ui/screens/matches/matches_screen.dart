import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mafcode/core/di/providers.dart';
import 'package:mafcode/core/models/report.dart';
import 'package:mafcode/core/network/api.dart';
import 'package:mafcode/ui/screens/matches/matches_notifier.dart';
import 'package:mafcode/ui/shared/error_widget.dart';
import 'package:mafcode/ui/shared/network_image_widget.dart';

const IP = "http://40.114.123.215:5000";

class MatchesScreen extends HookWidget {
  final String reportId;

  const MatchesScreen({Key key, @required this.reportId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifer = useProvider(matchesNotifierProvider);
    final state = useProvider(matchesNotifierProvider.state);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        notifer.findMatches(reportId);
      });
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: Text("Matches"),
      ),
      body: state.when(
        data: (matches) {
          if (matches.isEmpty)
            return Center(
              child: Text("There are no matches for your report in the current moment"),
            );
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2 / 3,
            ),
            itemCount: matches.length,
            itemBuilder: (context, index) {
              return MatchReportCard(
                report: matches[index],
              );
            },
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(),
        ),
        error: (err, stk) {
          debugPrintStack(label: err.toString(), stackTrace: stk);
          return MafcodeErrorWidget(
            err,
            onReload: () {
              notifer.findMatches(reportId);
            },
          );
        },
      ),
    );
  }
}

class MatchReportCard extends HookWidget {
  final Report report;
  final EdgeInsets margin;
  final bool showName;

  const MatchReportCard({
    Key key,
    @required this.report,
    this.margin = const EdgeInsets.all(24),
    this.showName = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final api = useProvider(apiProvider);
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      margin: margin,
      child: Stack(
        fit: StackFit.expand,
        children: [
          NetworkImageWidget(
            api.getImageUrlFromId(report.photoId),
          ),
          if (showName)
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                report.name,
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                ),
              ),
            )
        ],
      ),
    );
  }
}
