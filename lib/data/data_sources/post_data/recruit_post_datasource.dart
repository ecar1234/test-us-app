

import 'package:image_picker/image_picker.dart';

import '../../models/post/image_model.dart';
import '../../models/post/post_model.dart';

abstract class RecruitPostDatasource {
  Future<Map<String, List<PostModel>>> getPostsInitData();
  Future<List<PostModel>> getUserRecruitmentPosts(String token, String userId);
  Future<List<PostModel>> getPostsPagination(int page);
  Future<PostModel> getPostById(String token, String id);
  Future<List<PostModel>> getPostByTitle(String title);
  Future<PostModel> createPost(String token, PostModel post);
  Future<PostModel> updatePost(String token, PostModel post);
  Future<bool> deletePost(String token, String id);

}