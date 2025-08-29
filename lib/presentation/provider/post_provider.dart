import 'package:flutter/material.dart';
import 'package:test_us_app/domain/entities/post_entity.dart';

import '../../domain/use_cases/post_usecase.dart';

class PostProvider with ChangeNotifier {
  final PostUseCase useCase;

  PostProvider(this.useCase);
  final List<PostEntity> _posts = [];
  // final List<PostEntity> _webPost = [];
  // final List<PostEntity> _mobilePost = [];
  final List<PostEntity> _favoritePost = [];

  // List<PostEntity> get webPost => _webPost;
  // List<PostEntity> get mobilePost => _mobilePost;
  List<PostEntity> get favoritePost => _favoritePost;
  List<PostEntity> get posts => _posts;

  Future<void> getInitPosts() async {
    final res = await useCase.getPostInitData();
    // _webPost.clear();
    // _mobilePost.clear();
    // _webPost.addAll(res[0]);
    // _mobilePost.addAll(res[1]);
    _favoritePost.clear();
    _favoritePost.addAll(res[2]);
    notifyListeners();
  }

  Future<void> getWebPosts({int page = 1}) async {
    final res = await useCase.getWebPosts(page);
    // _webPost.clear();
    // _webPost.addAll(res);
    notifyListeners();
  }
  Future<void> getMobilePosts({int page = 1}) async {
    final res = await useCase.getMobilePosts(page);
    // _mobilePost.clear();
    // _mobilePost.addAll(res);
    notifyListeners();
  }
  Future<void> getPostPagination({int page = 1}) async {
    final res = await useCase.getPostPagination(page);
    // _mobilePost.clear();
    // _mobilePost.addAll(res);
    notifyListeners();
  }

  Future<bool> createPost(String token, PostEntity post) async {
    final res = await useCase.createPost(token, post);
    return res;
  }
}
