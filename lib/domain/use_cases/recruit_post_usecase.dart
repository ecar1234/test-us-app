import 'package:image_picker/image_picker.dart';
import 'package:test_us_app/data/models/package/recruit_post_applications_model.dart';

import '../entities/image_entity.dart';
import '../entities/recruit_post_entity.dart';
import '../repositories/recruit_post_repository.dart';

class RecruitPostUseCase {
  final RecruitPostRepository repository;

  RecruitPostUseCase(this.repository);

  Future<RecruitPostEntity> getPostById(String token, String id) async {
    final res = await repository.getPostById(token, id);
    return res;
  }

  Future<List<RecruitPostEntity>> getUserRecruitmentPosts(String token, String userId) async {
    final res = await repository.getUserRecruitmentPosts(token, userId);
    return res;
  }

  Future<RecruitPostEntity> updatePost(String token, RecruitPostEntity post, List<XFile> images, List<ImageEntity> oldImages) async {
    final res = await repository.updatePost(token, post, images, oldImages);
    return res;
  }

  Future<RecruitPostEntity> endPost(String token, String id) async {
    final res = await repository.endPost(token, id);
    return res;
  }

  Future<bool> deletePost(String token, String id) async {
    final res = await repository.deletePost(token, id);
    return res;
  }

  Future<RecruitPostEntity> createPost(String token, RecruitPostEntity post, List<XFile> images) async {
    final res = await repository.createPost(token, post, images);
    return res;
  }

  // Future<PostEntity> getPostById(String id) async {
  //   final res = await repository.getPostById(id);
  //   return res;
  // }
  Future<List<RecruitPostEntity>> getPostByTitle(String title) async {
    final res = await repository.getPostByTitle(title);
    return res;
  }

  Future<List<RecruitPostEntity>> getPostPagination(int page, int size) async {
    final res = await repository.getPostPagination(page, size);
    return res;
  }

  Future<List<RecruitPostEntity>> getAppRecruitPosts(String token, List<String> ids) async {
    final res = await repository.getAppRecruitPosts(token, ids);
    return res;
  }

  Future<List<TResRecruitPostApplicationsInfo>> getPostApplicationsInfoByPostId(String token, String postId) async {
    final res = await repository.getPostApplicationsInfo(token, postId);
    return res;
  }
}
