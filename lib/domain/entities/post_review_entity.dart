import '../../data/models/review/post_review_model.dart';

class PostReviewEntity {
  String? reviewId;
  double? rating;
  String? comment;
  PostReviewType? reviewType;
  String? reviewerUserId;
  // String? reviewedId;
  DateTime? createdAt;
  String? postId;

  PostReviewEntity({
    this.reviewId,
    this.rating,
    this.comment,
    this.reviewType,
    this.reviewerUserId,
    // this.reviewedId,
    this.createdAt,
    this.postId,
  });

  static PostReviewEntity toEntity(PostReviewModel model) {
    return PostReviewEntity(
      reviewId: model.reviewId,
      rating: model.rating,
      comment: model.comment,
      reviewType: model.reviewType,
      reviewerUserId: model.reviewerUserId,
      // reviewedId: model.reviewedId,
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
      reviewerUserId: entity.reviewerUserId,
      // reviewedId: entity.reviewedId,
      createdAt: entity.createdAt,
      postId: entity.postId,
    );
  }
}