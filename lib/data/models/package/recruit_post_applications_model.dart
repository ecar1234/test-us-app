
import 'package:json_annotation/json_annotation.dart';

import '../application/application_model.dart';
import '../image/image_model.dart';
import '../user/user_model.dart';

part 'recruit_post_applications_model.g.dart';

@JsonSerializable()
class User {
  String? userId;
  String? nickname;
  String? email;
  ImageModel? profileImg;
  UserType? userType;
  UserRole? role;
  DateTime? createdAt;
  DateTime? updatedAt;

  User({this.userId, this.nickname, this.email, this.profileImg, this.userType, this.role, this.createdAt, this.updatedAt});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
@JsonSerializable()
class Application {
  int? id;
  ApplicationPlatform? platform;
  MobileOsType? mobileOs;
  ApplicationStatus? status;
  String? postId;
  DateTime? appliedAt;
  DateTime? updatedAt;

  Application({this.id, this.platform, this.mobileOs, this.status, this.postId, this.appliedAt, this.updatedAt});

  factory Application.fromJson(Map<String, dynamic> json) => _$ApplicationFromJson(json);
}

@JsonSerializable()
class TResRecruitPostApplicationsInfo {
  User? user;
  Application? application;
  TResRecruitPostApplicationsInfo({this.application, this.user});

  factory TResRecruitPostApplicationsInfo.fromJson(Map<String, dynamic> json) => _$TResRecruitPostApplicationsInfoFromJson(json);
}