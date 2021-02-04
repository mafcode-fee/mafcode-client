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
  @JsonKey(name: "matched_person")
  final String matchedPerson;
  @JsonKey(name: "photo_id")
  final String photoId;
  final String name;
  @JsonKey(name: "last_seen_location")
  final List<double> lastSeenLocation;
  final double age;
  final String clothings;
  final String notes;

  Report({
    this.id,
    this.reportType,
    this.matchedPerson,
    this.photoId,
    this.name,
    this.lastSeenLocation,
    this.age,
    this.clothings,
    this.notes,
  });

  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);
  Map<String, dynamic> toJson() => _$ReportToJson(this);
}
