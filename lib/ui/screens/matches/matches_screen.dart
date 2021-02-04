import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:mafcode/core/di/providers.dart';
import 'package:mafcode/core/models/report.dart';
import 'package:mafcode/core/network/api.dart';

const IP = "http://10.0.2.2:5000";

class MatchesScreen extends StatefulWidget {
  final String reportId;
  const MatchesScreen({Key key, @required this.reportId}) : super(key: key);

  @override
  _MatchesScreenState createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text("Matches"),
    //   ),
    //   body: _images == null
    //       ? Center(
    //           child: CircularProgressIndicator(),
    //         )
    //       : GridView.builder(
    //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //             crossAxisCount: 2,
    //             childAspectRatio: 2 / 3,
    //           ),
    //           itemCount: _images.length,
    //           itemBuilder: (context, index) {
    //             return Container();
    //           },
    //         ),
    // );
    return Scaffold();
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
          Image.network(
            api.getImageUrlFromId(report.photoId),
            fit: BoxFit.cover,
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
