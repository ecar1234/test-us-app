import 'package:flutter/material.dart';
import 'package:test_us_app/domain/entities/user_entity.dart';

import '../../../domain/entities/promotion_post_entity.dart';
import '../../../domain/entities/recruit_post_entity.dart';

class BasePostProvider extends ChangeNotifier {
  List<dynamic>? _favoritePost;
  List<RecruitPostEntity>? _recruitPosts;
  List<PromotionPostEntity>? _promotionPosts;

  List<RecruitPostEntity>? _userRecruitPosts;
  List<PromotionPostEntity>? _userPromotionPosts;

  List<dynamic>? get favoritePost => _favoritePost;

  List<RecruitPostEntity>? get recruitPosts => _recruitPosts;

  List<PromotionPostEntity>? get promotionPosts => _promotionPosts;

  List<RecruitPostEntity>? get userRecruitPosts => _userRecruitPosts;

  List<PromotionPostEntity>? get userPromotionPosts => _userPromotionPosts;

  void getInitPosts(
      List<dynamic> posts, List<RecruitPostEntity> recruitPosts, List<PromotionPostEntity> promotionPosts) {
    _favoritePost = posts;
    _recruitPosts = recruitPosts;
    _promotionPosts = promotionPosts;
    notifyListeners();
  }

  void setUserInitData(List<RecruitPostEntity>? recruitPosts, List<PromotionPostEntity>? promotionPosts) {
    _userRecruitPosts = recruitPosts;
    _userPromotionPosts = promotionPosts;

    notifyListeners();
  }

  void logout() {
    if (_userRecruitPosts!.isNotEmpty) {
      _userRecruitPosts!.clear();
      _userRecruitPosts = [];
    }
    if (_userPromotionPosts!.isNotEmpty) {
      _userPromotionPosts!.clear();
      _userPromotionPosts = [];
    }
    notifyListeners();
  }

  void createRecruitPost(RecruitPostEntity post) {
    _recruitPosts ??= [];
    _userRecruitPosts ??= [];

    if (_recruitPosts!.length < 10) {
      _recruitPosts = [post, ..._recruitPosts!];
      _userRecruitPosts = [post, ..._userRecruitPosts!];
      notifyListeners();
      return;
    }
    return;
  }

  void createPromotionPost(PromotionPostEntity post) {
    _promotionPosts ??= [];
    _userPromotionPosts ??= [];

    if (_promotionPosts!.length < 10) {
      _promotionPosts = [post, ..._promotionPosts!];
      _userPromotionPosts = [post, ..._userPromotionPosts!];
      notifyListeners();
      return;
    }
    return;
  }

  void updateRecruitPost(RecruitPostEntity post) {
    if (_favoritePost!.any((e) => e.id == post.id)) {
      List<dynamic> removedList = _favoritePost!.where((element) => element.id != post.id).toList();
      _favoritePost = [post, ...removedList];
    }
    if (_recruitPosts!.any((element) => element.id == post.id)) {
      List<RecruitPostEntity> removedList = _recruitPosts!.where((element) => element.id != post.id).toList();
      _recruitPosts = [post, ...removedList];
    }
    notifyListeners();
    return;
  }

  void updatePromotionPost(PromotionPostEntity post) {
    if (_favoritePost!.any((e) => e.id == post.id)) {
      List<dynamic> removedList = _favoritePost!.where((element) => element.id != post.id).toList();
      _favoritePost = [post, ...removedList];
    }
    if (_promotionPosts!.any((element) => element.id == post.id)) {
      final index = _promotionPosts?.indexWhere((element) => element.id == post.id);
      if (index == null) return;
      _promotionPosts!.removeAt(index);
      _promotionPosts = [post, ..._promotionPosts!];
    }
    notifyListeners();
    return;
  }

  void deleteRecruitPost(String id) {
    if (_favoritePost!.any((element) => element.id == id)) {
      _favoritePost = _favoritePost?.where((element) => element.id != id).toList();
    }
    if (_recruitPosts!.any((element) => element.id == id)) {
      _recruitPosts = _recruitPosts?.where((element) => element.id != id).toList();
    }
    if (_userRecruitPosts!.any((element) => element.id == id)) {
      _userRecruitPosts = _userRecruitPosts?.where((element) => element.id != id).toList();
    }
    notifyListeners();
    return;
  }

  void deletePromotionPost(String id) {
    if (_favoritePost!.any((element) => element.id == id)) {
      _favoritePost = _favoritePost?.where((element) => element.id != id).toList();
    }
    if (_promotionPosts!.any((element) => element.id == id)) {
      _promotionPosts = _promotionPosts?.where((element) => element.id != id).toList();
    }
    if (_userPromotionPosts!.any((element) => element.id == id)) {
      _userPromotionPosts = _userPromotionPosts?.where((element) => element.id != id).toList();
    }
    notifyListeners();
    return;
  }

  void updateUserRecruitPosts(RecruitPostEntity post) {
    final index = _userRecruitPosts?.indexWhere((element) => element.id == post.id);
    if (index == null) return;
    _userRecruitPosts!.removeAt(index);
    _userRecruitPosts = [post, ..._userRecruitPosts!];
    notifyListeners();
  }

  void updateUserPromotionPosts(PromotionPostEntity post) {
    final index = _userPromotionPosts?.indexWhere((element) => element.id == post.id);
    if (index == null) return;
    _userPromotionPosts!.removeAt(index);
    _userPromotionPosts = [post, ..._userPromotionPosts!];
    notifyListeners();
  }

  void userInfoUpdate(UserEntity user) {
    _favoritePost ??= [];
    _recruitPosts ?? [];
    _promotionPosts ?? [];

    bool updated = false;

    for (final post in _promotionPosts!) {
      if (post.author?.id == user.id) {
        post.author = user;
        updated = true;
      }
    }

    for (final post in _recruitPosts!) {
      if (post.author?.id == user.id) {
        post.author = user;
        updated = true;
      }
    }

    for (final post in _favoritePost!) {
      if (post.author?.id == user.id) {
        post.author = user;
        updated = true;
      }
    }

    if (updated) {
      // 핵심 포인트
      _promotionPosts = List<PromotionPostEntity>.from(_promotionPosts!);
      _recruitPosts = List<RecruitPostEntity>.from(_recruitPosts!);
      _favoritePost = List<dynamic>.from(_favoritePost!);

      notifyListeners();
    }
  }
}
