// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostModel _$PostModelFromJson(Map<String, dynamic> json) => PostModel(
      postId: json['postId'] as String?,
      author: json['author'] as String?,
      title: json['title'] as String?,
      subtitle: json['subtitle'] as String?,
      contents: json['contents'] as String?,
      platform: (json['platform'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      status: $enumDecodeNullable(_$PostStatusEnumMap, json['status']),
      period: (json['period'] as num?)?.toInt(),
      applications: (json['applications'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$PostModelToJson(PostModel instance) => <String, dynamic>{
      'postId': instance.postId,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'platform': instance.platform,
      'contents': instance.contents,
      'status': _$PostStatusEnumMap[instance.status],
      'period': instance.period,
      'author': instance.author,
      'applications': instance.applications,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$PostStatusEnumMap = {
  PostStatus.active: 'active',
  PostStatus.end: 'end',
  PostStatus.expired: 'expired',
  PostStatus.delete: 'delete',
};
