import 'package:json_annotation/json_annotation.dart';

part 'review_model.g.dart';

enum ReviewType {
  @JsonValue('PRODUCT_RATING')
  productRating,
  @JsonValue('ATTITUDE_RATING')
  attitudeRating,
}

@JsonSerializable()
class ReviewModel {
  String? reviewId;
  int? rating;
  String? content;
  ReviewType? reviewType;
  String? applicationId;
  String? reviewerUserId;
  String? reviewedUserId;
  DateTime? createdAt;

  ReviewModel({
    this.reviewId,
    this.rating,
    this.content,
    this.reviewType,
    this.applicationId,
    this.reviewerUserId,
    this.reviewedUserId,
    this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) => _$ReviewModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewModelToJson(this);
}