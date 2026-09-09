

import 'package:test_us_app/domain/entities/user_review_entity.dart';

import '../../domain/entities/package/review_init_data_entity.dart';
import '../../domain/entities/post_review_entity.dart';
import '../../domain/repositories/review_repository.dart';
import '../data_sources/review_data/review_data_source.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewDataSource remote;
  ReviewRepositoryImpl(this.remote);

  @override
  Future<PostReviewEntity> addPromotionPostReview(String token, PostReviewEntity review) async {
    final res = await remote.addPromotionPostReview(token, PostReviewEntity.toModel(review));
    return PostReviewEntity.toEntity(res);
  }

  @override
  Future<PostReviewEntity> addRecruitPostReview(String token, PostReviewEntity review) async {
    final res = await remote.addRecruitPostReview(token, PostReviewEntity.toModel(review));
    return PostReviewEntity.toEntity(res);
  }

  @override
  Future<UserReviewEntity> addTesterReview(String token, UserReviewEntity review) async {
    final res = await remote.addTesterReview(token, UserReviewEntity.toModel(review));
    return UserReviewEntity.toEntity(res);
  }


  @override
  Future<List<UserReviewEntity>> getReviews(String token, String userId) async {
    final res = await remote.getReviews(token, userId);
    if(res.isEmpty) return [];
    return res.map((e) => UserReviewEntity.toEntity(e)).toList();
  }

  @override
  Future<List<UserReviewEntity>> getTestersReviews(String token, List<String> ids, int appId) async {
    final res = await remote.getTestersReviews(token, ids, appId);
    if(res.isEmpty) return [];
    return res.map((e) => UserReviewEntity.toEntity(e)).toList();
  }

  @override
  Future<List<PostReviewEntity>> getPostReviews(String token, String postId) async {
    final res = await remote.getPostReviews(token, postId);
    if(res.isEmpty) return [];
    return res.map((e) => PostReviewEntity.toEntity(e)).toList();
  }

  @override
  Future<PostReviewEntity> getReviewByPostReviewId(String token, String reviewId) async {
    final res = await remote.getReviewByPostReviewId(token, reviewId);
    return PostReviewEntity.toEntity(res);
  }

  @override
  Future<UserReviewEntity> getReviewByUserReviewId(String token, String reviewId) async {
    final res = await remote.getReviewByUserReviewId(token, reviewId);
    return UserReviewEntity.toEntity(res);
  }

  @override
  Future<ResReviewInitEntity> requestReviewInitData(String token, String userId, List<String> posts) async {
    final res = await remote.requestReviewInitData(token, userId, posts);
    return ResReviewInitEntity.toEntity(res);
  }
}