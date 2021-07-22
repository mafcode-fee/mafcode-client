import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mafcode/core/models/login_result.dart';
import 'package:mafcode/core/models/report.dart';
import 'package:mafcode/core/models/user_info.dart';
import 'package:retrofit/retrofit.dart';

part 'api.g.dart';

@RestApi()
abstract class Api {
  final String baseUrl;

  factory Api(Dio dio, {String baseUrl}) = _Api;

  @POST("/login")
  @FormUrlEncoded()
  Future<LoginResult> login(@Field() String email, @Field() String password);

  @POST("/register")
  @FormUrlEncoded()
  Future<HttpResponse> register({
    @required @Field() String email,
    @required @Field() String password,
    @required @Field("first_name") firstName,
    @required @Field("last_name") String lastName,
    @required @Field() String contact,
  });

  @GET("/me/info")
  Future<UserInfo> getCurrentUserInfo();

  @POST("/me/update")
  @FormUrlEncoded()
  Future<UserInfo> updateCurrentUserInfo({
    @Field() String email,
    @Field() String password,
    @Field("new_password") String newPassword,
    @Field("first_name") firstName,
    @Field("last_name") String lastName,
    @Field() String contact,
  });

  @GET("/user/{userId}")
  Future<UserInfo> getUserById(
    @Path("userId") String userId,
  );

  @POST("/me/update_photo")
  @MultiPart()
  Future<UserInfo> changeCurrentUserPhoto(
    @Part(name: "image") File image,
  );

  @GET("/reports")
  Future<List<Report>> getAllReports();

  @GET("/me/reports")
  Future<List<Report>> getCurrentUserReports();

  @POST("/reports/{reportType}")
  @MultiPart()
  Future<Report> createReportJsonString(
    @Path("reportType") String reportTypeString,
    @Part(name: "image") File image,
    @Part(name: "payload") String reportJsonString,
  );

  @GET("/reports/{reportId}")
  Future<Report> getReport(@Path() String reportId);

  @GET("/reports/{reportId}/matchings")
  Future<List<Report>> getmatchingReports(@Path() String reportId);
}

extension ApiExt on Api {
  String getImageUrlFromId(String imageId) => "$baseUrl/img/$imageId";

  Future<Report> createReport(
    ReportType reportType,
    Report report,
    File image,
  ) =>
      createReportJsonString(
        reportType.lowerCaseString,
        image,
        json.encode(report.toJson()),
      );

  Future<Report> createMissingReport(Report report, File image) => createReport(ReportType.MISSING, report, image);

  Future<Report> createFoundReport(Report report, File image) => createReport(ReportType.FOUND, report, image);
}
