// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostReviewModel _$PostReviewModelFromJson(Map<String, dynamic> json) =>
    PostReviewModel(
      reviewId: json['reviewId'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      comment: json['comment'] as String?,
      reviewType:
          $enumDecodeNullable(_$PostReviewTypeEnumMap, json['reviewType']),
      reviewerId: json['reviewerId'] as String?,
      reviewedId: json['reviewedId'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      postId: json['postId'] as String?,
    );

Map<String, dynamic> _$PostReviewModelToJson(PostReviewModel instance) =>
    <String, dynamic>{
      'reviewId': instance.reviewId,
      'rating': instance.rating,
      'comment': instance.comment,
      'reviewType': _$PostReviewTypeEnumMap[instance.reviewType],
      'reviewerId': instance.reviewerId,
      'reviewedId': instance.reviewedId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'postId': instance.postId,
    };

const _$PostReviewTypeEnumMap = {
  PostReviewType.promotion: 'PROMOTION_RATING',
  PostReviewType.recruit: 'RECRUIT_RATING',
};
