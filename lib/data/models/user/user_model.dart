import 'package:json_annotation/json_annotation.dart';
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

@JsonSerializable()
class UserModel {
  String? userId;
  String? email;
  String? password;
  String? nickname;
  UserType? userType;
  UserRole? role;
  String? userName;
  DateTime? birth;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserModel({
    this.userId,
    this.email,
    this.password,
    this.nickname,
    this.userType,
    this.role,
    this.userName,
    this.birth,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}