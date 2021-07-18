import 'package:json_annotation/json_annotation.dart';

part 'login_result.g.dart';

@JsonSerializable()
class LoginResult {
  @JsonKey(name: "access_token")
  final String accessToken;
  final String message;

  LoginResult(this.accessToken, this.message);

  factory LoginResult.fromJson(Map<String, dynamic> json) => _$LoginResultFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResultToJson(this);
}
