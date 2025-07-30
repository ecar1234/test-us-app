// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApplicationModel _$ApplicationModelFromJson(Map<String, dynamic> json) =>
    ApplicationModel(
      appId: json['appId'] as String?,
      platform:
          $enumDecodeNullable(_$ApplicationPlatformEnumMap, json['platform']),
      status: $enumDecodeNullable(_$ApplicationStatusEnumMap, json['status']),
      appliedAt: json['appliedAt'] == null
          ? null
          : DateTime.parse(json['appliedAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      postId: json['postId'] as String?,
      appUserId: json['appUserId'] as String?,
    );

Map<String, dynamic> _$ApplicationModelToJson(ApplicationModel instance) =>
    <String, dynamic>{
      'appId': instance.appId,
      'platform': _$ApplicationPlatformEnumMap[instance.platform],
      'status': _$ApplicationStatusEnumMap[instance.status],
      'appliedAt': instance.appliedAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'postId': instance.postId,
      'appUserId': instance.appUserId,
    };

const _$ApplicationPlatformEnumMap = {
  ApplicationPlatform.pending: 'PENDING',
  ApplicationPlatform.accepted: 'ACCEPTED',
  ApplicationPlatform.rejected: 'REJECTED',
};

const _$ApplicationStatusEnumMap = {
  ApplicationStatus.active: 'ACTIVE',
  ApplicationStatus.end: 'END',
  ApplicationStatus.expired: 'EXPIRED',
};
