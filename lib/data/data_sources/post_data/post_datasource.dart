

import 'package:image_picker/image_picker.dart';

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
  Future<Map<String, dynamic>> registerPostImg(List<XFile> images);
  Future<Map<String, dynamic>> updatePostImg(List<XFile> images, List<Map<String, dynamic>> oldImgInfo);
  Future<Map<String, dynamic>> deletePostImg(Map<String, dynamic> imgInfo);
}