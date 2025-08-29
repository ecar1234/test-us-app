

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:test_us_app/core/api_names.dart';
import 'package:test_us_app/data/data_sources/post_data/post_datasource.dart';
import 'package:test_us_app/data/models/post/post_model.dart';

import '../../../core/net_driver.dart';

class PostDataSourceImpl implements PostDataSource {
  final NetDriver netDriver;
  PostDataSourceImpl(this.netDriver);

  @override
  Future<bool> createPost(String token, PostModel post) async {
    final res = await netDriver.requestPostJson(token, PostApi.create, post.toJson());
    if (res['status'] == 200) {
      return true;
    } else {
      throw false;
    }
  }

  @override
  Future<bool> deletePost(String token, String id) {
    // TODO: implement deletePost
    throw UnimplementedError();
  }

  @override
  Future<List<List<PostModel>>> getPostsInitData() async {
    final res = await netDriver.requestGetJson("", PostApi.getInitPosts);

    List<PostModel> webPosts = [];
    List<PostModel> mobilePosts = [];
    List<PostModel> favoritePosts = [];

    if (res['status'] == 200) {
      webPosts = (res['webPosts'] as List).map<PostModel>((e) => PostModel.fromJson(e)).toList();
      mobilePosts = (res['mobilePosts'] as List).map<PostModel>((e) => PostModel.fromJson(e)).toList();
      favoritePosts = (res['favoritePosts'] as List).map<PostModel>((e) => PostModel.fromJson(e)).toList();
      return [webPosts, mobilePosts, favoritePosts];
    } else {
      throw Exception('Error');
    }
  }

  @override
  Future<PostModel> getPostById(String id) {
    // TODO: implement getPostById
    throw UnimplementedError();
  }

  @override
  Future<List<PostModel>> getPostByTitle(String title) {
    // TODO: implement getPostByTitle
    throw UnimplementedError();
  }

  @override
  Future<bool> updatePost(String token, PostModel post) {
    // TODO: implement updatePost
    throw UnimplementedError();
  }

  @override
  Future<List<PostModel>> getWebPosts(int page) async {
    final res = await netDriver.requestGetJson(page.toString(), PostApi.getWebPosts);
    if(res['status'] == 200){
      return (res['posts'] as List).map<PostModel>((e) => PostModel.fromJson(e)).toList();
    }else {
      throw Exception('Error');
    }
  }

  @override
  Future<List<PostModel>> getMobilePosts(int page) async {
    final res = await netDriver.requestGetJson(page.toString(), PostApi.getMobilePosts);
    if(res['status'] == 200){
      return (res['posts'] as List).map<PostModel>((e) => PostModel.fromJson(e)).toList();
    }else {
      throw Exception('Error');
    }
  }
  @override
  Future<List<PostModel>> getPostsPagination(int page) {
    // TODO: implement getPostsPagination
    throw UnimplementedError();
  }
}