

import 'package:test_us_app/core/api_names.dart';
import 'package:test_us_app/data/data_sources/post_data/post_datasource.dart';
import 'package:test_us_app/data/models/post/post_model.dart';

import '../../../core/net_driver.dart';

class PostDataSourceImpl implements PostDataSource {
  final NetDriver netDriver;
  PostDataSourceImpl(this.netDriver);

  @override
  Future<Map<String, dynamic>> createPost(String token, PostModel post) async {
    final res = await netDriver.requestPostJson(token, PostApi.create, post.toJson());
    if (res['status'] == 200) {
      return {'status': 200, 'post': res['post']};
    } else {
      throw Exception('Error');
    }
  }

  @override
  Future<bool> deletePost(String token, String id) {
    // TODO: implement deletePost
    throw UnimplementedError();
  }

  @override
  Future<List<PostModel>> getPostAllData() async {
    final res = await netDriver.requestGetJson("", PostApi.getAllPosts);
    if (res['status'] == 200) {
      return res['posts'].map<PostModel>((e) => PostModel.fromJson(e)).toList();
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



}