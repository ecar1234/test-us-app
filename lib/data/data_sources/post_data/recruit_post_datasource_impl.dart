import 'dart:async';
import 'dart:convert';

import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:test_us_app/core/api_names.dart';
import 'package:test_us_app/data/data_sources/post_data/recruit_post_datasource.dart';
import 'package:test_us_app/data/models/post/promotion_post_model.dart';
import 'package:test_us_app/data/models/post/recruit_post_model.dart';

import '../../../core/net_driver.dart';
import '../../models/image/image_model.dart';

class RecruitPostDatasourceImpl implements RecruitPostDatasource {
  final logger = Logger();
  final NetDriver netDriver;

  RecruitPostDatasourceImpl(this.netDriver);

  @override
  Future<Map<String, List<dynamic>>> getPostsInitData() async {
    final res = await netDriver.requestGetJson("", PostApi.getInitPosts);

    if (res['status'] == 202) {
      final jobId = res['jobId'];
      final data = await _startPolling(jobId, "");
      return {'favorite': data['favoritePosts']!, 'recruit': data['recruitPosts']!, 'promotion': data['promotionPosts']!};
    } else {
      throw Exception('Error');
    }
  }

  @override
  Future<List<RecruitPostModel>> getPostsPagination(int page) async {
    final res = await netDriver.requestGetJson(page.toString(), RecruitPostApi.getPostsPagination);
    if (res['status'] == 200) {
      // logger.d(res['posts']);
      return (res['posts'] as List).map<RecruitPostModel>((e) => RecruitPostModel.fromJson(e)).toList();
    } else {
      throw Exception('Error');
    }
  }

  @override
  Future<RecruitPostModel> createPost(String token, RecruitPostModel post) async {
    final res = await netDriver.requestPostJson(token, RecruitPostApi.create, post.toJson());
    if (res['status'] == 200) {
      return RecruitPostModel.fromJson(res['post']);
    } else {
      throw Exception('Error');
    }
  }

  @override
  Future<RecruitPostModel> updatePost(String token, RecruitPostModel post) async {
    final res = await netDriver.requestPutJson(token, RecruitPostApi.update, post.toJson());
    if (res['status'] == 200) {
      return RecruitPostModel.fromJson(res['post']);
    } else {
      throw Exception('Error');
    }
  }

  @override
  Future<bool> deletePost(String token, String id) async {
    final data = {"id": id};
    final res = await netDriver.requestPostJson(token, RecruitPostApi.delete, data);
    if (res['status'] == 200) {
      return true;
    } else {
      throw false;
    }
  }

  @override
  Future<RecruitPostModel> getPostById(String token, String id) async {
    final res = await netDriver.requestGetJson(token, RecruitPostApi.getPostById, param: id);
    if (res['status'] == 200) {
      return RecruitPostModel.fromJson(res['post']);
    } else {
      throw Exception('Error');
    }
  }

  @override
  Future<List<RecruitPostModel>> getUserRecruitmentPosts(String token, String userId) async {
    final res = await netDriver.requestGetJson(token, RecruitPostApi.getUserRecruitmentPosts, param: userId);
    if (res['status'] == 200) {
      if(res['posts'] == null || res['posts'] == []){
        return [];
      }
      return (res['posts'] as List).map<RecruitPostModel>((e) => RecruitPostModel.fromJson(e)).toList();
    } else {
      throw Exception('Error');
    }
  }

  @override
  Future<List<RecruitPostModel>> getPostByTitle(String title) {
    // TODO: implement getPostByTitle
    throw UnimplementedError();
  }

  Future<Map<String, List<dynamic>>> _startPolling(String jobId, String token) {
    final controller = Completer<Map<String, List<dynamic>>>();
    Timer.periodic(Duration(seconds: 2), (timer) async {
      final res = await netDriver.requestGetJson(token, JobApi.jobGetInitPosts, param: jobId);
      if (res['status'] == 200) {
        // TODO: Promotion: Model 추가 필요
        // TODO: Favorite: model의 타입에 따른 데이터 가공

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


}
