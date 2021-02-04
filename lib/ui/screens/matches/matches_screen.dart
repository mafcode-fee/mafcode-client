import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

const IP = "http://10.0.2.2:5000";

class MatchesScreen extends StatefulWidget {
  final File file;
  const MatchesScreen({Key key, @required this.file}) : super(key: key);

  @override
  _MatchesScreenState createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  List<dynamic> _images;

  Future<dynamic> _searchRequest() async {
    final formdata = FormData.fromMap({
      'image': await MultipartFile.fromFile(widget.file.path,
          filename: widget.file.path.split("/").last)
    });
    final response = await Dio().post("$IP/search", data: formdata);
    return response.data;
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final images = await _searchRequest();
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
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2 / 3,
              ),
              itemCount: _images.length,
              itemBuilder: (context, index) {
                return Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 4,
                  margin: const EdgeInsets.all(24),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        IP + _images[index]['img_url'],
                        fit: BoxFit.cover,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          _images[index]['name'],
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
    );
  }
}
