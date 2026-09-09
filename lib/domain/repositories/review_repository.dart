

import '../entities/package/review_init_data_entity.dart';
import '../entities/post_review_entity.dart';
import '../entities/user_review_entity.dart';

abstract class ReviewRepository {
  Future<List<UserReviewEntity>> getReviews(String token, String userId);
  Future<List<PostReviewEntity>> getPostReviews(String token, String postId);
  Future<List<UserReviewEntity>> getTestersReviews(String token, List<String> ids, int appId);
  Future<PostReviewEntity> getReviewByPostReviewId(String token, String reviewId);
  Future<UserReviewEntity> getReviewByUserReviewId(String token, String reviewId);
  Future<PostReviewEntity> addRecruitPostReview(String token, PostReviewEntity review);
  Future<PostReviewEntity> addPromotionPostReview(String token, PostReviewEntity review);
  Future<UserReviewEntity> addTesterReview(String token, UserReviewEntity review);
  Future<ResReviewInitEntity> requestReviewInitData(String token, String userId, List<String> posts);
}