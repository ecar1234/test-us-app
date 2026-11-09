import 'package:test_us_app/data/models/post/side_project_post_model.dart';
import 'package:test_us_app/domain/entities/user_entity.dart';

import '../../data/models/application/application_model.dart';
import '../../data/models/post/recruit_post_model.dart';

class SideProjectPostEntity {
  String? id;
  String? title;
  String? content;
  ApplicationPlatform? platform;
  MobileOsType? mobileOs;
  PostCategory? category;
  PostStatus? status;
  int? period;
  int? views;
  String? postType;
  UserEntity? author;

  String? sprintDurations;
  List<String>? referenceLink;
  List<ProjectRoleEntity>? projectRoles;
  List<int>? applications;
  DateTime? expiredAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  SideProjectPostEntity({
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

  static SideProjectPostEntity toEntity(SideProjectPostModel model) {
    final roles = ProjectRoleEntity.toEntity(model.projectRoles!);
    return SideProjectPostEntity(
        id: model.id,
        title: model.title,
        content: model.content,
        sprintDurations: model.sprintDurations,
        referenceLink: model.referenceLink,
        projectRoles: roles,
        applications: model.applications,
        expiredAt: model.expiredAt,
        createdAt: model.createdAt,
        updatedAt: model.updatedAt
    );
  }
}

class ProjectRoleEntity {
  String? roleName;
  int? requiredCount;
  int? currentCount;
  bool? isClosed;

  ProjectRoleEntity({
    this.roleName,
    this.requiredCount,
    this.currentCount,
    this.isClosed
  });

  static List<ProjectRoleEntity> toEntity(List<ProjectRoleModel> model) {
    return model.map((e) =>
        ProjectRoleEntity(
            roleName: e.roleName,
            requiredCount: e.requiredCount,
            currentCount: e.currentCount,
            isClosed: e.isClosed
        )).toList();
  }
}
