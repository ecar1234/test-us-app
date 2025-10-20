
import 'package:test_us_app/data/models/review/review_model.dart';

abstract class ReviewDataSource {
  Future<ReviewModel> getUserReview(String token, String userId);
  Future<List<Map<String, dynamic>>> getUsersReview(String token, List<String> userIds);
}