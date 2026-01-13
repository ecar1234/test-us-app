// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recruit_post_tester_reviews_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecruitPostTesterReviewsModel _$RecruitPostTesterReviewsModelFromJson(
        Map<String, dynamic> json) =>
    RecruitPostTesterReviewsModel(
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      review: json['review'] == null
          ? null
          : UserReviewModel.fromJson(json['review'] as Map<String, dynamic>),
      appId: (json['appId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RecruitPostTesterReviewsModelToJson(
        RecruitPostTesterReviewsModel instance) =>
    <String, dynamic>{
      'user': instance.user,
      'review': instance.review,
      'appId': instance.appId,
    };
