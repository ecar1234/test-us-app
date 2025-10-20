

import 'package:test_us_app/domain/entities/review_entity.dart';

import '../../domain/repositories/review_repository.dart';
import '../data_sources/review_data/review_data_source.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewDataSource remote;
  ReviewRepositoryImpl(this.remote);

  @override
  Future<ReviewEntity> getUserReview(String token, String userId) async {
    final res = await remote.getUserReview(token, userId);
    return ReviewEntity.toEntity(res);
  }

  @override
  Future<List<Map<String, dynamic>>> getUsersReview(String token, List<String> userIds) async {
    final res = await remote.getUsersReview(token, userIds);
    return res;
  }

}