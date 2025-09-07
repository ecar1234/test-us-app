// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApplicationModel _$ApplicationModelFromJson(Map<String, dynamic> json) =>
    ApplicationModel(
      id: (json['id'] as num?)?.toInt(),
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
      applicantId: json['applicantId'] as String?,
    );

Map<String, dynamic> _$ApplicationModelToJson(ApplicationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'platform': _$ApplicationPlatformEnumMap[instance.platform],
      'status': _$ApplicationStatusEnumMap[instance.status],
      'appliedAt': instance.appliedAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'postId': instance.postId,
      'applicantId': instance.applicantId,
    };

const _$ApplicationPlatformEnumMap = {
  ApplicationPlatform.web: 'web',
  ApplicationPlatform.ios: 'ios',
  ApplicationPlatform.android: 'android',
};

const _$ApplicationStatusEnumMap = {
  ApplicationStatus.pending: 'pending',
  ApplicationStatus.accepted: 'accepted',
  ApplicationStatus.rejected: 'rejected',
  ApplicationStatus.cancel: 'cancel',
};
