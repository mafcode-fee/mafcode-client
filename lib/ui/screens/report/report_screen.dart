import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mafcode/core/di/providers.dart';
import 'package:mafcode/core/models/report.dart';
import 'package:mafcode/ui/auto_router_config.gr.dart';
import 'package:mafcode/ui/screens/report/report_screen_store.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mobx/mobx.dart';

class ReportScreen extends HookWidget {
  final ReportType reportType;
  const ReportScreen(this.reportType, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final picker = useMemoized(() => ImagePicker());
    final imageFile = useState<File>(null);
    final store = useProvider(reportScreenStoreProvider);
    final nameController = useTextEditingController();
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
            const SizedBox(height: 5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(labelText: "Found Address"),
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
                  onPressed: () {},
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
