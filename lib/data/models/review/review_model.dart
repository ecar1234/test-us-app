import 'package:json_annotation/json_annotation.dart';
import 'package:test_us_app/data/models/user/user_model.dart';

import '../application/application_model.dart';

part 'review_model.g.dart';

enum ReviewType {
  @JsonValue('PRODUCT_RATING')
  productRating,
  @JsonValue('PARTICIPANT_ATTITUDE_RATING')
  attitudeRating,
}

@JsonSerializable()
class ReviewModel {
  String? reviewId;
  int? rating;
  String? comment;
  ReviewType? reviewType;
  ApplicationModel? application;
  UserModel? reviewer;
  UserModel? reviewed;
  DateTime? createdAt;

  ReviewModel({
    this.reviewId,
    this.rating,
    this.comment,
    this.reviewType,
    this.application,
    this.reviewer,
    this.reviewed,
    this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) => _$ReviewModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewModelToJson(this);
}