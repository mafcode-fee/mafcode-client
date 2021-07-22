import 'package:json_annotation/json_annotation.dart';

part 'report.g.dart';

enum ReportType {
  @JsonValue("MISSING")
  MISSING,
  @JsonValue("FOUND")
  FOUND
}

extension ReportTypeExt on ReportType {
  String get lowerCaseString => this.toString().split(".").last.toLowerCase();
}

@JsonSerializable(includeIfNull: false)
class Report {
  final String id;
  @JsonKey(name: "report_type")
  final ReportType reportType;
  @JsonKey(name: "matched_reports")
  final List<String> matchedReportsIds;
  @JsonKey(name: "latitude")
  final double latitude;
  @JsonKey(name: "longitude")
  final double longitude;
  @JsonKey(name: "photo_id")
  final String photoId;
  final String name;
  final double age;
  @JsonKey(name: "clothing")
  final String clothings;
  final String notes;
  @JsonKey(name: "creator")
  final String creatorId;

  Report({
    this.id,
    this.reportType,
    this.latitude,
    this.longitude,
    this.photoId,
    this.name,
    this.age,
    this.clothings,
    this.notes,
    this.matchedReportsIds,
    this.creatorId,
  });

  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);
  Map<String, dynamic> toJson() => _$ReportToJson(this);
}
