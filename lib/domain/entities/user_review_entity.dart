

import 'package:test_us_app/domain/entities/application_entity.dart';
import 'package:test_us_app/domain/entities/user_entity.dart';

import '../../data/models/review/user_review_model.dart';

class UserReviewEntity {
  String? reviewId;
  double? rating;
  String? comment;
  int? applicationId;
  String? reviewerId;
  String? reviewedId;
  DateTime? createdAt;

  UserReviewEntity({
    this.reviewId,
    this.rating,
    this.comment,
    this.applicationId,
    this.reviewerId,
    this.reviewedId,
    this.createdAt,
  });

  static UserReviewEntity toEntity(UserReviewModel model){

    return UserReviewEntity(
      reviewId: model.reviewId,
      rating: model.rating,
      comment: model.comment,
      applicationId: model.applicationId,
      reviewerId: model.reviewerUserId,
      reviewedId: model.reviewedUserId,
      createdAt: model.createdAt,
    );
  }
  static UserReviewModel toModel(UserReviewEntity entity){
    return UserReviewModel(
      reviewId: entity.reviewId,
      rating: entity.rating,
      comment: entity.comment,
      applicationId: entity.applicationId,
      reviewerUserId: entity.reviewerId,
      reviewedUserId: entity.reviewedId,
      createdAt: entity.createdAt,
    );
  }
}