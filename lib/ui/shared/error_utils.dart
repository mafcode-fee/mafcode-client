import 'package:dio/dio.dart';

class ErrorUtils {
  static String getMessage(dynamic e) {
    if (e is DioError) {
      if (e.type == DioErrorType.RESPONSE) {
        try {
          return e.response.data["message"];
        } catch (e) {
          return e.response.data.toString();
        }
      } else {
        return e.message;
      }
    } else {
      return e.toString();
    }
  }
}
