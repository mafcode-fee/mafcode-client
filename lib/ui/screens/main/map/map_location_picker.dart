import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapLocationPicker extends StatefulWidget {
  final LocationData locationData;

  const MapLocationPicker({Key key, this.locationData}) : super(key: key);
  @override
  State<MapLocationPicker> createState() => MapLocationPickerState();
}

class MapLocationPickerState extends State<MapLocationPicker> {
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _kGooglePlex;
  final Set<Marker> markers = Set.of([]);
  @override
  void initState() {
    _kGooglePlex = CameraPosition(
      target:
          LatLng(widget.locationData.latitude, widget.locationData.longitude),
      zoom: 7,
    );
    super.initState();
  }

  void placeMarker(LatLng pos) {
    markers.clear();
    setState(() {
      markers.add(
        Marker(
          markerId: MarkerId(pos.toString()),
          position: pos,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: GoogleMap(
        onTap: placeMarker,
        markers: markers,
        mapType: MapType.terrain,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (markers.isNotEmpty)
            Navigator.pop(context, markers.single.position);
          else if (markers.isEmpty) ;
        },
        label: Text('Done'),
        icon: Icon(Icons.done),
      ),
    );
  }

  // Future<void> _goTo() {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  // }
}
