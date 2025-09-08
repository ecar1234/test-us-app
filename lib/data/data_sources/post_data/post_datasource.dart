

import '../../models/post/post_model.dart';

abstract class PostDataSource {
  Future<Map<String, List<PostModel>>> getPostsInitData();
  Future<List<PostModel>> getWebPosts(int page);
  Future<List<PostModel>> getMobilePosts(int page);
  Future<List<PostModel>> getPostsPagination(int page);
  Future<PostModel> getPostById(String token, String id);
  Future<List<PostModel>> getPostByTitle(String title);
  Future<Map<String, dynamic>> createPost(String token, PostModel post);
  Future<Map<String, dynamic>> updatePost(String token, PostModel post);
  Future<bool> deletePost(String token, String id);
}