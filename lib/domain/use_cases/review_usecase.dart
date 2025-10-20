
import '../entities/review_entity.dart';
import '../repositories/review_repository.dart';

class ReviewUseCase {
  final ReviewRepository repository;
  ReviewUseCase(this.repository);

  Future<ReviewEntity> getUserReview(String token, String userId) async {
    final res = await repository.getUserReview(token, userId);
    return res;
  }

  Future<List<Map<String, dynamic>>> getUsersReview(String token, List<String> userIds) async {
    final res = await repository.getUsersReview(token, userIds);
    return res;
  }
}