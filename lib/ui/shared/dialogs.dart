import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<File> showImagePickerDialog(BuildContext context) async {
  final picker = new ImagePicker();
  PickedFile pickedFile = await showDialog(
    context: context,
    builder: (context) => Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text("Pick Image from"),
            Spacer(),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(
                  await picker.getImage(source: ImageSource.gallery),
                );
              },
              child: Text("Gallery"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(
                  await picker.getImage(source: ImageSource.camera),
                );
              },
              child: Text("Camera"),
            ),
          ],
        ),
      ),
    ),
  );
  if (pickedFile == null) return null;
  return File(pickedFile.path);
}
