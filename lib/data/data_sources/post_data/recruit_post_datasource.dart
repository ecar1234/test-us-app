

import 'package:image_picker/image_picker.dart';

import '../../models/image/image_model.dart';
import '../../models/post/recruit_post_model.dart';

abstract class RecruitPostDatasource {
  Future<Map<String, List<dynamic>>> getPostsInitData();
  Future<List<RecruitPostModel>> getUserRecruitmentPosts(String token, String userId);
  Future<List<RecruitPostModel>> getPostsPagination(int page);
  Future<RecruitPostModel> getPostById(String token, String id);
  Future<List<RecruitPostModel>> getPostByTitle(String title);
  Future<RecruitPostModel> createPost(String token, RecruitPostModel post, List<XFile> images);
  Future<RecruitPostModel> updatePost(String token, RecruitPostModel post, List<XFile> images, List<ImageModel> oldImages);
  Future<bool> deletePost(String token, String id);

}