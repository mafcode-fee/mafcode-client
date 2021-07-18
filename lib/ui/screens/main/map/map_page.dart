import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mafcode/core/di/providers.dart';
import 'package:mafcode/core/models/report.dart';
import 'package:mafcode/core/network/api.dart';

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
    final Future<List<Report>> _future = useMemoized(() {
      return api.getAllReports();
    });
    return Scaffold(
      body: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: FutureBuilder(
            future: _future,
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              List<dynamic> parsedJson = snapshot.data;
              allMarkers = parsedJson.map((i) {
                String name = i['name'];
                int age = i['age'];
                return Marker(
                  markerId: MarkerId(i['id']),
                  position: LatLng(i['latitude'], i['longitude']),
                  //infoWindow: InfoWindow(title: 'my name is nagwa'),
                  infoWindow: InfoWindow(title: ' $name , $age years old'),
                  onTap: () {},
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
