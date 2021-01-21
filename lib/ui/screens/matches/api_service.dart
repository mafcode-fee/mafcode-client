import 'dart:math';

import 'package:dio/dio.dart';

class ApiService {
  static Future<dynamic> searchRequest(
    MultipartFile imageFile,
  ) async {
    //TODO: implement real function
    await Future.delayed(
      Duration(milliseconds: Random().nextInt(5000)),
    );
    return [
      {
        "name": "tarek",
        "img_url":
            "https://ideapod.com/wp-content/uploads/2017/08/person-1.jpg",
      },
      {
        "name": "hossam",
        "img_url":
            "https://api.time.com/wp-content/uploads/2017/12/terry-crews-person-of-year-2017-time-magazine-2.jpg?w=800&quality=85",
      },
      {
        "name": "John Doe",
        "img_url":
            "https://eitrawmaterials.eu/wp-content/uploads/2016/09/person-icon.png"
      }
    ];
  }
}
