

import 'package:test_us_app/domain/entities/post_entity.dart';

abstract class PostRepository{
  Future<Map<String, List<PostEntity>>> getPostInitData();
  Future<List<PostEntity>> getWebPosts(int page);
  Future<List<PostEntity>> getMobilePosts(int page);
  Future<List<PostEntity>> getPostPagination(int page);
  // Future<List<PostEntity>> getPostByPlatform(int page);
  Future<PostEntity> getPostById(String token, String id);
  Future<List<PostEntity>> getPostByTitle(String title);
  Future<Map<String, dynamic>> createPost(String token, PostEntity post);
  Future<Map<String, dynamic>> updatePost(String token, PostEntity post);
  Future<bool> deletePost(String token, String id);
}