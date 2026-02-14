// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recruit_post_applications_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      userId: json['userId'] as String?,
      nickname: json['nickname'] as String?,
      email: json['email'] as String?,
      profileImg: json['profileImg'] == null
          ? null
          : ImageModel.fromJson(json['profileImg'] as Map<String, dynamic>),
      status: $enumDecodeNullable(_$UserStatusEnumMap, json['status']),
      userType: $enumDecodeNullable(_$UserTypeEnumMap, json['userType']),
      role: $enumDecodeNullable(_$UserRoleEnumMap, json['role']),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'userId': instance.userId,
      'nickname': instance.nickname,
      'email': instance.email,
      'profileImg': instance.profileImg,
      'status': _$UserStatusEnumMap[instance.status],
      'userType': _$UserTypeEnumMap[instance.userType],
      'role': _$UserRoleEnumMap[instance.role],
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$UserStatusEnumMap = {
  UserStatus.active: 'ACTIVE',
  UserStatus.inactive: 'INACTIVE',
  UserStatus.delete: 'DELETE',
};

const _$UserTypeEnumMap = {
  UserType.individuals: 'INDIVIDUALS',
  UserType.companies: 'COMPANIES',
  UserType.normal: 'NORMAL',
};

const _$UserRoleEnumMap = {
  UserRole.programmer: 'PROGRAMMER',
  UserRole.designer: 'DESIGNER',
  UserRole.manager: 'MANAGER',
  UserRole.marketer: 'MARKETER',
  UserRole.planner: 'PLANNER',
  UserRole.publisher: 'PUBLISHER',
  UserRole.analyst: 'ANALYST',
  UserRole.operator: 'OPERATOR',
  UserRole.pm: 'PM',
  UserRole.qa: 'QA',
  UserRole.cs: 'CS',
  UserRole.user: 'USER',
};

Application _$ApplicationFromJson(Map<String, dynamic> json) => Application(
      id: (json['id'] as num?)?.toInt(),
      platform:
          $enumDecodeNullable(_$ApplicationPlatformEnumMap, json['platform']),
      mobileOs: $enumDecodeNullable(_$MobileOsTypeEnumMap, json['mobileOs']),
      status: $enumDecodeNullable(_$ApplicationStatusEnumMap, json['status']),
      postId: json['postId'] as String?,
      appliedAt: json['appliedAt'] == null
          ? null
          : DateTime.parse(json['appliedAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ApplicationToJson(Application instance) =>
    <String, dynamic>{
      'id': instance.id,
      'platform': _$ApplicationPlatformEnumMap[instance.platform],
      'mobileOs': _$MobileOsTypeEnumMap[instance.mobileOs],
      'status': _$ApplicationStatusEnumMap[instance.status],
      'postId': instance.postId,
      'appliedAt': instance.appliedAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$ApplicationPlatformEnumMap = {
  ApplicationPlatform.web: 'web',
  ApplicationPlatform.mobile: 'mobile',
};

const _$MobileOsTypeEnumMap = {
  MobileOsType.ios: 'ios',
  MobileOsType.android: 'android',
};

const _$ApplicationStatusEnumMap = {
  ApplicationStatus.pending: 'pending',
  ApplicationStatus.accepted: 'accepted',
  ApplicationStatus.rejected: 'rejected',
  ApplicationStatus.cancel: 'cancel',
};

TResRecruitPostApplicationsInfo _$TResRecruitPostApplicationsInfoFromJson(
        Map<String, dynamic> json) =>
    TResRecruitPostApplicationsInfo(
      application: json['application'] == null
          ? null
          : Application.fromJson(json['application'] as Map<String, dynamic>),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TResRecruitPostApplicationsInfoToJson(
        TResRecruitPostApplicationsInfo instance) =>
    <String, dynamic>{
      'user': instance.user,
      'application': instance.application,
    };
