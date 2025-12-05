import 'package:json_annotation/json_annotation.dart';
import 'package:test_us_app/data/models/user/user_model.dart';

import '../application/application_model.dart';

part 'review_model.g.dart';

// enum ReviewType {
//   @JsonValue('PRODUCT_RATING')
//   productRating,
//   @JsonValue('PARTICIPANT_ATTITUDE_RATING')
//   attitudeRating,
// }

@JsonSerializable()
class UserReviewModel {
  String? reviewId;
  double? rating;
  String? comment;
  // ReviewType? reviewType;
  ApplicationModel? application;
  String? reviewerId;
  String? reviewedId;
  DateTime? createdAt;

  UserReviewModel({
    this.reviewId,
    this.rating,
    this.comment,
    // this.reviewType,
    this.application,
    this.reviewerId,
    this.reviewedId,
    this.createdAt,
  });

  factory UserReviewModel.fromJson(Map<String, dynamic> json) => _$UserReviewModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewModelToJson(this);
}