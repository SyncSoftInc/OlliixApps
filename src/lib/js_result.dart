import 'package:json_annotation/json_annotation.dart';

part 'js_result.g.dart';

@JsonSerializable()
class JSResult {
  JSResult();

  @JsonKey(defaultValue: false, name: "Success")
  bool success = false;
  @JsonKey(defaultValue: "", name: "Error")
  String error = "";
  @JsonKey(defaultValue: "", name: "Value")
  String value = "";

  factory JSResult.fromJson(Map<String, dynamic> json) => _$JSResultFromJson(json);
  Map<String, dynamic> toJson() => _$JSResultToJson(this);
}
