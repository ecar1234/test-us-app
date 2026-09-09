// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApplicationModel _$ApplicationModelFromJson(Map<String, dynamic> json) =>
    ApplicationModel(
      id: (json['id'] as num?)?.toInt(),
      platform: $enumDecodeNullable(
        _$ApplicationPlatformEnumMap,
        json['platform'],
      ),
      mobileOs: $enumDecodeNullable(_$MobileOsTypeEnumMap, json['mobileOs']),
      status: $enumDecodeNullable(_$ApplicationStatusEnumMap, json['status']),
      appliedAt: json['appliedAt'] == null
          ? null
          : DateTime.parse(json['appliedAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      postInfo: json['postInfo'] == null
          ? null
          : PostInfoModel.fromJson(json['postInfo'] as Map<String, dynamic>),
      applicantId: json['applicantId'] as String?,
    );

Map<String, dynamic> _$ApplicationModelToJson(ApplicationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'platform': _$ApplicationPlatformEnumMap[instance.platform],
      'mobileOs': _$MobileOsTypeEnumMap[instance.mobileOs],
      'status': _$ApplicationStatusEnumMap[instance.status],
      'appliedAt': instance.appliedAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'postInfo': instance.postInfo,
      'applicantId': instance.applicantId,
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

PostInfoModel _$PostInfoModelFromJson(Map<String, dynamic> json) =>
    PostInfoModel(
      postId: json['postId'] as String?,
      title: json['title'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      isExpired: json['isExpired'] as bool?,
      category: $enumDecodeNullable(_$PostCategoryEnumMap, json['category']),
    );

Map<String, dynamic> _$PostInfoModelToJson(PostInfoModel instance) =>
    <String, dynamic>{
      'postId': instance.postId,
      'title': instance.title,
      'thumbnailUrl': instance.thumbnailUrl,
      'isExpired': instance.isExpired,
      'category': _$PostCategoryEnumMap[instance.category],
    };

const _$PostCategoryEnumMap = {
  PostCategory.game: 'game',
  PostCategory.travel: 'travel',
  PostCategory.developerTool: 'developer_tool',
  PostCategory.health: 'health',
  PostCategory.education: 'education',
  PostCategory.finance: 'finance',
  PostCategory.weather: 'weather',
  PostCategory.news: 'news',
  PostCategory.books: 'books',
  PostCategory.life: 'life',
  PostCategory.business: 'business',
  PostCategory.photography: 'photography',
  PostCategory.social: 'social',
  PostCategory.shopping: 'shopping',
  PostCategory.entertainment: 'entertainment',
  PostCategory.sports: 'sports',
  PostCategory.utility: 'utility',
  PostCategory.food: 'food',
  PostCategory.music: 'music',
  PostCategory.medical: 'medical',
  PostCategory.magazine: 'magazine',
  PostCategory.etc: 'etc',
};
