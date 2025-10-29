

import 'package:image_picker/image_picker.dart';
import 'package:test_us_app/domain/entities/recruit_post_entity.dart';

import '../entities/image_entity.dart';

abstract class RecruitPostRepository{
  Future<List<RecruitPostEntity>> getUserRecruitmentPosts(String token, String userId);
  Future<List<RecruitPostEntity>> getPostPagination(int page);
  // Future<List<PostEntity>> getPostByPlatform(int page);
  Future<RecruitPostEntity> getPostById(String token, String id);
  Future<List<RecruitPostEntity>> getPostByTitle(String title);
  Future<RecruitPostEntity> createPost(String token, RecruitPostEntity post, List<XFile> images);
  Future<RecruitPostEntity> updatePost(String token, RecruitPostEntity post, List<XFile> images, List<ImageEntity> oldImages);
  Future<bool> deletePost(String token, String id);
}