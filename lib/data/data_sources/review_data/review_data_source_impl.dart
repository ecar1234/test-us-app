

import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:test_us_app/core/api_names.dart';
import 'package:test_us_app/data/data_sources/review_data/review_data_source.dart';
import 'package:test_us_app/data/models/review/review_model.dart';

import '../../../core/net_driver.dart';

class ReviewDataSourceImpl implements ReviewDataSource {
  final NetDriver netDriver;
  final logger = Logger();
  ReviewDataSourceImpl(this.netDriver);

  @override
  Future<ReviewModel> getUserReview(String token, String userId) async {
    try {
      final res = await netDriver.requestGetJson(token, ReviewApi.getReviewsById, param: userId);
      if(res['status'] == 200){
        return ReviewModel.fromJson(res['review']);
      }else {
        throw Exception('Error');
      }
    } on Exception catch (e) {
      logger.e(e);
      throw Exception(e);
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getUsersReview(String token, List<String> userIds) async {
    try {
      final res = await netDriver.requestPostJson(token, ReviewApi.gatUsersReviewAverage, {'userIds': userIds});
      if(res['status'] == 200){
        // final data = res['reviewData'].map((e) {
        //   return {
        //     'userId': e['userId'],
        //     'reviewData': e['reviewData']
        //   };
        // }).toList();
        return res['reviewData'];
      }else {
        throw Exception('Error');
      }
    } on Exception catch (e) {
      // TODO
      logger.e(e);
      throw Exception(e);
    }
  }

}