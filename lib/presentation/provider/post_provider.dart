import 'package:flutter/material.dart';
import 'package:test_us_app/domain/entities/post_entity.dart';

import '../../domain/use_cases/post_usecase.dart';

class PostProvider with ChangeNotifier {
  final PostUseCase useCase;

  PostProvider(this.useCase);

  final List<PostEntity> _webPost = [];
  final List<PostEntity> _mobilePost = [];

  List<PostEntity> get webPost => _webPost;
  List<PostEntity> get mobilePost => _mobilePost;

  Future<void> getPosts() async {
    final res = await useCase.getPostAllData();
    res.map((post) => {
          if (post.platform!.any((p) => p == 'web'))
            {_webPost.add(post)}
          else
            {_mobilePost.add(post)}
        });
  }

  Future<int> createPost(String token, PostEntity post) async {
    final res = await useCase.createPost(token, post);
    if (res['status'] == 200) {
      if (post.platform == 'web') {
        _webPost.add(res['post']);
      } else {
        _mobilePost.add(res['post']);
      }
      return 200;
    } else {
      return 500;
    }
  }
}
