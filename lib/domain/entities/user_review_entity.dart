

import 'package:test_us_app/domain/entities/application_entity.dart';
import 'package:test_us_app/domain/entities/user_entity.dart';

import '../../data/models/review/user_review_model.dart';

class UserReviewEntity {
  String? reviewId;
  double? rating;
  String? comment;
  int? application;
  String? reviewerId;
  String? reviewedId;
  DateTime? createdAt;

  UserReviewEntity({
    this.reviewId,
    this.rating,
    this.comment,
    this.application,
    this.reviewerId,
    this.reviewedId,
    this.createdAt,
  });

  static ReviewEntity toEntity(UserReviewModel model){

    return UserReviewEntity(
      reviewId: model.reviewId,
      rating: model.rating,
      comment: model.comment,
      application: application,
      reviewerId: model.reviewerId,
      reviewedId: model.reviewedId,
      createdAt: model.createdAt,
    );
  }
  static ReviewModel toModel(ReviewEntity entity){
    final application = entity.application == null ? null : ApplicationEntity.toModel(entity.application!);
    return ReviewModel(
      reviewId: entity.reviewId,
      rating: entity.rating,
      comment: entity.comment,
      reviewType: entity.reviewType,
      application: application,
      reviewerId: entity.reviewerId,
      reviewedId: entity.reviewedId,
      createdAt: entity.createdAt,
    );
  }
}