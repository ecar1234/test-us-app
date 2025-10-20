

import '../entities/review_entity.dart';

abstract class ReviewRepository {
  Future<ReviewEntity> getUserReview(String token, String userId);
  Future<List<Map<String, dynamic>>> getUsersReview(String token, List<String> userIds);
}