import 'package:json_annotation/json_annotation.dart';

part 'user_review_model.g.dart';


@JsonSerializable()
class UserReviewModel {
  String? reviewId;
  double? rating;
  String? comment;
  int? applicationId;
  String? reviewerUserId;
  String? reviewedUserId;
  DateTime? createdAt;

  UserReviewModel({
    this.reviewId,
    this.rating,
    this.comment,
    this.applicationId,
    this.reviewerUserId,
    this.reviewedUserId,
    this.createdAt,
  });

  factory UserReviewModel.fromJson(Map<String, dynamic> json) => _$UserReviewModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserReviewModelToJson(this);
}