import 'dart:async';
import 'dart:convert';

import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:test_us_app/core/api_names.dart';
import 'package:test_us_app/data/data_sources/post_data/recruit_post_datasource.dart';
import 'package:test_us_app/data/models/post/post_model.dart';

import '../../../core/net_driver.dart';
import '../../models/post/image_model.dart';

class RecruitPostDatasourceImpl implements RecruitPostDatasource {
  final logger = Logger();
  final NetDriver netDriver;

  RecruitPostDatasourceImpl(this.netDriver);

  @override
  Future<Map<String, List<PostModel>>> getPostsInitData() async {
    final res = await netDriver.requestGetJson("", PostApi.getInitPosts);

    if (res['status'] == 202) {
      final jobId = res['jobId'];
      final data = await _startPolling(jobId, "");
      return {'favoritePosts': data['favoritePosts']!, 'posts': data['posts']!};
    } else {
      throw Exception('Error');
    }
  }

  @override
  Future<List<PostModel>> getPostsPagination(int page) async {
    final res = await netDriver.requestGetJson(page.toString(), PostApi.getPostsPagination);
    if (res['status'] == 200) {
      // logger.d(res['posts']);
      return (res['posts'] as List).map<PostModel>((e) => PostModel.fromJson(e)).toList();
    } else {
      throw Exception('Error');
    }
  }

  @override
  Future<PostModel> createPost(String token, PostModel post) async {
    final res = await netDriver.requestPostJson(token, PostApi.create, post.toJson());
    if (res['status'] == 200) {
      return PostModel.fromJson(res['post']);
    } else {
      throw Exception('Error');
    }
  }

  @override
  Future<PostModel> updatePost(String token, PostModel post) async {
    final res = await netDriver.requestPutJson(token, PostApi.update, post.toJson());
    if (res['status'] == 200) {
      return PostModel.fromJson(res['post']);
    } else {
      throw Exception('Error');
    }
  }

  @override
  Future<bool> deletePost(String token, String id) async {
    final data = {"id": id};
    final res = await netDriver.requestPostJson(token, PostApi.delete, data);
    if (res['status'] == 200) {
      return true;
    } else {
      throw false;
    }
  }

  @override
  Future<PostModel> getPostById(String token, String id) async {
    final res = await netDriver.requestGetJson(token, PostApi.getPostById, param: id);
    if (res['status'] == 200) {
      return PostModel.fromJson(res['post']);
    } else {
      throw Exception('Error');
    }
  }

  @override
  Future<List<PostModel>> getUserRecruitmentPosts(String token, String userId) async {
    final res = await netDriver.requestGetJson(token, PostApi.getUserRecruitmentPosts, param: userId);
    if (res['status'] == 200) {
      if(res['posts'] == null || res['posts'] == []){
        return [];
      }
      return (res['posts'] as List).map<PostModel>((e) => PostModel.fromJson(e)).toList();
    } else {
      throw Exception('Error');
    }
  }

  @override
  Future<List<PostModel>> getPostByTitle(String title) {
    // TODO: implement getPostByTitle
    throw UnimplementedError();
  }

  Future<Map<String, List<PostModel>>> _startPolling(String jobId, String token) {
    final controller = Completer<Map<String, List<PostModel>>>();
    Timer.periodic(Duration(seconds: 2), (timer) async {
      final res = await netDriver.requestGetJson(token, JobApi.jobGetInitPosts, param: jobId);
      if (res['status'] == 200) {
        final posts = (res['posts'] as List).map<PostModel>((e) => PostModel.fromJson(e)).toList();
        final favoritePosts = (res['favoritePosts'] as List).map<PostModel>((e) => PostModel.fromJson(e)).toList();
        final result = {'posts': posts, 'favoritePosts': favoritePosts};
        controller.complete(result);
        timer.cancel();
      }
    });
    return controller.future;
  }


}
