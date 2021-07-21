import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mafcode/core/network/api.dart';
import 'package:mafcode/ui/screens/main/home/last_reports_store.dart';
import 'package:mafcode/ui/screens/report/report_screen_store.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final dioProvider = Provider<Dio>((_) {
  final dio = Dio();

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options) async {
      final pref = await SharedPreferences.getInstance();
      if (pref.containsKey("token")) {
        final token = pref.getString("token");
        options.headers["Authorization"] = "bearer $token";
      }
      return options;
    },
  ));

  if (kDebugMode) {
    dio.interceptors.add(PrettyDioLogger(
      request: true,
      requestBody: true,
      requestHeader: true,
    ));
  }
  return dio;
});

final apiProvider = Provider((ref) => Api(
      ref.read(dioProvider),
      baseUrl: "http://127.0.0.1:5000",
    ));

final lastReportsStoreProvider = Provider(
  (ref) => LastReportsStore(ref.read(apiProvider)),
);

final reportScreenStoreProvider = Provider<ReportScreenStore>((ref) {
  return ReportScreenStore(ref.read(apiProvider));
});
