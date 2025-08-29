

import 'package:test_us_app/domain/entities/post_entity.dart';

abstract class PostRepository{
  Future<List<List<PostEntity>>> getPostInitData();
  Future<List<PostEntity>> getWebPosts(int page);
  Future<List<PostEntity>> getMobilePosts(int page);
  Future<List<PostEntity>> getPostPagination(int page);
  // Future<List<PostEntity>> getPostByPlatform(int page);
  Future<PostEntity> getPostById(String id);
  Future<List<PostEntity>> getPostByTitle(String title);
  Future<bool> createPost(String token, PostEntity post);
  Future<bool> updatePost(String token, PostEntity post);
  Future<bool> deletePost(String token, String id);
}