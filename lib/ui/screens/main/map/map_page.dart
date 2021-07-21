import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mafcode/core/di/providers.dart';
import 'package:mafcode/core/models/report.dart';
import 'package:mafcode/core/network/api.dart';
import 'package:mafcode/ui/screens/main/home/reports_list_widget.dart';
import 'package:mafcode/ui/shared/marker_generator.dart';

class MapSample extends StatefulHookWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Future<List<Report>> getData(Api api) async {
    var response = await api.getAllReports();
    return response;
  }

  List<Marker> allMarkers = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final api = useProvider(apiProvider);
    final foundMarker = useState(BitmapDescriptor.defaultMarker);
    final missingMarker = useState(BitmapDescriptor.defaultMarker);
    final Future<List<Report>> _future = useMemoized(() async {
      final markerGenerator = MarkerGenerator(100);
      foundMarker.value = await markerGenerator.createBitmapDescriptorFromIconData(
        iconData: Icons.person,
        iconColor: Colors.green,
        circleColor: Colors.green,
        backgroundColor: Colors.white,
      );
      missingMarker.value = await markerGenerator.createBitmapDescriptorFromIconData(
        iconData: Icons.person,
        iconColor: Colors.red,
        circleColor: Colors.red,
        backgroundColor: Colors.white,
      );
      return api.getAllReports();
    });
    return Scaffold(
      body: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: FutureBuilder<List<Report>>(
            future: _future,
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              List<Report> parsedJson = snapshot.data;
              allMarkers = parsedJson.map((report) {
                return Marker(
                  markerId: MarkerId(report.id),
                  position: LatLng(report.latitude, report.longitude),
                  //infoWindow: InfoWindow(title: 'my name is nagwa'),
                  infoWindow: InfoWindow(
                    title: report.reportType.toString().split(".").last.toLowerCase() + " report",
                    snippet: '${report.name} , ${report.age} years old',
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(height: 15),
                                  Text(
                                    "Report Details",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                  ),
                                  SizedBox(height: 15),
                                  ReportWidget(report),
                                ],
                              ),
                            );
                          });
                    },
                  ),
                  icon: report.reportType == ReportType.FOUND ? foundMarker.value : missingMarker.value,
                );
              }).toList();

              return GoogleMap(
                initialCameraPosition: CameraPosition(target: LatLng(40.7128, -74.0060), zoom: 1.0),
                markers: Set.from(allMarkers),
                mapType: MapType.normal,
                tiltGesturesEnabled: true,
                compassEnabled: true,
                rotateGesturesEnabled: true,
                myLocationEnabled: true,
              );
            },
          ),
        ),
      ]),
    );
  }
}
