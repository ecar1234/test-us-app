// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'res_review_init_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResReviewInitModel _$ResReviewInitModelFromJson(Map<String, dynamic> json) =>
    ResReviewInitModel(
      userReviews: (json['userReviews'] as List<dynamic>?)
          ?.map((e) => UserReviewModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      postReviewAverages: (json['postReviewAverages'] as List<dynamic>?)
          ?.map(
            (e) =>
                RecruitReviewAverageModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      applyPostReviews: (json['applyPostReviews'] as List<dynamic>?)
          ?.map((e) => PostReviewModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ResReviewInitModelToJson(ResReviewInitModel instance) =>
    <String, dynamic>{
      'userReviews': instance.userReviews,
      'postReviewAverages': instance.postReviewAverages,
      'applyPostReviews': instance.applyPostReviews,
    };
