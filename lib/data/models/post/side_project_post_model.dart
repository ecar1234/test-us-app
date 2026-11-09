import 'package:json_annotation/json_annotation.dart';
import 'package:test_us_app/data/models/application/application_model.dart';
import 'package:test_us_app/data/models/post/recruit_post_model.dart';
import 'package:test_us_app/data/models/user/user_model.dart';

part 'side_project_post_model.g.dart';

@JsonSerializable()
class SideProjectPostModel {
  String? id;
  UserModel? author;
  String? postType;
  String? title;
  String? content;
  ApplicationPlatform? platform;
  MobileOsType? mobileOs;
  PostCategory? category;
  PostStatus? status;
  int? period;

  String? sprintDurations;
  List<String>? referenceLink;
  List<ProjectRoleModel>? projectRoles;
  List<int>? applications;
  DateTime? expiredAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  SideProjectPostModel({
    this.id,
    this.title,
    this.content,
    this.sprintDurations,
    this.referenceLink,
    this.projectRoles,
    this.applications,
    this.expiredAt,
    this.createdAt,
    this.updatedAt,
  });

  factory SideProjectPostModel.fromJson(Map<String, dynamic> json) => _$SideProjectPostModelFromJson(json);
}

@JsonSerializable()
class ProjectRoleModel {
  String? roleName;
  int? requiredCount;
  int? currentCount;
  bool? isClosed;

  ProjectRoleModel({
    this.roleName,
    this.requiredCount,
    this.currentCount,
    this.isClosed
});

  factory ProjectRoleModel.fromJson(Map<String, dynamic> json) => _$ProjectRoleModelFromJson(json);
}
