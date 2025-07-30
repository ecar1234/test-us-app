// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewModel _$ReviewModelFromJson(Map<String, dynamic> json) => ReviewModel(
      reviewId: json['reviewId'] as String?,
      rating: (json['rating'] as num?)?.toInt(),
      content: json['content'] as String?,
      reviewType: $enumDecodeNullable(_$ReviewTypeEnumMap, json['reviewType']),
      applicationId: json['applicationId'] as String?,
      reviewerUserId: json['reviewerUserId'] as String?,
      reviewedUserId: json['reviewedUserId'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ReviewModelToJson(ReviewModel instance) =>
    <String, dynamic>{
      'reviewId': instance.reviewId,
      'rating': instance.rating,
      'content': instance.content,
      'reviewType': _$ReviewTypeEnumMap[instance.reviewType],
      'applicationId': instance.applicationId,
      'reviewerUserId': instance.reviewerUserId,
      'reviewedUserId': instance.reviewedUserId,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

const _$ReviewTypeEnumMap = {
  ReviewType.productRating: 'PRODUCT_RATING',
  ReviewType.attitudeRating: 'ATTITUDE_RATING',
};
