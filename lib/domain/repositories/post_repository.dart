

import 'package:test_us_app/domain/entities/post_entity.dart';

abstract class PostRepository{
  Future<List<PostEntity>> getPostAllData();
  Future<PostEntity> getPostById(String id);
  Future<List<PostEntity>> getPostByTitle(String title);
  Future<Map<String, dynamic>> createPost(String token, PostEntity post);
  Future<bool> updatePost(String token, PostEntity post);
  Future<bool> deletePost(String token, String id);
}