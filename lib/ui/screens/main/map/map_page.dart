import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Future _future;

  Dio dio = new Dio();
  Future getData() async {
    final String url = 'http://40.114.123.215:4000/reports';
    // var response = await dio.post(url, data: FormData.fromMap(map));
    var response = await dio.get(url);
    return response.data;
  }

  List<Marker> allMarkers = [];

  @override
  void initState() {
    super.initState();
    _future = getData();
  }

  @override
  Widget build(BuildContext context) {
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
                initialCameraPosition: CameraPosition(
                    target: LatLng(40.7128, -74.0060), zoom: 1.0),
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
