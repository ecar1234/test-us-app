

import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:test_us_app/core/api_names.dart';
import 'package:test_us_app/data/data_sources/review_data/review_data_source.dart';
import 'package:test_us_app/data/models/review/packages/res_review_init_model.dart';
import 'package:test_us_app/data/models/review/user_review_model.dart';
import 'package:test_us_app/domain/entities/user_review_entity.dart';

import '../../../core/net_driver.dart';
import '../../models/review/post_review_model.dart';

class ReviewDataSourceImpl implements ReviewDataSource {
  final NetDriver netDriver;
  final logger = Logger();
  ReviewDataSourceImpl(this.netDriver);

  @override
  Future<PostReviewModel> addPromotionPostReview(String token, PostReviewModel review) async {
    final res = await netDriver.requestPostJson(token, ReviewApi.addPromotionReview, review.toJson());
    if(res['status'] == 200 ){
      return PostReviewModel.fromJson(res['review']);
    }else{
      throw Exception(res['message']);
    }
  }

  @override
  Future<PostReviewModel> addRecruitPostReview(String token, PostReviewModel review) async {
    try {
      final json = review.toJson();
      final res = await netDriver.requestPostJson(token, ReviewApi.addRecruitReview, json);
      if(res['status'] == 200 ){
        return PostReviewModel.fromJson(res['review']);
      }else{
        throw Exception(res['message']);
      }
    } on Exception catch (e) {
      // TODO
      logger.e(e.toString());
      return PostReviewModel();
    }
  }

  @override
  Future<UserReviewModel> addTesterReview(String token, UserReviewModel review) async {
    try {
      final res = await netDriver.requestPostJson(token, ReviewApi.addUserReview, review.toJson());
      if(res['status'] == 200 ) {
        return UserReviewModel.fromJson(res['review']);
      }else {
        throw Exception(res['message']);
      }
    } on Exception catch (e) {
      logger.e(e.toString());
      return UserReviewModel();
    }
  }

  @override
  Future<List<PostReviewModel>> getPostReviews(String token, String postId) async {
    final res = await netDriver.requestGetJson(token, ReviewApi.getReviewByPostId, param: postId);
    if(res['status'] == 200){
      if(res['reviews'] == null || (res['reviews'] as List).isEmpty) return [];
      return (res['reviews'] as List).map((e) => PostReviewModel.fromJson(e)).toList();
    }else {
      throw Exception(res['message']);
    }
  }


  @override
  Future<List<UserReviewModel>> getReviews(String token, String userId) async {
    final res = await netDriver.requestGetJson(token, ReviewApi.getUserReview, param: userId);
    if(res['status'] == 200) {
      if(res['reviews'] == null || (res['reviews'] as List).isEmpty) return [];
      return (res['reviews'] as List).map((e) => UserReviewModel.fromJson(e)).toList();
    }else {
      throw Exception(res['message']);
    }
  }

  @override
  Future<List<UserReviewModel>> getTestersReviews(String token, List<String> ids, int appId) async {
    final res = await netDriver.requestPostJson(token, ReviewApi.getReviewByTesters, {'ids': ids, 'appId': appId});
    if(res['status'] == 200) {
      if(res['reviews'] == null || (res['reviews'] as List).isEmpty) return [];
      return (res['reviews'] as List).map((e) => UserReviewModel.fromJson(e)).toList();
    } else {
      throw Exception(res['message']);
    }
  }

  @override
  Future<PostReviewModel> getReviewByPostReviewId(String token, String reviewId) async {
    final res = await netDriver.requestGetJson(token, ReviewApi.getReviewByPostReviewId, param: reviewId);
    if(res['status'] == 200) {
      return PostReviewModel.fromJson(res['review']);
    } else {
      throw Exception(res['message']);
    }
  }

  @override
  Future<UserReviewModel> getReviewByUserReviewId(String token, String reviewId) async {
    final res = await netDriver.requestGetJson(token, ReviewApi.getReviewByUserReviewId, param: reviewId);
    if(res['status'] == 200) {
      return UserReviewModel.fromJson(res['review']);
    } else {
      throw Exception(res['message']);
    }
  }

  @override
  Future<ResReviewInitModel> requestReviewInitData(String token, String userId, List<String> posts) async {
    final res = await netDriver.requestPostJson(token, ReviewApi.requestReviewInitData, {'userId': userId, 'postIds' : posts});
    if(res['status'] == 200){
      final initData = {'userReviews': res['userReviews'], 'applyPostReviews': res['applyPostReviews']};
      return ResReviewInitModel.fromJson(initData);
    }else {
      return ResReviewInitModel();
    }
  }
}