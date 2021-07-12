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
    //var response = await dio.post(url, data: FormData.fromMap(map));
    var response = await dio.get(url);
    return response.data;
  }

//  Future loadString() async {
//    String url = "http://10.0.2.2/GoApp/locations.php";
//    final http.Response response = await http.get(url);
//    final dynamic responsebody = jsonDecode(response.body);
//    print(responsebody);
//    return responsebody;
//  }

  List<Marker> allMarkers = [];
  GoogleMapController _controller;

  @override
  void initState() {
    // TODO: implement initState
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
                onMapCreated: mapCreated,
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

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }
}

//  Completer<GoogleMapController> _controller = Completer();
//
//  final Set<Marker> markers = Set.of([]);
//
//  static final CameraPosition _firstLocation = CameraPosition(
//    target: LatLng(30.7051689, 30.9516758),
//    zoom: 8,
//  );
//
//  void addMarker() async {
//    final cont = await _controller.future;
//    final s = MediaQuery.of(context).size;
//    final pos = await cont.getLatLng(
//      ScreenCoordinate(x: s.width ~/ 2, y: s.height ~/ 2),
//    );
//    final m = Marker(
//      markerId: MarkerId(pos.toString()),
//      position: pos,
//      onTap: () {},
//    );
//    setState(() {
//      markers.add(m);
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    final s = MediaQuery.of(context).size;
//    return new Scaffold(
//      body: Stack(
//        children: [
//          GoogleMap(
//            onTap: (pos) {},
//            markers: markers,
//            mapType: MapType.normal,
//            initialCameraPosition: _firstLocation,
//            onMapCreated: (GoogleMapController controller) {
//              _controller.complete(controller);
//            },
//          ),
//          Positioned(
//            left: (s.width / 2) - 25,
//            top: (s.height / 2) - 25,
//            child: SizedBox(
//              width: 50,
//              height: 50,
//              child: Icon(Icons.location_searching_outlined),
//            ),
//          )
//        ],
//      ),
//      floatingActionButton: FloatingActionButton.extended(
//        label: Text("Add"),
//        icon: Icon(Icons.add),
//        onPressed: addMarker,
//      ),
//      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
//    );
//  }
//}