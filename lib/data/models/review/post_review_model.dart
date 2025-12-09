


import 'package:json_annotation/json_annotation.dart';

part 'post_review_model.g.dart';


enum PostReviewType {
  @JsonValue('PROMOTION')
  promotion,
  @JsonValue('RECRUIT')
  recruit,
}

@JsonSerializable()
class PostReviewModel {
  String? reviewId;
  double? rating;
  String? comment;
  PostReviewType? reviewType;
  String? reviewerUserId;
  // String? reviewedId;
  DateTime? createdAt;
  String? postId;

  PostReviewModel({
    this.reviewId,
    this.rating,
    this.comment,
    this.reviewType,
    this.reviewerUserId,
    // this.reviewedId,
    this.createdAt,
    this.postId,
  });

  factory PostReviewModel.fromJson(Map<String, dynamic> json) => _$PostReviewModelFromJson(json);
  Map<String, dynamic> toJson() => _$PostReviewModelToJson(this);

}