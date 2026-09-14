import 'package:json_annotation/json_annotation.dart';
import 'package:test_us_app/data/models/review/post_review_model.dart';
import 'package:test_us_app/data/models/review/recruit_review_average_model.dart';
import 'package:test_us_app/data/models/review/user_review_model.dart';

part 'res_review_init_model.g.dart';

@JsonSerializable()
class ResReviewInitModel {
  final List<UserReviewModel>? userReviews;
  final List<RecruitReviewAverageModel>? postReviewAverages;
  final List<PostReviewModel>? applyPostReviews;

  ResReviewInitModel({
    this.userReviews,
    this.postReviewAverages,
    this.applyPostReviews,
  });

  factory ResReviewInitModel.fromJson(Map<String, dynamic> json) => _$ResReviewInitModelFromJson(json);

}
