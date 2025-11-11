// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      userId: json['userId'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      nickname: json['nickname'] as String?,
      profileImg: json['profileImg'] == null
          ? null
          : ImageModel.fromJson(json['profileImg'] as Map<String, dynamic>),
      userType: $enumDecodeNullable(_$UserTypeEnumMap, json['userType']),
      role: $enumDecodeNullable(_$UserRoleEnumMap, json['role']),
      userName: json['userName'] as String?,
      birth: json['birth'] == null
          ? null
          : DateTime.parse(json['birth'] as String),
      method: $enumDecodeNullable(_$AuthTypeEnumMap, json['method']),
      applications: (json['applications'] as List<dynamic>?)
          ?.map((e) => ApplicationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'userId': instance.userId,
      'email': instance.email,
      'password': instance.password,
      'nickname': instance.nickname,
      'profileImg': instance.profileImg,
      'userType': _$UserTypeEnumMap[instance.userType],
      'role': _$UserRoleEnumMap[instance.role],
      'userName': instance.userName,
      'birth': instance.birth?.toIso8601String(),
      'method': _$AuthTypeEnumMap[instance.method],
      'applications': instance.applications,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$UserTypeEnumMap = {
  UserType.individuals: 'INDIVIDUALS',
  UserType.companies: 'COMPANIES',
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
};

const _$AuthTypeEnumMap = {
  AuthType.email: 'EMAIL',
  AuthType.google: 'GOOGLE',
  AuthType.naver: 'NAVER',
};
