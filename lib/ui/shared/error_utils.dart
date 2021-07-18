import 'package:dio/dio.dart';

class ErrorUtils {
  static String getMessage(dynamic e) {
    if (e is DioError) {
      if (e.type == DioErrorType.RESPONSE) {
        if (e.response is Map) {
          return e.response.data["message"];
        }
        return e.response.data.toString();
      } else {
        return e.message;
      }
    } else {
      return e.toString();
    }
  }
}
