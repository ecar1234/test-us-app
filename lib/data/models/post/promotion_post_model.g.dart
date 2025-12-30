// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promotion_post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PromotionPostModel _$PromotionPostModelFromJson(Map<String, dynamic> json) =>
    PromotionPostModel(
      id: json['id'] as String?,
      title: json['title'] as String?,
      subtitle: json['subtitle'] as String?,
      platform: (json['platform'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      contents: json['contents'] as String?,
      status: $enumDecodeNullable(_$PostStatusEnumMap, json['status']),
      period: (json['period'] as num?)?.toInt(),
      author: json['author'] == null
          ? null
          : UserModel.fromJson(json['author'] as Map<String, dynamic>),
      views: (json['views'] as num?)?.toInt(),
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => ImageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      domain:
          (json['domain'] as List<dynamic>?)?.map((e) => e as String).toList(),
      postType: json['postType'] as String?,
      reviews:
          (json['reviews'] as List<dynamic>?)?.map((e) => e as String).toList(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$PromotionPostModelToJson(PromotionPostModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'platform': instance.platform,
      'contents': instance.contents,
      'status': _$PostStatusEnumMap[instance.status],
      'period': instance.period,
      'author': instance.author,
      'views': instance.views,
      'images': instance.images,
      'domain': instance.domain,
      'postType': instance.postType,
      'reviews': instance.reviews,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$PostStatusEnumMap = {
  PostStatus.active: 'active',
  PostStatus.end: 'end',
  PostStatus.expired: 'expired',
  PostStatus.delete: 'delete',
};
