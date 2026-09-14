import 'package:json_annotation/json_annotation.dart';

part 'recruit_review_average_model.g.dart';

@JsonSerializable()
class RecruitReviewAverageModel {
  String? postId;
  double? average;

  RecruitReviewAverageModel({this.postId, this.average});

  factory RecruitReviewAverageModel.fromJson(Map<String, dynamic> json) => _$RecruitReviewAverageModelFromJson(json);

}
