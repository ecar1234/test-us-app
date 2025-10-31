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
  Future<List<RecruitPostModel>> getPostsPagination(int page, int size) async {
    final res = await netDriver.requestPostJson(page.toString(), RecruitPostApi.getPostsPagination,
        {'size': size, 'page': page});
    if (res['status'] == 200) {
      // logger.d(res['posts']);
      return (res['posts'] as List).map<RecruitPostModel>((e) => RecruitPostModel.fromJson(e)).toList();
    } else {
      throw Exception('Error');
    }
  }

  @override
  Future<RecruitPostModel> createPost(String token, RecruitPostModel post, List<XFile> images) async {
    final res = await netDriver.requestRegisterFormData(token, RecruitPostApi.createRecruitPost, images, post.toJson());
    if (res['status'] == 200) {
      return RecruitPostModel.fromJson(res['post']);
    } else {
      throw Exception('Error');
    }
  }

  @override
  Future<RecruitPostModel> updatePost(String token, RecruitPostModel post, List<XFile> images, List<ImageModel> oldModel) async {
    final deleteImages = oldModel.map((e) => e.toJson()).toList();
    final res = await netDriver.requestUpdateFormData(token, RecruitPostApi.update, post.toJson(), images, deleteImages);
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
}
