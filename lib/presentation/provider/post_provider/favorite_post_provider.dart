
import 'package:flutter/material.dart';

import '../../../domain/entities/recruit_post_entity.dart';

class FavoritePostProvider extends ChangeNotifier {
  List<dynamic>? _favoritePost;
  List<dynamic>? get favoritePost => _favoritePost;

  void getInitFavoritePosts(List<dynamic> posts) {
    _favoritePost = posts;
    notifyListeners();
  }
}