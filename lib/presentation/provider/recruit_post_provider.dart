import 'package:flutter/material.dart';
import 'package:test_us_app/domain/entities/post_entity.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/entities/image_entity.dart';
import '../../domain/use_cases/recruit_post_usecase.dart';

class RecruitPostProvider with ChangeNotifier {
  final RecruitPostUseCase useCase;

  RecruitPostProvider(this.useCase);

  List<PostEntity>? _posts;
  List<PostEntity>? _favoritePost;
  List<PostEntity>? _recruitmentPosts;

  List<PostEntity>? get posts => _posts;
  List<PostEntity>? get favoritePost => _favoritePost;
  List<PostEntity>? get recruitmentPosts => _recruitmentPosts;

  Future<List<PostEntity>?> getInitPosts() async {
    final res = await useCase.getPostInitData();
    _favoritePost = res['favoritePosts'];
    _posts = res['posts'];
    notifyListeners();
    return res['posts'];
  }

  Future<PostEntity> getPostById(String token, String id) async {
    final res = await useCase.getPostById(token, id);
    return res;
  }

  Future<List<PostEntity>?> getUserRecruitmentPosts(String token, String userId) async {
    final res = await useCase.getUserRecruitmentPosts(token, userId);
    _recruitmentPosts = res;
    notifyListeners();
    return res;
  }

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

  void createPost(PostEntity post) async {
    _posts!.add(post);
    notifyListeners();
  }

  void updatePost(PostEntity post) async {
    if (_posts!.any((element) => element.id == post.id)) {
      final idx = _posts!.indexWhere((e) {
        return e.id == post.id;
      });
      _posts![idx] = post;
    } else {
      _posts!.add(post);
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

  // Future<PostEntity> registerPostImg(String token, List<XFile> images, String postId) async {
  //   final res = await useCase.registerPostImg(token, images, postId);
  //   if(_posts!.any((element) => element.id == postId)){
  //     final idx = _posts!.indexWhere((e) {
  //       return e.id == postId;
  //     });
  //     _posts![idx] = res;
  //     notifyListeners();
  //   }
  //   return res;
  // }
  //
  // Future<PostEntity> updatePostImg(String token, List<ImageEntity> deleteImages, List<XFile> images, String postId) async {
  //   final res = await useCase.updatePostImg(token, deleteImages, images, postId);
  //   if(_posts!.any((element) => element.id == postId)){
  //     final idx = _posts!.indexWhere((e) {
  //       return e.id == postId;
  //     });
  //     _posts![idx] = res;
  //     notifyListeners();
  //   }
  //   return res;
  // }

  // Future<bool> deletePostImg(String token, List<ImageEntity> deleteImages) async {
  //   final res = await useCase.deletePostImg(token, deleteImages);
  //   return res;
  // }
}
