import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mafcode/core/network/api.dart';
import 'package:mafcode/ui/screens/main/home/last_reports_store.dart';
import 'package:mafcode/ui/screens/report/report_screen_store.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:riverpod/all.dart';

final dioProvider = Provider<Dio>((_) {
  final dio = Dio();
  if (kDebugMode) {
    dio.interceptors.add(PrettyDioLogger());
  }
  return dio;
});

final apiProvider = Provider((ref) => Api(
      ref.read(dioProvider),
      baseUrl: "http://13.92.138.210:4000",
    ));

final lastReportsStoreProvider = Provider(
  (ref) => LastReportsStore(ref.read(apiProvider)),
);

final reportScreenStoreProvider = Provider<ReportScreenStore>((ref) {
  return ReportScreenStore(ref.read(apiProvider));
});
