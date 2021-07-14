import 'dart:convert';
import 'dart:io';

import 'package:mafcode/core/models/report.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'api.g.dart';

@RestApi()
abstract class Api {
  final String baseUrl;

  factory Api(Dio dio, {String baseUrl}) = _Api;

  @GET("/reports")
  Future<List<Report>> getAllReports();

  @POST("/reports/{reportType}")
  @MultiPart()
  Future<Report> createReportJsonString(
    @Header("Authorization") String token,
    @Path("reportType") String reportTypeString,
    @Part(name: "image") File image,
    @Part(name: "payload") String reportJsonString,
  );

  @GET("/report/{reportId}")
  Future<Report> getReport(@Path() String reportId);

  @GET("/report/{reportId}/matchings")
  Future<List<Report>> getmatchingReports(@Path() String reportId);
}

extension ApiExt on Api {
  String getImageUrlFromId(String imageId) => "$baseUrl/img/$imageId";

  Future<Report> createReport(
    String token,
    ReportType reportType,
    Report report,
    File image,
  ) =>
      createReportJsonString(
        "bearer $token",
        reportType.lowerCaseString,
        image,
        json.encode(report.toJson()),
      );

  Future<Report> createMissingReport(String token, Report report, File image) =>
      createReport(token, ReportType.MISSING, report, image);

  Future<Report> createFoundReport(String token, Report report, File image) =>
      createReport(token, ReportType.FOUND, report, image);
}
