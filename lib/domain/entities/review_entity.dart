

import 'package:test_us_app/domain/entities/application_entity.dart';
import 'package:test_us_app/domain/entities/user_entity.dart';

import '../../data/models/review/review_model.dart';

class ReviewEntity {
  String? reviewId;
  int? rating;
  String? comment;
  ReviewType? reviewType;
  ApplicationEntity? application;
  UserEntity? reviewer;
  UserEntity? reviewed;
  DateTime? createdAt;

  ReviewEntity({
    this.reviewId,
    this.rating,
    this.comment,
    this.reviewType,
    this.application,
    this.reviewer,
    this.reviewed,
    this.createdAt,
  });

  static ReviewEntity toEntity(ReviewModel model){
    final application = ApplicationEntity.toEntity(model.application!);
    final reviewer = UserEntity.toEntity(model.reviewer!);
    final reviewed = UserEntity.toEntity(model.reviewed!);
    return ReviewEntity(
      reviewId: model.reviewId,
      rating: model.rating,
      comment: model.comment,
      reviewType: model.reviewType,
      application: application,
      reviewer: reviewer,
      reviewed: reviewed,
      createdAt: model.createdAt,
    );
  }
  static ReviewModel toModel(ReviewEntity entity){
    final application = ApplicationEntity.toModel(entity.application!);
    final reviewer = UserEntity.toModel(entity.reviewer!);
    final reviewed = UserEntity.toModel(entity.reviewed!);
    return ReviewModel(
      reviewId: entity.reviewId,
      rating: entity.rating,
      comment: entity.comment,
      reviewType: entity.reviewType,
      application: application,
      reviewer: reviewer,
      reviewed: reviewed,
      createdAt: entity.createdAt,
    );
  }
}