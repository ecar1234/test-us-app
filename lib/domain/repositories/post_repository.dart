

import 'package:image_picker/image_picker.dart';
import 'package:test_us_app/domain/entities/post_entity.dart';

import '../entities/image_entity.dart';

abstract class PostRepository{
  Future<Map<String, List<PostEntity>>> getPostInitData();
  Future<List<PostEntity>> getUserRecruitmentPosts(String token, String userId);
  Future<List<PostEntity>> getPostPagination(int page);
  // Future<List<PostEntity>> getPostByPlatform(int page);
  Future<PostEntity> getPostById(String token, String id);
  Future<List<PostEntity>> getPostByTitle(String title);
  Future<PostEntity> createPost(String token, PostEntity post);
  Future<PostEntity> updatePost(String token, PostEntity post);
  Future<bool> deletePost(String token, String id);
  Future<PostEntity> registerPostImg(String token, List<XFile> images, String postId);
  Future<PostEntity> updatePostImg(String token, List<ImageEntity> deleteImages, List<XFile> images, String postId);
  Future<bool> deletePostImg(String token, List<ImageEntity> deleteImages);
}