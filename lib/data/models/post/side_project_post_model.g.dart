// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'side_project_post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SideProjectPostModel _$SideProjectPostModelFromJson(
  Map<String, dynamic> json,
) => SideProjectPostModel(
  id: json['id'] as String?,
  title: json['title'] as String?,
  content: json['content'] as String?,
  sprintDurations: json['sprintDurations'] as String?,
  referenceLink: (json['referenceLink'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  projectRoles: (json['projectRoles'] as List<dynamic>?)
      ?.map((e) => ProjectRoleModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  applications: (json['applications'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
  expiredAt: json['expiredAt'] == null
      ? null
      : DateTime.parse(json['expiredAt'] as String),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$SideProjectPostModelToJson(
  SideProjectPostModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'content': instance.content,
  'sprintDurations': instance.sprintDurations,
  'referenceLink': instance.referenceLink,
  'projectRoles': instance.projectRoles,
  'applications': instance.applications,
  'expiredAt': instance.expiredAt?.toIso8601String(),
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

ProjectRoleModel _$ProjectRoleModelFromJson(Map<String, dynamic> json) =>
    ProjectRoleModel(
      roleName: json['roleName'] as String?,
      requiredCount: (json['requiredCount'] as num?)?.toInt(),
      currentCount: (json['currentCount'] as num?)?.toInt(),
      isClosed: json['isClosed'] as bool?,
    );

Map<String, dynamic> _$ProjectRoleModelToJson(ProjectRoleModel instance) =>
    <String, dynamic>{
      'roleName': instance.roleName,
      'requiredCount': instance.requiredCount,
      'currentCount': instance.currentCount,
      'isClosed': instance.isClosed,
    };
