
import '../entities/post_review_entity.dart';
import '../entities/user_review_entity.dart';
import '../repositories/review_repository.dart';

class ReviewUseCase {
  final ReviewRepository repository;
  ReviewUseCase(this.repository);
  
  Future<PostReviewEntity> addPromotionPostReview(String token, PostReviewEntity review) async {
    final res = await repository.addPromotionPostReview(token, review);
    return res;
  }
  
  Future<PostReviewEntity> addRecruitPostReview(String token, PostReviewEntity review) async {
    final res = await repository.addRecruitPostReview(token, review);
    return res;
  }

  Future<UserReviewEntity> addTesterReview(String token, UserReviewEntity review) async {
    final res = await repository.addTesterReview(token, review);
    return res;
  }

  Future<List<PostReviewEntity>> getPostReviews (String token, String userId) async {
    final res = await repository.getPostReviews(token, userId);
    return res;
  }

  Future<List<UserReviewEntity>> getReviews(String token, String userId) async {
    final res = await repository.getReviews(token, userId);
    return res;
  }

  Future<List<UserReviewEntity>> getTestersReviewOnPost(String token, List<String> ids, int appId) async {
    final res = await repository.getTestersReviews(token, ids, appId);
    return res;
  }
}