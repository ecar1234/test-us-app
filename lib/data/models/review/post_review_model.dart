


import 'package:json_annotation/json_annotation.dart';

part 'post_review_model.g.dart';


enum PostReviewType {
  @JsonValue('PROMOTION_RATING')
  promotion,
  @JsonValue('RECRUIT_RATING')
  recruit,
}

@JsonSerializable()
class PostReviewModel {
  String? reviewId;
  double? rating;
  String? comment;
  PostReviewType? reviewType;
  String? reviewerId;
  String? reviewedId;
  DateTime? createdAt;
  String? postId;

  PostReviewModel({
    this.reviewId,
    this.rating,
    this.comment,
    this.reviewType,
    this.reviewerId,
    this.reviewedId,
    this.createdAt,
    this.postId,
  });

  factory PostReviewModel.fromJson(Map<String, dynamic> json) => _$PostReviewModelFromJson(json);
  Map<String, dynamic> toJson() => _$PostReviewModelToJson(this);

}