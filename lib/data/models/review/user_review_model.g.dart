// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserReviewModel _$UserReviewModelFromJson(Map<String, dynamic> json) =>
    UserReviewModel(
      reviewId: json['reviewId'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      comment: json['comment'] as String?,
      applicationId: (json['applicationId'] as num?)?.toInt(),
      reviewerUserId: json['reviewerUserId'] as String?,
      reviewedUserId: json['reviewedUserId'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$UserReviewModelToJson(UserReviewModel instance) =>
    <String, dynamic>{
      'reviewId': instance.reviewId,
      'rating': instance.rating,
      'comment': instance.comment,
      'applicationId': instance.applicationId,
      'reviewerUserId': instance.reviewerUserId,
      'reviewedUserId': instance.reviewedUserId,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
