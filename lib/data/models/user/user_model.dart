import 'package:json_annotation/json_annotation.dart';
part 'user_model.g.dart';

enum UserType {
  @JsonValue('INDIVIDUALS')
  individuals,
  @JsonValue('ORGANIZATIONS')
  organizations
}

@JsonSerializable()
class UserModel {
  String? userId;
  String? email;
  String? nickName;
  UserType? userType;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserModel({
    this.userId,
    this.email,
    this.nickName,
    this.userType,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}