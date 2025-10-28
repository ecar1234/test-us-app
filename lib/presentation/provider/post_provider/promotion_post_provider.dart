

import 'package:flutter/material.dart';
import 'package:test_us_app/domain/entities/promotion_post_entity.dart';

class PromotionPostProvider extends ChangeNotifier {
  List<PromotionPostEntity>? _promotionPosts;

  List<PromotionPostEntity>? get promotionPosts => _promotionPosts;

  void getInitPromotionPosts(List<PromotionPostEntity> posts){
    _promotionPosts = posts;
    notifyListeners();
  }

}