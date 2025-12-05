import '../../data/models/review/post_review_model.dart';

class PostReviewEntity {
  String? reviewId;
  double? rating;
  String? comment;
  PostReviewType? reviewType;
  String? reviewerId;
  String? reviewedId;
  DateTime? createdAt;
  String? postId;

  PostReviewEntity({
    this.reviewId,
    this.rating,
    this.comment,
    this.reviewType,
    this.reviewerId,
    this.reviewedId,
    this.createdAt,
    this.postId,
  });

  static PostReviewEntity toEntity(PostReviewModel model) {
    return PostReviewEntity(
      reviewId: model.reviewId,
      rating: model.rating,
      comment: model.comment,
      reviewType: model.reviewType,
      reviewerId: model.reviewerId,
      reviewedId: model.reviewedId,
      createdAt: model.createdAt,
      postId: model.postId,
    );
  }
  static PostReviewModel toModel(PostReviewEntity entity) {
    return PostReviewModel(
      reviewId: entity.reviewId,
      rating: entity.rating,
      comment: entity.comment,
      reviewType: entity.reviewType,
      reviewerId: entity.reviewerId,
      reviewedId: entity.reviewedId,
      createdAt: entity.createdAt,
      postId: entity.postId,
    );
  }
}