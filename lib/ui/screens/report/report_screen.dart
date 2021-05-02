import 'dart:io';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mafcode/core/di/providers.dart';
import 'package:mafcode/core/models/report.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mafcode/ui/auto_router_config.gr.dart';

class ReportScreen extends HookWidget {
  final location = new Location();
  final ReportType reportType;
  ReportScreen(this.reportType, {Key key}) : super(key: key);

  Future getLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await this.location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await this.location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await this.location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await this.location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    var location = await this.location.getLocation();
    return location;
  }

  Future<void> showMafcodeDialog(
      {String message, String title, BuildContext context}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Dismess'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final picker = useMemoized(() => ImagePicker());
    final imageFile = useState<File>(null);
    final store = useProvider(reportScreenStoreProvider);
    final nameController = useTextEditingController();
    final latitudeController = useTextEditingController();
    final longitudeController = useTextEditingController();
    final ageController = useTextEditingController();
    final clothingsController = useTextEditingController();
    final notesController = useTextEditingController();
    return Observer(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text("Report Fonud"),
        ),
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Container(
              width: 200,
              height: 200,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color:
                    imageFile.value != null ? null : Colors.blueGrey.shade100,
                border: Border.all(color: Colors.grey),
                shape: BoxShape.circle,
              ),
              child: imageFile.value != null
                  ? Image.file(
                      imageFile.value,
                      fit: BoxFit.contain,
                    )
                  : Icon(
                      MdiIcons.imageOff,
                      size: 50,
                    ),
            ),
            const SizedBox(height: 25),
            Align(
              child: RaisedButton(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(MdiIcons.camera),
                    const SizedBox(width: 10),
                    Text("Add Image"),
                  ],
                ),
                onPressed: () async {
                  final pickedFile = await showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text("Pick Image from"),
                            Spacer(),
                            FlatButton(
                              onPressed: () async {
                                Navigator.of(context).pop(
                                  await picker.getImage(
                                      source: ImageSource.gallery),
                                );
                              },
                              child: Text("Gallery"),
                              textColor: Colors.blueAccent,
                            ),
                            FlatButton(
                              onPressed: () async {
                                Navigator.of(context).pop(
                                  await picker.getImage(
                                      source: ImageSource.camera),
                                );
                              },
                              child: Text("Camera"),
                              textColor: Colors.blueAccent,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );

                  if (pickedFile != null)
                    imageFile.value = File(pickedFile.path);
                },
              ),
            ),
            const SizedBox(height: 25),
            TextField(
              decoration: InputDecoration(labelText: "Name"),
              controller: nameController,
            ),
            const SizedBox(height: 10),
            Text("Location"),
            // const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(labelText: "latitude"),
                    controller: latitudeController,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(labelText: "longitude"),
                    controller: longitudeController,
                  ),
                ),
                const SizedBox(width: 15),
                RaisedButton(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(MdiIcons.crosshairsGps),
                      const SizedBox(width: 5),
                      Text("GPS"),
                    ],
                  ),
                  onPressed: () async {
                    var location = await getLocation();
                    if (location is! LocationData)
                      showMafcodeDialog(
                          message:
                              "In order to get location automatically, you have to enable location permissions",
                          context: useContext());
                    else {
                      latitudeController.text = location.latitude.toString();
                      longitudeController.text = location.longitude.toString();
                    }
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                RaisedButton(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(MdiIcons.map),
                      const SizedBox(width: 5),
                      Text("Map"),
                    ],
                  ),
                  onPressed: () async {
                    LocationData location = await getLocation();
                    if (location is! LocationData)
                      showMafcodeDialog(
                          message:
                              "In order to get location automatically, you have to enable location permissions",
                          context: useContext());
                    else {
                      var location = await getLocation();
                      location = await Navigator.of(context).pushNamed(
                          Routes.mapLocationPicker,
                          arguments: MapLocationPickerArguments(
                              locationData: location));
                      latitudeController.text = location.latitude.toString();
                      longitudeController.text = location.longitude.toString();
                    }
                  },
                ),
              ],
            ),
            TextField(
              decoration: InputDecoration(labelText: "Age"),
              controller: ageController,
            ),
            const SizedBox(height: 5),
            TextField(
              decoration: InputDecoration(labelText: "Clothing"),
              controller: clothingsController,
            ),
            const SizedBox(height: 5),
            TextField(
              decoration: InputDecoration(labelText: "Other Notes"),
              controller: notesController,
            ),
            const SizedBox(height: 35),
            if (store.hasError)
              Text(
                store.error,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red),
              )
            else if (store.isLoading)
              Center(
                child: CircularProgressIndicator(),
              )
            else
              RaisedButton(
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                child: Text("Report"),
                onPressed: () {
                  store.postNewReport(
                    reportType: reportType,
                    file: imageFile.value,
                    name: nameController.text,
                    latitude: double.parse(latitudeController.text),
                    longitude: double.parse(longitudeController.text),
                    age: ageController.text,
                    clothings: clothingsController.text,
                    notes: notesController.text,
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
