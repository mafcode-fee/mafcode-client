import 'package:json_annotation/json_annotation.dart';

part 'match.g.dart';

/*
    {
        "img_url": "/img/data/Joe Biden$$14f58ea8-5c11-11eb-933a-b06ebfc54c3b$$10-biden-candidatepage-videoSixteenByNineJumbo1600.jpg",
        "name": "Joe Biden"
    }
*/

@JsonSerializable()
class Match {
  @JsonKey(name: "img_url")
  final String imgUrl;
  final String name;
  Match(this.imgUrl, this.name);

  factory Match.fromJson(Map<String, dynamic> json) => _$MatchFromJson(json);
  Map<String, dynamic> toJson() => _$MatchToJson(this);
}
