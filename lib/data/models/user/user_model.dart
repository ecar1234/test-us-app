import 'package:json_annotation/json_annotation.dart';

import '../application/application_model.dart';
import '../image/image_model.dart';
part 'user_model.g.dart';

enum UserType {
  @JsonValue('INDIVIDUALS')
  individuals,
  @JsonValue('COMPANIES')
  companies,
}

enum UserRole {
  @JsonValue('PROGRAMMER')
  programmer,
  @JsonValue('DESIGNER')
  designer,
  @JsonValue('MANAGER')
  manager,
  @JsonValue('MARKETER')
  marketer,
  @JsonValue('PLANNER')
  planner,
  @JsonValue('PUBLISHER')
  publisher,
  @JsonValue('ANALYST')
  analyst,
  @JsonValue('OPERATOR')
  operator,
  @JsonValue('PM')
  pm,
  @JsonValue('QA')
  qa,
  @JsonValue('CS')
  cs
}
enum AuthType {
  @JsonValue('EMAIL')
  email,
  @JsonValue('GOOGLE')
  google,
  @JsonValue('NAVER')
  naver
}

@JsonSerializable()
class UserModel {
  String? userId;
  String? email;
  String? password;
  String? nickname;
  ImageModel? profileImg;
  UserType? userType;
  UserRole? role;
  String? userName;
  DateTime? birth;
  AuthType? method;
  List<ApplicationModel>? applications;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserModel({
    this.userId,
    this.email,
    this.password,
    this.nickname,
    this.profileImg,
    this.userType,
    this.role,
    this.userName,
    this.birth,
    this.method,
    this.applications,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}