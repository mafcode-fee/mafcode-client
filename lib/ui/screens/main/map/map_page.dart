import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  final Set<Marker> markers = Set.of([]);

  static final CameraPosition _firstLocation = CameraPosition(
    target: LatLng(30.7051689, 30.9516758),
    zoom: 8,
  );

  void addMarker() async {
    final cont = await _controller.future;
    final s = MediaQuery.of(context).size;
    final pos = await cont.getLatLng(
      ScreenCoordinate(x: s.width ~/ 2, y: s.height ~/ 2),
    );
    final m = Marker(
      markerId: MarkerId(pos.toString()),
      position: pos,
      onTap: () {},
    );
    setState(() {
      markers.add(m);
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = MediaQuery.of(context).size;
    return new Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onTap: (pos) {},
            markers: markers,
            mapType: MapType.normal,
            initialCameraPosition: _firstLocation,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Positioned(
            left: (s.width / 2) - 25,
            top: (s.height / 2) - 25,
            child: SizedBox(
              width: 50,
              height: 50,
              child: Icon(Icons.location_searching_outlined),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Add"),
        icon: Icon(Icons.add),
        onPressed: addMarker,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
