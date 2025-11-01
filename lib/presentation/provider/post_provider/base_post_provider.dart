
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

  void setUserInitData(List<RecruitPostEntity>? recruitPosts, List<PromotionPostEntity>? promotionPosts) {
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

  void createRecruitPost(RecruitPostEntity post) {
    if(_recruitPosts!.length > 10){
      _recruitPosts = [post, ..._recruitPosts!];
      notifyListeners();
      return;
    }
    return;
  }
  void createPromotionPost(PromotionPostEntity post) {
    if(_promotionPosts!.length > 10){
      _promotionPosts = [post, ..._promotionPosts!];
      notifyListeners();
      return;
    }
    return;
  }
  void updateRecruitPost(RecruitPostEntity post) {
    if(_recruitPosts!.any((element) => element.id == post.id)){
      final index = _recruitPosts?.indexWhere((element) => element.id == post.id);
      if(index == null) return;
      _recruitPosts!.removeAt(index);
      _recruitPosts = [post, ..._recruitPosts!];
      notifyListeners();
      return;
    }
    return;
  }
  void updatePromotionPost(PromotionPostEntity post) {
    if(_promotionPosts!.any((element) => element.id == post.id)){
      final index = _promotionPosts?.indexWhere((element) => element.id == post.id);
      if(index == null) return;
      _promotionPosts!.removeAt(index);
      _promotionPosts = [post, ..._promotionPosts!];
      notifyListeners();
    }
    return;
  }
  void deleteRecruitPost(String id) {
    if(_recruitPosts!.any((element) => element.id == id)) {
      _recruitPosts = _recruitPosts?.where((element) => element.id != id).toList();
      notifyListeners();
    }else {
      return;
    }
  }
  void deletePromotionPost(String id) {
    if(_promotionPosts!.any((element) => element.id == id)){
      _promotionPosts = _promotionPosts?.where((element) => element.id != id).toList();
      notifyListeners();
    }else {
      return;
    }
  }

  void updateUserRecruitPosts (RecruitPostEntity post) {
    final index = _userRecruitPosts?.indexWhere((element) => element.id == post.id);
    if(index == null) return;
    _userRecruitPosts!.removeAt(index);
    _userRecruitPosts = [post, ..._userRecruitPosts!];
    notifyListeners();
  }
  void updateUserPromotionPosts (PromotionPostEntity post) {
    final index = _userPromotionPosts?.indexWhere((element) => element.id == post.id);
    if(index == null) return;
    _userPromotionPosts!.removeAt(index);
    _userPromotionPosts = [post, ..._userPromotionPosts!];
    notifyListeners();
  }

}