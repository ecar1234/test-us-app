

import 'package:image_picker/image_picker.dart';
import 'package:test_us_app/domain/entities/post_entity.dart';

abstract class PostRepository{
  Future<Map<String, List<PostEntity>>> getPostInitData();
  Future<List<PostEntity>> getWebPosts(int page);
  Future<List<PostEntity>> getMobilePosts(int page);
  Future<List<PostEntity>> getPostPagination(int page);
  // Future<List<PostEntity>> getPostByPlatform(int page);
  Future<PostEntity> getPostById(String token, String id);
  Future<List<PostEntity>> getPostByTitle(String title);
  Future<PostEntity> createPost(String token, PostEntity post);
  Future<PostEntity> updatePost(String token, PostEntity post);
  Future<bool> deletePost(String token, String id);
  Future<List<Map<String, dynamic>>> registerPostImg(String token, List<XFile> images, String postId);
  Future<List<Map<String, dynamic>>> updatePostImg(String token, List<XFile> images, List<Map<String, dynamic>> oldImgInfo);
  Future<bool> deletePostImg(String token, Map<String, dynamic> imgInfo);
}