

import 'package:flutter/material.dart';
import 'package:test_us_app/domain/entities/promotion_post_entity.dart';

class PromotionPostProvider extends ChangeNotifier {
  List<PromotionPostEntity>? _promotionPosts;

  List<PromotionPostEntity>? get promotionPosts => _promotionPosts;

  void getInitPromotionPosts(List<PromotionPostEntity> posts){
    _promotionPosts = posts;
    notifyListeners();
  }
  Future<void> createPost(PromotionPostEntity post) async {
    _promotionPosts ??= [];
    _promotionPosts!.insert(0, post);
    notifyListeners();
  }

  void updatePost(PromotionPostEntity post) async {
    if (_promotionPosts!.any((element) => element.id == post.id)) {
      final idx = _promotionPosts!.indexWhere((e) {
        return e.id == post.id;
      });
      _promotionPosts![idx] = post;
    } else {
      _promotionPosts!.add(post);
    }
    notifyListeners();
  }

  Future<void> deletePost(String id) async {
    _promotionPosts!.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  void getPagination(List<PromotionPostEntity> posts, int page){
    if(page == 1){
      _promotionPosts = posts;
    }else{
      _promotionPosts!.addAll(posts);
    }
    notifyListeners();
  }
}