
import 'package:test_us_app/data/models/review/user_review_model.dart';
import 'package:test_us_app/domain/entities/user_review_entity.dart';

import '../../models/review/post_review_model.dart';

abstract class ReviewDataSource {
  Future<List<UserReviewModel>> getReviews(String token, String userId);
  Future<List<PostReviewModel>> getPostReviews(String token, String postId);
  Future<List<UserReviewModel>> getTestersReviews(String token, List<String> ids, int appId);
  Future<PostReviewModel> getReviewByPostReviewId(String token, String reviewId);
  Future<UserReviewModel> getReviewByUserReviewId(String token, String reviewId);
  Future<PostReviewModel> addRecruitPostReview(String token, PostReviewModel review);
  Future<PostReviewModel> addPromotionPostReview(String token, PostReviewModel review);
  Future<UserReviewModel> addTesterReview(String token, UserReviewModel review);
}