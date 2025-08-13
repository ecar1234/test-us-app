

import '../../models/post/post_model.dart';

abstract class PostDataSource {
  Future<List<PostModel>> getPostAllData();
  Future<PostModel> getPostById(String id);
  Future<List<PostModel>> getPostByTitle(String title);
  Future<Map<String, dynamic>> createPost(String token, PostModel post);
  Future<bool> updatePost(String token, PostModel post);
  Future<bool> deletePost(String token, String id);
}