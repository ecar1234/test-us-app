// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewModel _$ReviewModelFromJson(Map<String, dynamic> json) => ReviewModel(
      reviewId: json['reviewId'] as String?,
      rating: (json['rating'] as num?)?.toInt(),
      comment: json['comment'] as String?,
      reviewType: $enumDecodeNullable(_$ReviewTypeEnumMap, json['reviewType']),
      application: json['application'] == null
          ? null
          : ApplicationModel.fromJson(
              json['application'] as Map<String, dynamic>),
      reviewer: json['reviewer'] == null
          ? null
          : UserModel.fromJson(json['reviewer'] as Map<String, dynamic>),
      reviewed: json['reviewed'] == null
          ? null
          : UserModel.fromJson(json['reviewed'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ReviewModelToJson(ReviewModel instance) =>
    <String, dynamic>{
      'reviewId': instance.reviewId,
      'rating': instance.rating,
      'comment': instance.comment,
      'reviewType': _$ReviewTypeEnumMap[instance.reviewType],
      'application': instance.application,
      'reviewer': instance.reviewer,
      'reviewed': instance.reviewed,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

const _$ReviewTypeEnumMap = {
  ReviewType.productRating: 'PRODUCT_RATING',
  ReviewType.attitudeRating: 'PARTICIPANT_ATTITUDE_RATING',
};
