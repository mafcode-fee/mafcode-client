import 'package:meta/meta.dart';
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
  @protected
  Future<Report> createReport(
    @Path() String reportType,
    @Body() Report report,
  );

  @GET("/report/{reportId}")
  Future<Report> getReport(@Path() String reportId);

  @GET("/report/{reportId}/matchings")
  Future<List<Report>> getmatchingReports(@Path() String reportId);
}

extension ApiExt on Api {
  String getImageUrlFromId(String imageId) => "$baseUrl/$imageId";

  Future<Report> createMissingReport(@Body() Report report) =>
      createReport("missing", report);

  Future<Report> createFoundReport(@Body() Report report) =>
      createReport("found", report);
}
