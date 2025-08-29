

import '../../models/post/post_model.dart';

abstract class PostDataSource {
  Future<List<List<PostModel>>> getPostsInitData();
  Future<List<PostModel>> getWebPosts(int page);
  Future<List<PostModel>> getMobilePosts(int page);
  Future<List<PostModel>> getPostsPagination(int page);
  Future<PostModel> getPostById(String id);
  Future<List<PostModel>> getPostByTitle(String title);
  Future<bool> createPost(String token, PostModel post);
  Future<bool> updatePost(String token, PostModel post);
  Future<bool> deletePost(String token, String id);
}