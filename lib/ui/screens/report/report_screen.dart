import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mafcode/ui/auto_router_config.gr.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ReportScreen extends HookWidget {
  const ReportScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final picker = useMemoized(() => ImagePicker());
    final imageFile = useState<File>(null);
    return Scaffold(
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
              color: imageFile.value != null ? null : Colors.blueGrey.shade100,
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
                final pickedFile =
                    await picker.getImage(source: ImageSource.gallery);
                if (pickedFile != null) imageFile.value = File(pickedFile.path);
              },
            ),
          ),
          const SizedBox(height: 25),
          TextField(
            decoration: InputDecoration(labelText: "Name"),
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
          ),
          const SizedBox(height: 5),
          TextField(
            decoration: InputDecoration(labelText: "Clothing"),
          ),
          const SizedBox(height: 5),
          TextField(
            decoration: InputDecoration(labelText: "Other Notes"),
          ),
          const SizedBox(height: 35),
          RaisedButton(
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            child: Text("Report"),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(Routes.matchesScreen,
                  arguments: MatchesScreenArguments(
                    file: imageFile.value,
                  ));
            },
          ),
        ],
      ),
    );
  }
}
