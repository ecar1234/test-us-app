
import 'package:logger/logger.dart';
import 'package:test_us_app/core/api_names.dart';
import 'package:test_us_app/data/data_sources/post_data/post_datasource.dart';
import 'package:test_us_app/data/models/post/post_model.dart';

import '../../../core/net_driver.dart';

class PostDataSourceImpl implements PostDataSource {
  final logger = Logger();
  final NetDriver netDriver;
  PostDataSourceImpl(this.netDriver);

  @override
  Future<Map<String, dynamic>> createPost(String token, PostModel post) async {
    final res = await netDriver.requestPostJson(token, PostApi.create, post.toJson());
    if (res['status'] == 200) {
      return res;
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
  Future<List<PostModel>> getPostsInitData() async {
    final res = await netDriver.requestGetJson("", PostApi.getInitPosts);

    // List<PostModel> posts = [];
    List<PostModel> favoritePosts = [];

    if (res['status'] == 200) {
      favoritePosts = (res['favoritePosts'] as List).map<PostModel>((e) => PostModel.fromJson(e)).toList();
      return favoritePosts;
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
  Future<Map<String, dynamic>> updatePost(String token, PostModel post) async {
    final res = await netDriver.requestPutJson(token, PostApi.update, post.toJson());
    if (res['status'] == 200) {
      return {'status': true, 'post': res['post']};
    } else {
      throw Exception('Error');
    }
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
  Future<List<PostModel>> getPostsPagination(int page) async {
    final res = await netDriver.requestGetJson(page.toString(), PostApi.getPostsPagination);
    if(res['status'] == 200){
      // logger.d(res['posts']);
      return (res['posts'] as List).map<PostModel>((e) => PostModel.fromJson(e)).toList();
    }else {
      throw Exception('Error');
    }
  }
}