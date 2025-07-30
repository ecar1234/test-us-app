

import '../../data/models/review/review_model.dart';

class ReviewEntity {
  String? reviewId;
  int? rating;
  String? content;
  ReviewType? reviewType;
  String? applicationId;
  String? reviewerUserId;
  String? reviewedUserId;
  DateTime? createdAt;

  ReviewEntity({
    this.reviewId,
    this.rating,
    this.content,
    this.reviewType,
    this.applicationId,
    this.reviewerUserId,
    this.reviewedUserId,
    this.createdAt,
  });
}