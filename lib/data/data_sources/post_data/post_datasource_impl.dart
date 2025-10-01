import 'dart:async';
import 'dart:convert';

import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:test_us_app/core/api_names.dart';
import 'package:test_us_app/data/data_sources/post_data/post_datasource.dart';
import 'package:test_us_app/data/models/post/post_model.dart';

import '../../../core/net_driver.dart';
import '../../models/post/image_model.dart';

class PostDataSourceImpl implements PostDataSource {
  final logger = Logger();
  final NetDriver netDriver;

  PostDataSourceImpl(this.netDriver);

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
  Future<Map<String, List<PostModel>>> getPostsInitData() async {
    final res = await netDriver.requestGetJson("", PostApi.getInitPosts);

    if (res['status'] == 202) {
      final jobId = res['jobId'];
      final data = await _startPolling(jobId, "");
      return {'favoritePosts': data['favoritePosts']!, 'posts': data['posts']!};
    } else {
      throw Exception('Error');
    }

    // if (res['status'] == 200) {
    // List<PostModel> favoritePosts = (res['favoritePosts'] as List).map<PostModel>((e) => PostModel.fromJson(e)).toList();
    // List<PostModel> posts = (res['posts'] as List).map<PostModel>((e) => PostModel.fromJson(e)).toList();
    //   return {'favoritePosts': favoritePosts, 'posts': posts};
    // } else {
    //   throw Exception('Error');
    // }
  }

  @override
  Future<PostModel> getPostById(String token, String id) async {
    final res = await netDriver.requestGetJson(token, PostApi.getPostById, parma: id);
    if (res['status'] == 200) {
      return PostModel.fromJson(res['post']);
    } else {
      throw Exception('Error');
    }
  }

  @override
  Future<List<PostModel>> getPostByTitle(String title) {
    // TODO: implement getPostByTitle
    throw UnimplementedError();
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
  Future<List<PostModel>> getWebPosts(int page) async {
    final res = await netDriver.requestGetJson(page.toString(), PostApi.getWebPosts);
    if (res['status'] == 200) {
      return (res['posts'] as List).map<PostModel>((e) => PostModel.fromJson(e)).toList();
    } else {
      throw Exception('Error');
    }
  }

  @override
  Future<List<PostModel>> getMobilePosts(int page) async {
    final res = await netDriver.requestGetJson(page.toString(), PostApi.getMobilePosts);
    if (res['status'] == 200) {
      return (res['posts'] as List).map<PostModel>((e) => PostModel.fromJson(e)).toList();
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
  Future<bool> deletePostImg(String token, List<Map<String, dynamic>> deleteImages) async {
    final res = await netDriver.requestImagesDeleteFormData(token, PostApi.deletePostImg, deleteImages);
    if (res['status'] == 200) {
      return res['result'];
    } else {
      throw Exception('Error');
    }
  }

  @override
  Future<PostModel> registerPostImg(String token, List<XFile> images, String postId) async {
    final res = await netDriver.requestImagesRegisterFormData(token, PostApi.registerPostImg, images, postId);
    if (res['status'] == 200) {
      return PostModel.fromJson(res['post']);
    } else {
      throw Exception('Error');
    }
  }

  @override
  Future<PostModel> updatePostImg(
      String token, List<ImageModel> deleteImages, List<XFile> images, String postId) async {
    try {
      final deleteData = deleteImages.map((e) => e.toJson()).toList();
      final res = await netDriver.requestImagesUpdateFormData(token, PostApi.updatePostImg, deleteData, images, postId);
      if (res['status'] == 200) {
        return PostModel.fromJson(res['post']);
      } else {
        throw Exception('Error');
      }
    } on Exception catch (e) {
      // TODO
      logger.e(e);
      rethrow;
    }
  }

  Future<Map<String, List<PostModel>>> _startPolling(String jobId, String token) {
    final controller = Completer<Map<String, List<PostModel>>>();
    Timer.periodic(Duration(seconds: 2), (timer) async {
      final res = await netDriver.requestGetJson(token, JobApi.jobGetInitPosts, parma: jobId);
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
