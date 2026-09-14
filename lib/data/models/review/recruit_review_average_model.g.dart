// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recruit_review_average_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecruitReviewAverageModel _$RecruitReviewAverageModelFromJson(
  Map<String, dynamic> json,
) => RecruitReviewAverageModel(
  postId: json['postId'] as String?,
  average: (json['average'] as num?)?.toDouble(),
);

Map<String, dynamic> _$RecruitReviewAverageModelToJson(
  RecruitReviewAverageModel instance,
) => <String, dynamic>{'postId': instance.postId, 'average': instance.average};
