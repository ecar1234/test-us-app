
import 'dart:async';

import 'package:logger/logger.dart';
import 'package:test_us_app/data/data_sources/post_data/base_post_datasource.dart';

import '../../../core/api_names.dart';
import '../../../core/net_driver.dart';
import '../../models/post/promotion_post_model.dart';
import '../../models/post/recruit_post_model.dart';

class BasePostDataSourceImpl implements BasePostDataSource {
  final NetDriver netDriver;
  final logger = Logger();
  BasePostDataSourceImpl(this.netDriver);

  @override
  Future<Map<String, List<dynamic>>> getPostsInitData() async {
    final res = await netDriver.requestGetJson("", PostApi.getInitPosts);

    if (res['status'] == 202) {
      final jobId = res['jobId'];
      final data = await _startGetInitPosts(jobId, "");
      return {'favorite': data['favoritePosts']!, 'recruit': data['recruitPosts']!, 'promotion': data['promotionPosts']!};
    } else {
      throw Exception('Error');
    }
  }

  @override
  Future<Map<String,dynamic>> getUserInitData(String token, String id) async {
    final res = await netDriver.requestGetJson(token, PostApi.getUserInitData, param: id);
    if (res['status'] == 202) {
      final jobId = res['jobId'];
      final data = await _startGetUserPosts(jobId, token);
      return {'recruit': data['recruitPosts']!, 'promotion': data['promotionPosts']!};
    } else {
      throw Exception('Error');
    }
  }

  @override
  Future<Map<String, dynamic>> searchPost(String keyword) async {
    final res = await netDriver.requestGetJson("", PostApi.searchPost, param: keyword);
    if (res['status'] == 200) {
      final recruitPosts = res['recruit'].map<RecruitPostModel>((e) => RecruitPostModel.fromJson(e)).toList();
      final promotionPosts = res['promotion'].map<PromotionPostModel>((e) => PromotionPostModel.fromJson(e)).toList();
      return {'recruitPosts': recruitPosts, 'promotionPosts': promotionPosts};
    } else {
      throw Exception('Error');
    }
  }

  Future<Map<String, List<dynamic>>> _startGetInitPosts(String jobId, String token) {
    final controller = Completer<Map<String, List<dynamic>>>();
    Timer.periodic(Duration(seconds: 2), (timer) async {
      final res = await netDriver.requestGetJson(token, JobApi.jobGetInitPosts, param: jobId);
      if (res['status'] == 200) {
        final favorite = (res['favoritePosts'] as List).map((e) {
          if(e['domain'] == null){
            return RecruitPostModel.fromJson(e);
          }else {
            return PromotionPostModel.fromJson(e);
          }
        }).toList();
        final recruit = (res['recruitPosts'] as List).map<RecruitPostModel>((e) => RecruitPostModel.fromJson(e)).toList();
        final promotion = (res['promotionPosts'] as List).map<PromotionPostModel>((e) => PromotionPostModel.fromJson(e)).toList();

        final result = {'favoritePosts': favorite, 'recruitPosts': recruit, 'promotionPosts': promotion};
        controller.complete(result);
        timer.cancel();
      }
    });
    return controller.future;
  }

  Future<Map<String, dynamic>> _startGetUserPosts(String jobId, String token) {
    final controller = Completer<Map<String, List<dynamic>>>();
    Timer.periodic(Duration(seconds: 2), (timer) async {
      try {
        final res = await netDriver.requestGetJson(token, JobApi.jobGetUserPosts, param: jobId);
        if (res['status'] == 200) {
          final recruitPosts = res['recruitPosts'].map<RecruitPostModel>((e) => RecruitPostModel.fromJson(e)).toList();
          final promotionPosts = res['promotionPosts'].map<PromotionPostModel>((e) => PromotionPostModel.fromJson(e)).toList();
            controller.complete({
              'recruitPosts' : recruitPosts,
              'promotionPosts' : promotionPosts
            });
            timer.cancel();
        }
      } on Exception catch (e) {
        // TODO
        logger.e(e.toString());
      }
    });
    return controller.future;
  }
}
