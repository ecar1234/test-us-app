

import '../entities/post_review_entity.dart';
import '../entities/user_review_entity.dart';

abstract class ReviewRepository {
  Future<List<UserReviewEntity>> getReviews(String token, String userId);
  Future<List<PostReviewEntity>> getPostReviews(String token, String postId);
  Future<List<UserReviewEntity>> getTestersReviews(String token, List<String> ids, int appId);
  Future<PostReviewEntity> addRecruitPostReview(String token, PostReviewEntity review);
  Future<PostReviewEntity> addPromotionPostReview(String token, PostReviewEntity review);
  Future<UserReviewEntity> addTesterReview(String token, UserReviewEntity review);
}