import 'package:flutter/material.dart';
import 'package:test_us_app/domain/entities/post_entity.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/use_cases/post_usecase.dart';

class PostProvider with ChangeNotifier {
  final PostUseCase useCase;

  PostProvider(this.useCase);

  List<PostEntity>? _posts;
  List<PostEntity>? _favoritePost;

  List<PostEntity>? get favoritePost => _favoritePost;

  List<PostEntity>? get posts => _posts;

  Future<void> getInitPosts() async {
    final res = await useCase.getPostInitData();
    _favoritePost = res['favoritePosts'];
    _posts = res['posts'];
    notifyListeners();
  }

  Future<PostEntity> getPostById(String token, String id) async {
    final res = await useCase.getPostById(token, id);
    return res;
  }

  // Future<void> getWebPosts({int page = 1}) async {
  //   final res = await useCase.getWebPosts(page);
  //   // _webPost.clear();
  //   // _webPost.addAll(res);
  //   notifyListeners();
  // }
  //
  // Future<void> getMobilePosts({int page = 1}) async {
  //   final res = await useCase.getMobilePosts(page);
  //   // _mobilePost.clear();
  //   // _mobilePost.addAll(res);
  //   notifyListeners();
  // }

  Future<void> getPostPagination({int page = 1}) async {
    final res = await useCase.getPostPagination(page);
    // _mobilePost.clear();
    // _mobilePost.addAll(res);
    if (_posts == null) {
      _posts = [];
      _posts!.addAll(res);
    } else {
      _posts!.addAll(res);
    }
    notifyListeners();
  }

  Future<PostEntity> createPost(String token, PostEntity post) async {
    final res = await useCase.createPost(token, post);
    _posts!.add(res);
    notifyListeners();
    return res;
  }

  Future<void> updatePost(String token, PostEntity post) async {
    final res = await useCase.updatePost(token, post);
    if (_posts!.any((element) => element.id == post.id)) {
     final idx =  _posts!.indexWhere((e) {
        return e.id == post.id;
      });
      _posts![idx] = res;
    }else {
      _posts!.add(res);
    }
    notifyListeners();
  }

  Future<bool> deletePost(String token, String id) async {
    final res = await useCase.deletePost(token, id);
    if (res && _posts!.any((element) => element.id == id)) {
      _posts!.removeWhere((element) => element.id == id);
    }
    notifyListeners();
    return res;
  }

  Future<List<Map<String, dynamic>>> registerPostImg(String token, List<XFile> images, String postId) async {
    final res = await useCase.registerPostImg(token, images, postId);
    return res;
  }

  Future<List<Map<String, dynamic>>> updatePostImg(
      String token, List<XFile> images, List<Map<String, dynamic>> oldImgInfo) async {
    final res = await useCase.updatePostImg(token, images, oldImgInfo);
    return res;
  }

  Future<bool> deletePostImg(String token, Map<String, dynamic> imgInfo) async {
    final res = await useCase.deletePostImg(token, imgInfo);
    return res;
  }
}
