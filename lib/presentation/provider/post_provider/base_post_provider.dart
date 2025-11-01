
import 'package:flutter/material.dart';

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

  void getInitPosts(List<dynamic> posts, List<RecruitPostEntity> recruitPosts, List<PromotionPostEntity> promotionPosts) {
    _favoritePost = posts;
    _recruitPosts = recruitPosts;
    _promotionPosts = promotionPosts;
    notifyListeners();
  }

  Future<void> setUserInitData(List<RecruitPostEntity>? recruitPosts, List<PromotionPostEntity>? promotionPosts) async {
    _userRecruitPosts ??= [];
    _userPromotionPosts ??= [];

    if(recruitPosts != null) {
      _userRecruitPosts = recruitPosts;;
    }
    if(promotionPosts != null) {
      _userPromotionPosts = promotionPosts;
    }
    notifyListeners();
  }

  Future<void> createRecruitPost(RecruitPostEntity post) async {
    _recruitPosts = [post, ..._recruitPosts!];
    notifyListeners();
  }
  Future<void> createPromotionPost(PromotionPostEntity post) async {
    _promotionPosts = [post, ..._promotionPosts!];
    notifyListeners();
  }
  Future<void> updateRecruitPost(RecruitPostEntity post) async {
    final index = _recruitPosts?.indexWhere((element) => element.id == post.id);
    if(index == null) return;
     _recruitPosts!.removeAt(index);
    _recruitPosts = [post, ..._recruitPosts!];
    notifyListeners();
  }
  Future<void> updatePromotionPost(PromotionPostEntity post) async {
    final index = _promotionPosts?.indexWhere((element) => element.id == post.id);
    if(index == null) return;
     _promotionPosts!.removeAt(index);
    _promotionPosts = [post, ..._promotionPosts!];
    notifyListeners();
  }
  Future<void> deleteRecruitPost(String id) async {
    if(_recruitPosts!.any((element) => element.id == id)) {
      _recruitPosts = _recruitPosts?.where((element) => element.id != id).toList();
      notifyListeners();
    }else {
      return;
    }

  }
  Future<void> deletePromotionPost(String id) async {
    if(_promotionPosts!.any((element) => element.id == id)){
      _promotionPosts = _promotionPosts?.where((element) => element.id != id).toList();
      notifyListeners();
    }else {
      return;
    }
  }
}