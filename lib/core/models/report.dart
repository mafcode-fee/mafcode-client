import 'package:json_annotation/json_annotation.dart';

part 'report.g.dart';

enum ReportType {
  @JsonValue("MISSING")
  MISSING,
  @JsonValue("FOUND")
  FOUND
}

@JsonSerializable()
class Report {
  final String id;
  @JsonKey(name: "report_type")
  final ReportType reportType;
  @JsonKey(name: "matched_person")
  final String matchedPerson;
  final String name;
  @JsonKey(name: "last_seen_location")
  final List<double> lastSeenLocation;
  final double age;
  final String clothings;
  final String notes;

  Report(
    this.id,
    this.reportType,
    this.matchedPerson,
    this.name,
    this.lastSeenLocation,
    this.age,
    this.clothings,
    this.notes,
  );

  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);
  Map<String, dynamic> toJson() => _$ReportToJson(this);
}
