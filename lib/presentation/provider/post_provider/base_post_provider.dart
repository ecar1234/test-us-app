
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
  Future<void> deleteRecruitPost(String id) async {
    _userRecruitPosts?.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}