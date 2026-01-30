import 'package:flutter/material.dart';
import 'package:test_us_app/domain/entities/recruit_post_entity.dart';
import 'package:image_picker/image_picker.dart';

import '../../../domain/entities/image_entity.dart';
import '../../../domain/use_cases/recruit_post_usecase.dart';

class RecruitPostProvider with ChangeNotifier {
  final RecruitPostUseCase useCase;

  RecruitPostProvider(this.useCase);

  List<RecruitPostEntity>? _initPosts;
  List<RecruitPostEntity>? _recruitmentPosts;

  List<RecruitPostEntity>? get initPosts => _initPosts;
  List<RecruitPostEntity>? get recruitmentPosts => _recruitmentPosts;

  Future<void> getInitPosts(List<RecruitPostEntity> posts) async {
    _recruitmentPosts ??= [];
    _recruitmentPosts = posts;
    notifyListeners();
  }

  Future<RecruitPostEntity> getPostById(String token, String id) async {
    final res = await useCase.getPostById(token, id);
    return res;
  }

  void getUserRecruitmentPosts(List<RecruitPostEntity> posts) async {
    _recruitmentPosts = [...posts];
    notifyListeners();
  }

  Future<void> getPostPagination(List<RecruitPostEntity> posts, int page) async {
    if(page == 1 && _recruitmentPosts == null){
      _recruitmentPosts = posts;
    }else if(page == 1 && _recruitmentPosts != null){
      _recruitmentPosts = posts;
    }
    if(page > 1){
      _recruitmentPosts = [..._recruitmentPosts!, ...posts];
    }
    notifyListeners();
  }

  Future<void> refreshPosts() async {
    _recruitmentPosts = null;
    notifyListeners();
  }

  Future<void> createPost(RecruitPostEntity post) async {
    _recruitmentPosts ??= [];
    _recruitmentPosts!.insert(0, post);
    notifyListeners();
  }

  void updatePost(RecruitPostEntity post) async {
    if (_recruitmentPosts!.any((element) => element.id == post.id)) {
      final idx = _recruitmentPosts!.indexWhere((e) {
        return e.id == post.id;
      });
      _recruitmentPosts![idx] = post;
    } else {
      _recruitmentPosts!.add(post);
    }
    notifyListeners();
  }

  Future<void> deletePost(String id) async {
    _recruitmentPosts!.removeWhere((element) => element.id == id);
    notifyListeners();
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
