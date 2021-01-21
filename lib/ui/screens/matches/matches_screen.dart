import 'dart:math';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({Key key}) : super(key: key);

  @override
  _MatchesScreenState createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  final _imageNumber = 10;
  List<Uint8List> _images;

  Future<Uint8List> _downloadAnImage({int waitTime}) async {
    waitTime ??= Random().nextInt(10);
    await Future.delayed(Duration(milliseconds: waitTime * 1000));
    final bytes = await Dio().get<List<int>>(
      "https://thispersondoesnotexist.com/image",
      options: Options(responseType: ResponseType.bytes),
    );
    return Uint8List.fromList(bytes.data);
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final images = <Uint8List>[];
      for (var _ in Iterable.generate(_imageNumber)) {
        images.add(await _downloadAnImage(waitTime: 0));
      }
      setState(() {
        _images = images;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Matches"),
      ),
      body: _images == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemCount: _imageNumber,
              itemBuilder: (context, index) {
                return Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 4,
                  margin: const EdgeInsets.all(24),
                  child: Image.memory(_images[index]),
                );
              },
            ),
    );
  }
}
