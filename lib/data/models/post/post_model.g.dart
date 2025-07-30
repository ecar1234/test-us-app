// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostModel _$PostModelFromJson(Map<String, dynamic> json) => PostModel(
      id: json['id'] as String?,
      title: json['title'] as String?,
      subTitle: json['subTitle'] as String?,
      author: json['author'] as String?,
      applications: (json['applications'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      platform: json['platform'] as String?,
      content: json['content'] as String?,
      status: $enumDecodeNullable(_$PostStatusEnumMap, json['status']),
      period: (json['period'] as num?)?.toInt(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$PostModelToJson(PostModel instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'subTitle': instance.subTitle,
      'platform': instance.platform,
      'content': instance.content,
      'status': _$PostStatusEnumMap[instance.status],
      'period': instance.period,
      'author': instance.author,
      'applications': instance.applications,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$PostStatusEnumMap = {
  PostStatus.active: 'ACTIVE',
  PostStatus.end: 'END',
  PostStatus.expired: 'EXPIRED',
};
