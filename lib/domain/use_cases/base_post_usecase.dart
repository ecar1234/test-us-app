

import '../repositories/base_post_repository.dart';

class BasePostUseCase {
  final BasePostRepository repository;

  BasePostUseCase(this.repository);

  Future<Map<String, dynamic>> getPostInitData() async {
    final initData = await repository.getPostInitData();
    return {'favoritePosts': initData['favoritePosts'], 'recruitPosts': initData['recruitPosts'], 'promotionPosts': initData['promotionPosts']};
  }

  Future<Map<String,dynamic>> getUserInitData (String token, String userId) async {
    final res = await repository.getUserInitData(token, userId);
    return res;
  }

  Future<Map<String,dynamic>> searchPost(String keyword) async {
    final res = await repository.searchPost(keyword);
    return res;
  }
}