import 'dart:math';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mafcode/ui/screens/matches/api_service.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({Key key}) : super(key: key);

  @override
  _MatchesScreenState createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  List<dynamic> _images;

  Future<dynamic> _searchRequest() async {
    return ApiService.searchRequest(null);
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
                        _images[index]['img_url'],
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
